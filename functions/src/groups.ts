import { logger } from "firebase-functions/v2";
import {
  DAILY_PASS_RATIO,
  GROUP_SIZE,
  KICK_AFTER_MISSED,
  LATE_SETUP_HOURS,
  MAX_SETUP_ROUNDS,
  MIN_TO_START,
  REFILL_BELOW,
  REFILL_MAX_DAY,
  SETUP_HOURS,
  TEST_DAYS,
  TRUST,
} from "./config";
import { notify, notifyMany } from "./notify";
import { addStrike, applyTrust, tierFor } from "./trust";
import {
  AppActivity,
  DayResult,
  FORM_EARLY_AFTER_MS,
  Group,
  Member,
  Tier,
  Timestamp,
  addDays,
  addEvent,
  dayKey,
  db,
  diffDays,
  FieldValue,
  groupRef,
  hoursFromNow,
  isLive,
  memberRef,
  passThreshold,
  requiredAppsOn,
  visibleApps,
} from "./util";

// ---------------------------------------------------------------------------
// Loading helpers
// ---------------------------------------------------------------------------

export async function loadGroup(groupId: string): Promise<Group | null> {
  const s = await groupRef(groupId).get();
  return s.exists ? (s.data() as Group) : null;
}

export async function loadMembers(groupId: string): Promise<Member[]> {
  const s = await groupRef(groupId).collection("members").get();
  return s.docs.map((d) => d.data() as Member);
}

function activityRef(groupId: string, uid: string, day: string) {
  return groupRef(groupId).collection("activity").doc(`${uid}_${day}`);
}

async function loadActivity(groupId: string, uid: string, day: string): Promise<Record<string, AppActivity>> {
  const s = await activityRef(groupId, uid, day).get();
  return (s.get("apps") as Record<string, AppActivity> | undefined) ?? {};
}

// ---------------------------------------------------------------------------
// Queue -> group
// ---------------------------------------------------------------------------

interface Candidate {
  uid: string;
  queueRef: FirebaseFirestore.DocumentReference;
  member: Member;
}

/** Reads queue entries for a tier inside a transaction and turns valid ones into member drafts. */
async function takeFromQueue(
  tx: FirebaseFirestore.Transaction,
  tier: Tier,
  limit: number,
  late: boolean,
): Promise<{ valid: Candidate[]; oldestJoinedMs: number }> {
  const q = await tx.get(
    db.collection("queue").where("tier", "==", tier).orderBy("priorityAt").limit(limit + 10),
  );
  const valid: Candidate[] = [];
  const invalid: FirebaseFirestore.DocumentReference[] = [];
  let oldestJoinedMs = Number.MAX_SAFE_INTEGER;

  const loaded = await Promise.all(
    q.docs.map(async (d) => {
      const uid = d.id;
      const appId = d.get("appId") as string;
      const [user, profile, app] = await Promise.all([
        tx.get(db.collection("users").doc(uid)),
        tx.get(db.collection("profiles").doc(uid)),
        tx.get(db.collection("apps").doc(appId)),
      ]);
      return { d, uid, user, profile, app };
    }),
  );

  for (const { d, uid, user, profile, app } of loaded) {
    const ok =
      user.exists &&
      profile.exists &&
      app.exists &&
      app.get("ownerUid") === uid &&
      !user.get("banned") &&
      !user.get("currentGroupId");
    if (!ok) {
      invalid.push(d.ref);
      continue;
    }
    if (valid.length >= limit) continue;
    const joined = (d.get("joinedAt") as Timestamp).toMillis();
    oldestJoinedMs = Math.min(oldestJoinedMs, joined);
    valid.push({
      uid,
      queueRef: d.ref,
      member: {
        uid,
        email: user.get("email"),
        displayName: profile.get("displayName") ?? "Tester",
        photoUrl: profile.get("photoUrl") ?? null,
        trustScore: profile.get("trustScore") ?? TRUST.start,
        appId: app.id,
        appName: app.get("name"),
        packageName: app.get("packageName"),
        optInWebUrl: app.get("optInWebUrl"),
        optInPlayUrl: app.get("optInPlayUrl"),
        iconUrl: app.get("iconUrl") ?? null,
        testNotes: app.get("testNotes") ?? "",
        state: "setup",
        late,
        joinedAt: Timestamp.now(),
        setupDeadline: hoursFromNow(late ? LATE_SETUP_HOURS : SETUP_HOURS),
        emailsAdded: false,
        emailsAddedVersion: 0,
        installedAll: false,
        ready: false,
        activeSince: null,
        consecutiveMissed: 0,
        missedDays: 0,
        activeDays: 0,
        warnings: 0,
        feedbackTo: {},
        lastDays: [],
        today: null,
        removedReason: null,
      },
    });
  }
  invalid.forEach((r) => tx.delete(r));
  return { valid, oldestJoinedMs };
}

function writeMembers(tx: FirebaseFirestore.Transaction, groupId: string, cands: Candidate[]) {
  for (const c of cands) {
    tx.set(memberRef(groupId, c.uid), c.member);
    tx.update(db.collection("users").doc(c.uid), { currentGroupId: groupId });
    tx.update(db.collection("profiles").doc(c.uid), { "stats.groupsJoined": FieldValue.increment(1) });
    tx.delete(c.queueRef);
  }
}

/** Forms one group for the tier if the queue allows it. Returns the new group id or null. */
export async function tryFormGroup(tier: Tier): Promise<string | null> {
  const ref = db.collection("groups").doc();
  const formed = await db.runTransaction(async (tx) => {
    const { valid, oldestJoinedMs } = await takeFromQueue(tx, tier, GROUP_SIZE, false);
    const waitedLong = Date.now() - oldestJoinedMs >= FORM_EARLY_AFTER_MS;
    if (valid.length < GROUP_SIZE && !(valid.length >= MIN_TO_START && waitedLong)) return null;
    const group: Group = {
      tier,
      status: "setup",
      createdAt: Timestamp.now(),
      setupDeadline: hoursFromNow(SETUP_HOURS),
      setupRounds: 0,
      rosterVersion: 1,
      startDay: null,
      endDay: null,
      testDays: TEST_DAYS,
      memberUids: valid.map((c) => c.uid),
      size: valid.length,
    };
    tx.set(ref, group);
    writeMembers(tx, ref.id, valid);
    return valid.map((c) => c.uid);
  });
  if (!formed) return null;
  await addEvent(ref.id, "formed", { count: formed.length });
  await notifyMany(formed, "groupFormed", { n: formed.length - 1 }, { groupId: ref.id });
  logger.info("group formed", { groupId: ref.id, tier, size: formed.length });
  return ref.id;
}

/** Adds up to `count` people from the queue to an existing group. Returns how many joined. */
export async function refillGroup(groupId: string, count: number): Promise<number> {
  if (count <= 0) return 0;
  const added = await db.runTransaction(async (tx) => {
    const gSnap = await tx.get(groupRef(groupId));
    const g = gSnap.data() as Group | undefined;
    if (!g || (g.status !== "setup" && g.status !== "active")) return [];
    const late = g.status === "active";
    const { valid } = await takeFromQueue(tx, g.tier, count, late);
    if (valid.length === 0) return [];
    tx.update(groupRef(groupId), {
      memberUids: FieldValue.arrayUnion(...valid.map((c) => c.uid)),
      size: FieldValue.increment(valid.length),
      rosterVersion: FieldValue.increment(1),
    });
    writeMembers(tx, groupId, valid);
    return valid.map((c) => c.member);
  });
  if (added.length === 0) return 0;

  const members = await loadMembers(groupId);
  const others = members.filter((m) => isLive(m) && !added.some((a) => a.uid === m.uid)).map((m) => m.uid);
  for (const a of added) {
    await addEvent(groupId, "joined", { uid: a.uid, name: a.displayName });
    await notifyMany(others, "newMember", { name: a.displayName, app: a.appName }, { groupId });
  }
  await notifyMany(
    added.map((a) => a.uid),
    "groupFormed",
    { n: members.filter(isLive).length - 1 },
    { groupId },
  );
  return added.length;
}

// ---------------------------------------------------------------------------
// Setup phase
// ---------------------------------------------------------------------------

/**
 * Recomputes `installedAll` / `ready` for every member from today's activity,
 * activates late joiners who are ready, and starts the group when everyone is ready.
 */
export async function refreshReadiness(groupId: string): Promise<void> {
  const g = await loadGroup(groupId);
  if (!g || (g.status !== "setup" && g.status !== "active")) return;
  const members = await loadMembers(groupId);
  const today = dayKey();
  const batch = db.batch();
  const nowActive: Member[] = [];

  await Promise.all(
    members.filter((m) => m.state === "setup" && !m.bot).map(async (m) => {
      const act = await loadActivity(groupId, m.uid, today);
      const vis = visibleApps(members, m.uid);
      const installedAll = vis.every((v) => act[v.uid]?.installed === true);
      const ready = installedAll && m.emailsAddedVersion >= g.rosterVersion;
      m.installedAll = installedAll;
      m.ready = ready;
      const update: Record<string, unknown> = { installedAll, ready };
      if (g.status === "active" && ready) {
        update.state = "active";
        update.activeSince = today;
        nowActive.push(m);
      }
      batch.update(memberRef(groupId, m.uid), update);
    }),
  );
  await batch.commit();

  for (const m of nowActive) await addEvent(groupId, "memberActive", { uid: m.uid, name: m.displayName });

  if (g.status === "setup") {
    const live = members.filter(isLive);
    if (live.length >= MIN_TO_START && live.every((m) => m.ready)) await startGroup(groupId);
  }
}

export async function startGroup(groupId: string): Promise<void> {
  const today = dayKey();
  const started = await db.runTransaction(async (tx) => {
    const g = (await tx.get(groupRef(groupId))).data() as Group | undefined;
    if (!g || g.status !== "setup") return null;
    const ms = await tx.get(groupRef(groupId).collection("members").where("state", "==", "setup"));
    tx.update(groupRef(groupId), {
      status: "active",
      startDay: today,
      endDay: addDays(today, TEST_DAYS - 1),
    });
    ms.docs.forEach((d) => tx.update(d.ref, { state: "active", activeSince: today }));
    return ms.docs.map((d) => d.id);
  });
  if (!started) return;
  await addEvent(groupId, "started", { day: today });
  await notifyMany(started, "testStarted", { n: TEST_DAYS }, { groupId });
}

export async function cancelGroup(groupId: string): Promise<void> {
  const members = await loadMembers(groupId);
  const live = members.filter(isLive);
  const batch = db.batch();
  batch.update(groupRef(groupId), { status: "cancelled" });
  for (const m of live) {
    batch.update(memberRef(groupId, m.uid), { state: "removed", removedReason: "group_cancelled" });
    batch.update(db.collection("users").doc(m.uid), { currentGroupId: null });
    if (m.ready) {
      // Ready members go back to the very front of the queue with the same app.
      const p = await db.collection("profiles").doc(m.uid).get();
      batch.set(db.collection("queue").doc(m.uid), {
        uid: m.uid,
        appId: m.appId,
        tier: tierFor({ trustScore: p.get("trustScore") ?? TRUST.start, stats: p.get("stats") ?? {} }),
        joinedAt: Timestamp.now(),
        priorityAt: Timestamp.fromMillis(0),
      });
    }
  }
  await batch.commit();
  await addEvent(groupId, "cancelled");
  await notifyMany(live.map((m) => m.uid), "groupCancelled", {}, { groupId });
}

/** Called when a setup group's deadline passes. */
export async function handleSetupDeadline(groupId: string): Promise<void> {
  await refreshReadiness(groupId);
  const g = await loadGroup(groupId);
  if (!g || g.status !== "setup") return; // started during refresh
  const members = await loadMembers(groupId);
  for (const m of members.filter((x) => isLive(x) && !x.ready)) {
    await removeMember(groupId, m.uid, "setup_failed");
  }
  const ready = members.filter((m) => isLive(m) && m.ready).length;
  if (ready >= GROUP_SIZE) return startGroup(groupId);

  if (g.setupRounds < MAX_SETUP_ROUNDS) {
    const added = await refillGroup(groupId, GROUP_SIZE - ready);
    if (added === 0 && ready >= MIN_TO_START) return startGroup(groupId);
    await groupRef(groupId).update({
      setupDeadline: hoursFromNow(added > 0 ? LATE_SETUP_HOURS : 24),
      setupRounds: FieldValue.increment(1),
    });
    return;
  }
  if (ready >= MIN_TO_START) return startGroup(groupId);
  return cancelGroup(groupId);
}

// ---------------------------------------------------------------------------
// Removal & completion
// ---------------------------------------------------------------------------

export type RemoveReason =
  | "setup_failed"
  | "inactive"
  | "reported"
  | "left"
  | "account_deleted"
  | "group_ended";

export async function removeMember(groupId: string, uid: string, reason: RemoveReason): Promise<void> {
  const ref = memberRef(groupId, uid);
  const prev = await db.runTransaction(async (tx) => {
    const user = db.collection("users").doc(uid);
    const [s, us] = await Promise.all([tx.get(ref), tx.get(user)]);
    const m = s.data() as Member | undefined;
    if (!m || m.state === "removed" || m.state === "completed") return null;
    tx.update(ref, { state: "removed", removedReason: reason, removedAt: FieldValue.serverTimestamp() });
    if (us.exists && us.get("currentGroupId") === groupId) tx.update(user, { currentGroupId: null });
    return m;
  });
  if (!prev) return;

  switch (reason) {
    case "setup_failed":
      await applyTrust(uid, TRUST.setupFailed, "setup_failed");
      await notify(uid, "setupFailed", {}, { groupId });
      break;
    case "inactive":
      await applyTrust(uid, TRUST.kicked, "kicked_inactive", { groupsRemoved: 1 });
      await addStrike(uid, "inactive");
      await notify(uid, "kicked", { name: "inactive for 3 days" }, { groupId });
      break;
    case "reported":
      await applyTrust(uid, TRUST.kicked + TRUST.confirmedReport, "kicked_reported", {
        groupsRemoved: 1,
        reportsConfirmed: 1,
      });
      await addStrike(uid, "reported");
      await notify(uid, "kicked", { name: "reports confirmed by admin" }, { groupId });
      break;
    case "left":
      await applyTrust(uid, prev.state === "active" ? TRUST.leftGroup : -5, "left_group", { groupsRemoved: 1 });
      break;
    default:
      break;
  }
  if (reason !== "account_deleted") {
    await addEvent(groupId, "removed", { uid, name: prev.displayName, reason });
  }
}

export async function completeGroup(groupId: string): Promise<void> {
  const members = await loadMembers(groupId);
  await groupRef(groupId).update({ status: "completed", completedAt: FieldValue.serverTimestamp() });
  for (const m of members) {
    if (m.state === "active") await completeMember(groupId, m);
    else if (m.state === "setup") await removeMember(groupId, m.uid, "group_ended");
    // Suspended members wait for the admin decision.
  }
  await addEvent(groupId, "completed");
}

export async function completeMember(groupId: string, m: Member): Promise<void> {
  await memberRef(groupId, m.uid).update({ state: "completed" });
  const user = await db.collection("users").doc(m.uid).get();
  if (user.get("currentGroupId") === groupId) await user.ref.update({ currentGroupId: null });
  await applyTrust(m.uid, TRUST.groupCompleted, "group_completed", {
    groupsCompleted: 1,
    ...(m.missedDays === 0 ? { perfectGroups: 1 } : {}),
  });
  await notify(m.uid, "completed", {}, { groupId });
}

// ---------------------------------------------------------------------------
// Daily evaluation (active phase)
// ---------------------------------------------------------------------------

export function evaluateMemberDay(
  members: Member[],
  m: Member,
  day: string,
  act: Record<string, AppActivity>,
): DayResult {
  const required = requiredAppsOn(members, m.uid, day);
  const opened = required.filter((r) => {
    const a = act[r.uid];
    return a !== undefined && a.installed && (a.opens > 0 || a.minutes >= 1);
  }).length;
  const ok = required.length === 0 || opened >= passThreshold(required.length, DAILY_PASS_RATIO);
  return { day, ok, opened, required: required.length };
}

/** Evaluates `day` for every active member, applies trust, warnings and auto-kicks. */
export async function evaluateGroupDay(
  groupId: string,
  day: string,
  opts: { force?: boolean; emptyFor?: string } = {},
): Promise<void> {
  const g = await loadGroup(groupId);
  if (!g || g.status !== "active") return;
  if (!opts.force && g.lastEvaluatedDay && g.lastEvaluatedDay >= day) return; // idempotent
  const members = await loadMembers(groupId);

  for (const m of members) {
    if (m.bot || m.state !== "active" || !m.activeSince || m.activeSince >= day) continue; // first partial day is free
    // Test mode can simulate a missed day by ignoring the member's real activity.
    const act = opts.emptyFor === m.uid ? {} : await loadActivity(groupId, m.uid, day);
    const r = evaluateMemberDay(members, m, day, act);
    const lastDays = [...(m.lastDays ?? []), r].slice(-7);
    if (r.ok) {
      await memberRef(groupId, m.uid).update({
        lastDays,
        activeDays: FieldValue.increment(1),
        consecutiveMissed: 0,
      });
      await applyTrust(m.uid, TRUST.goodDay, "active_day", { activeDays: 1 });
      continue;
    }
    const missed = (m.consecutiveMissed ?? 0) + 1;
    await memberRef(groupId, m.uid).update({
      lastDays,
      missedDays: FieldValue.increment(1),
      consecutiveMissed: missed,
      warnings: FieldValue.increment(missed < KICK_AFTER_MISSED ? 1 : 0),
    });
    await applyTrust(m.uid, TRUST.missedDay, "missed_day", { missedDays: 1 });
    if (missed >= KICK_AFTER_MISSED) {
      await removeMember(groupId, m.uid, "inactive");
    } else if (missed === KICK_AFTER_MISSED - 1) {
      await notify(m.uid, "warning2", {}, { groupId });
      await addEvent(groupId, "warning", { uid: m.uid, name: m.displayName, missed });
    } else {
      await notify(m.uid, "warning1", {}, { groupId });
    }
  }
  await groupRef(groupId).update({ lastEvaluatedDay: day });
}

/** The daily tick for one active group: evaluate yesterday, refill early gaps, complete when done. */
export async function dailyTickActive(groupId: string): Promise<void> {
  const today = dayKey();
  const yesterday = addDays(today, -1);
  await evaluateGroupDay(groupId, yesterday);

  const g = await loadGroup(groupId);
  if (!g || g.status !== "active" || !g.startDay || !g.endDay) return;
  if (today > g.endDay) return completeGroup(groupId);

  const dayIndex = diffDays(g.startDay, today) + 1;
  if (dayIndex <= REFILL_MAX_DAY) {
    const live = (await loadMembers(groupId)).filter(isLive).length;
    if (live < REFILL_BELOW) await refillGroup(groupId, GROUP_SIZE - live);
  }
}

/** Hourly tick: setup deadlines, late joiner deadlines, setup reminders. */
export async function hourlyTick(groupId: string): Promise<void> {
  const g = await loadGroup(groupId);
  if (!g) return;
  const now = Date.now();
  const members = await loadMembers(groupId);

  // Reminder ~12h before a member's setup deadline.
  for (const m of members) {
    const deadline = m.late ? m.setupDeadline : g.setupDeadline;
    if (m.bot || m.state !== "setup" || m.ready || m.reminded) continue;
    if (deadline.toMillis() - now < 12 * 3600 * 1000) {
      await memberRef(groupId, m.uid).update({ reminded: true });
      await notify(m.uid, "setupReminder", {}, { groupId });
    }
  }

  if (g.status === "setup" && g.setupDeadline.toMillis() <= now) {
    await handleSetupDeadline(groupId);
  } else if (g.status === "active") {
    await refreshReadiness(groupId);
    const fresh = await loadMembers(groupId);
    for (const m of fresh) {
      if (m.state === "setup" && m.late && m.setupDeadline.toMillis() <= now) {
        await removeMember(groupId, m.uid, "setup_failed");
      }
    }
  }
}
