import { createHash, randomBytes } from "node:crypto";
import { getAuth } from "firebase-admin/auth";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import {
  DAILY_PASS_RATIO,
  REGION,
  REPORT_MIN,
  REPORT_RATIO,
  REPORT_WINDOW_HOURS,
  TRUST,
} from "./config";
import { refreshReadiness, removeMember, tryFormGroup, loadGroup, loadMembers } from "./groups";
import { verifyIntegrityToken } from "./integrity";
import { notify } from "./notify";
import { applyTrust, tierFor, Profile } from "./trust";
import {
  AppActivity,
  Member,
  Timestamp,
  addEvent,
  dayKey,
  db,
  FieldValue,
  groupRef,
  isLive,
  memberRef,
  passThreshold,
  requireAuth,
  str,
  visibleApps,
} from "./util";

const opts = { region: REGION };

function hashDevice(id: string): string {
  return createHash("sha256").update("testpact:" + id).digest("hex");
}

async function integrityRequired(): Promise<boolean> {
  const c = await db.collection("config").doc("app").get();
  return c.get("integrityRequired") === true;
}

// ---------------------------------------------------------------------------
// Account
// ---------------------------------------------------------------------------

export const getIntegrityNonce = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const nonce = randomBytes(24).toString("base64url");
  await db.collection("nonces").doc(uid).set({ nonce, at: FieldValue.serverTimestamp() });
  return { nonce };
});

/**
 * Called after every sign-in. Creates the user + public profile on first sign-in,
 * enforces one account per device and (optionally) Play Integrity.
 */
export const bootstrapUser = onCall(opts, async (req) => {
  const { uid, email } = requireAuth(req);
  const deviceId = str(req.data?.deviceId, "deviceId", 4, 200);
  const locale = typeof req.data?.locale === "string" ? req.data.locale.slice(0, 5) : "en";
  const deviceHash = hashDevice(deviceId);

  if (await integrityRequired()) {
    const token = req.data?.integrityToken;
    const nonceDoc = await db.collection("nonces").doc(uid).get();
    const nonce = nonceDoc.get("nonce") as string | undefined;
    const at = nonceDoc.get("at") as Timestamp | undefined;
    if (typeof token !== "string" || !nonce || !at || Date.now() - at.toMillis() > 10 * 60 * 1000) {
      throw new HttpsError("failed-precondition", "integrity-missing");
    }
    const r = await verifyIntegrityToken(token, nonce);
    await nonceDoc.ref.delete();
    if (!r.ok) throw new HttpsError("permission-denied", `integrity-${r.reason}`);
  }

  const deviceRef = db.collection("devices").doc(deviceHash);
  const userRef = db.collection("users").doc(uid);
  const profileRef = db.collection("profiles").doc(uid);
  const token = req.auth!.token;

  await db.runTransaction(async (tx) => {
    const [dev, user] = await Promise.all([tx.get(deviceRef), tx.get(userRef)]);
    const owner = dev.get("uid") as string | undefined;
    if (dev.exists && owner && owner !== uid) {
      const ownerUser = await tx.get(db.collection("users").doc(owner));
      if (ownerUser.exists || dev.get("banned") === true) {
        throw new HttpsError("already-exists", "device-in-use");
      }
    }
    if (user.exists && user.get("deviceHash") && user.get("deviceHash") !== deviceHash) {
      // Same account on a new phone is fine; free the old device slot.
      tx.delete(db.collection("devices").doc(user.get("deviceHash")));
    }
    tx.set(deviceRef, { uid, banned: false, at: FieldValue.serverTimestamp() });
    if (!user.exists) {
      tx.set(userRef, {
        email,
        createdAt: FieldValue.serverTimestamp(),
        deviceHash,
        currentGroupId: null,
        strikes: 0,
        banned: false,
        locale,
      });
      tx.set(profileRef, {
        displayName: (token.name as string | undefined) ?? email.split("@")[0],
        photoUrl: (token.picture as string | undefined) ?? null,
        trustScore: TRUST.start,
        stats: {},
        badges: [],
        createdAt: FieldValue.serverTimestamp(),
      });
    } else {
      tx.update(userRef, { deviceHash, email, lastSeenAt: FieldValue.serverTimestamp() });
    }
  });
  return { ok: true };
});

export const deleteAccount = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const user = await db.collection("users").doc(uid).get();
  const groupId = user.get("currentGroupId") as string | null;
  if (groupId) await removeMember(groupId, uid, "account_deleted");
  await db.collection("queue").doc(uid).delete();

  const apps = await db.collection("apps").where("ownerUid", "==", uid).get();
  const batch = db.batch();
  apps.docs.forEach((d) => batch.delete(d.ref));
  const deviceHash = user.get("deviceHash") as string | undefined;
  if (deviceHash) {
    // A banned account keeps its device locked so the ban can't be dodged by re-registering.
    if (user.get("banned")) batch.set(db.collection("devices").doc(deviceHash), { uid, banned: true });
    else batch.delete(db.collection("devices").doc(deviceHash));
  }
  await batch.commit();
  await db.recursiveDelete(db.collection("profiles").doc(uid));
  await db.recursiveDelete(user.ref);
  await getAuth().deleteUser(uid);
  return { ok: true };
});

export const submitAppeal = onCall(opts, async (req) => {
  const { uid, email } = requireAuth(req);
  const text = str(req.data?.text, "text", 20, 2000);
  const open = await db.collection("appeals").where("uid", "==", uid).where("status", "==", "open").get();
  if (!open.empty) throw new HttpsError("already-exists", "appeal-open");
  await db.collection("appeals").add({
    uid,
    email,
    text,
    groupId: req.data?.groupId ?? null,
    status: "open",
    createdAt: FieldValue.serverTimestamp(),
  });
  return { ok: true };
});

// ---------------------------------------------------------------------------
// Queue
// ---------------------------------------------------------------------------

export const joinQueue = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const appId = str(req.data?.appId, "appId", 1, 100);
  const [user, profile, app] = await Promise.all([
    db.collection("users").doc(uid).get(),
    db.collection("profiles").doc(uid).get(),
    db.collection("apps").doc(appId).get(),
  ]);
  if (!user.exists) throw new HttpsError("failed-precondition", "no-user");
  if (user.get("banned")) throw new HttpsError("permission-denied", "banned");
  if (user.get("currentGroupId")) throw new HttpsError("failed-precondition", "already-in-group");
  if (!app.exists || app.get("ownerUid") !== uid) throw new HttpsError("not-found", "app-not-found");

  const p = profile.data() as Profile;
  const tier = tierFor(p);
  // Higher trust jumps ahead: 10 minutes per point above the starting score.
  const bonusMs = Math.max(0, (p.trustScore ?? TRUST.start) - TRUST.start) * 10 * 60 * 1000;
  await db.collection("queue").doc(uid).set({
    uid,
    appId,
    tier,
    joinedAt: Timestamp.now(),
    priorityAt: Timestamp.fromMillis(Date.now() - bonusMs),
  });
  const groupId = await tryFormGroup(tier);
  await updateQueueStats();
  return { tier, groupId };
});

export const leaveQueue = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  await db.collection("queue").doc(uid).delete();
  await updateQueueStats();
  return { ok: true };
});

export async function updateQueueStats(): Promise<void> {
  const q = db.collection("queue");
  const [starter, trusted] = await Promise.all([
    q.where("tier", "==", "starter").count().get(),
    q.where("tier", "==", "trusted").count().get(),
  ]);
  await db.collection("stats").doc("queue").set({
    starter: starter.data().count,
    trusted: trusted.data().count,
    updatedAt: FieldValue.serverTimestamp(),
  });
}

// ---------------------------------------------------------------------------
// Group actions
// ---------------------------------------------------------------------------

async function requireMember(groupId: string, uid: string): Promise<Member> {
  const s = await memberRef(groupId, uid).get();
  if (!s.exists) throw new HttpsError("permission-denied", "not-a-member");
  return s.data() as Member;
}

export const confirmEmailsAdded = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const groupId = str(req.data?.groupId, "groupId", 1, 100);
  const m = await requireMember(groupId, uid);
  if (!isLive(m)) throw new HttpsError("failed-precondition", "not-live");
  const g = await loadGroup(groupId);
  if (!g) throw new HttpsError("not-found", "group");
  await memberRef(groupId, uid).update({ emailsAdded: true, emailsAddedVersion: g.rosterVersion });
  if (!m.emailsAdded) await addEvent(groupId, "emailsAdded", { uid, name: m.displayName });
  await refreshReadiness(groupId);
  return { ok: true };
});

/**
 * Device reports what it saw today: for each tester-visible app, whether it's installed,
 * foreground minutes (needs Usage Access) and opens. Values only ever go up within a day.
 */
export const syncActivity = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const groupId = str(req.data?.groupId, "groupId", 1, 100);
  const m = await requireMember(groupId, uid);
  if (!isLive(m)) return { ok: false };
  const raw = (req.data?.apps ?? {}) as Record<string, Partial<AppActivity>>;
  const usageAccess = req.data?.usageAccess === true;
  const day = dayKey();

  const members = await loadMembers(groupId);
  const vis = visibleApps(members, uid);
  const ref = groupRef(groupId).collection("activity").doc(`${uid}_${day}`);

  const merged = await db.runTransaction(async (tx) => {
    const prev = ((await tx.get(ref)).get("apps") as Record<string, AppActivity> | undefined) ?? {};
    const out: Record<string, AppActivity> = {};
    for (const v of vis) {
      const r = raw[v.uid] ?? {};
      const p = prev[v.uid] ?? { installed: false, minutes: 0, opens: 0 };
      out[v.uid] = {
        // "installed" reflects the latest check (an uninstall must show), usage only grows.
        installed: r.installed === true,
        minutes: Math.max(p.minutes, Math.min(1440, Math.floor(Number(r.minutes) || 0))),
        opens: Math.max(p.opens, Math.min(500, Math.floor(Number(r.opens) || 0))),
      };
    }
    tx.set(ref, { uid, day, apps: out, usageAccess, updatedAt: FieldValue.serverTimestamp() });
    return out;
  });

  const installed = vis.filter((v) => merged[v.uid]?.installed).length;
  const opened = vis.filter((v) => {
    const a = merged[v.uid];
    return a?.installed && (a.opens > 0 || a.minutes >= 1);
  }).length;
  await memberRef(groupId, uid).update({
    today: { day, installed, opened, required: vis.length, usageAccess },
  });
  if (m.state === "setup") await refreshReadiness(groupId);
  return { ok: true, installed, opened, required: vis.length };
});

export const leaveGroup = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const groupId = str(req.data?.groupId, "groupId", 1, 100);
  await requireMember(groupId, uid);
  await removeMember(groupId, uid, "left");
  return { ok: true };
});

// ---------------------------------------------------------------------------
// Feedback
// ---------------------------------------------------------------------------

const CATEGORIES = ["bug", "ux", "idea", "praise", "other"];

export const submitFeedback = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const groupId = str(req.data?.groupId, "groupId", 1, 100);
  const toUid = str(req.data?.toUid, "toUid", 1, 128);
  const text = str(req.data?.text, "text", 20, 2000);
  const rating = Number(req.data?.rating);
  const category = String(req.data?.category ?? "other");
  const screenshotPath = typeof req.data?.screenshotPath === "string" ? req.data.screenshotPath : null;
  if (!Number.isInteger(rating) || rating < 1 || rating > 5) throw new HttpsError("invalid-argument", "rating");
  if (!CATEGORIES.includes(category)) throw new HttpsError("invalid-argument", "category");
  if (screenshotPath && !screenshotPath.startsWith(`uploads/${uid}/`)) {
    throw new HttpsError("invalid-argument", "screenshot");
  }
  if (toUid === uid) throw new HttpsError("invalid-argument", "self");

  const from = await requireMember(groupId, uid);
  const to = await requireMember(groupId, toUid);
  if (!isLive(from) && from.state !== "completed") throw new HttpsError("failed-precondition", "not-live");

  await db.collection("feedback").add({
    groupId,
    fromUid: uid,
    fromName: from.displayName,
    toUid,
    appId: to.appId,
    appName: to.appName,
    rating,
    category,
    text,
    screenshotPath,
    helpful: null,
    createdAt: FieldValue.serverTimestamp(),
  });
  await memberRef(groupId, uid).update({ [`feedbackTo.${toUid}`]: FieldValue.increment(1) });
  await applyTrust(uid, 0, "feedback", { feedbackGiven: 1 });
  await notify(toUid, "newFeedback", { name: from.displayName, app: to.appName }, { groupId });
  return { ok: true };
});

export const rateFeedback = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const id = str(req.data?.feedbackId, "feedbackId", 1, 100);
  const helpful = req.data?.helpful === true;
  const ref = db.collection("feedback").doc(id);
  const fromUid = await db.runTransaction(async (tx) => {
    const s = await tx.get(ref);
    if (!s.exists || s.get("toUid") !== uid) throw new HttpsError("permission-denied", "not-yours");
    if (s.get("helpful") !== null) throw new HttpsError("already-exists", "already-rated");
    tx.update(ref, { helpful });
    return s.get("fromUid") as string;
  });
  if (helpful) await applyTrust(fromUid, TRUST.helpfulFeedback, "helpful_feedback", { helpfulFeedback: 1 });
  return { ok: true };
});

// ---------------------------------------------------------------------------
// Reports
// ---------------------------------------------------------------------------

const REASONS = ["not_installed", "uninstalled", "not_opening", "email_not_added", "spam_abuse", "fake_feedback", "other"];

export const submitReport = onCall(opts, async (req) => {
  const { uid } = requireAuth(req);
  const groupId = str(req.data?.groupId, "groupId", 1, 100);
  const targetUid = str(req.data?.targetUid, "targetUid", 1, 128);
  const reason = String(req.data?.reason ?? "");
  const details = typeof req.data?.details === "string" ? req.data.details.trim().slice(0, 1000) : "";
  const screenshotPath = typeof req.data?.screenshotPath === "string" ? req.data.screenshotPath : null;
  if (!REASONS.includes(reason)) throw new HttpsError("invalid-argument", "reason");
  if (targetUid === uid) throw new HttpsError("invalid-argument", "self");
  if (screenshotPath && !screenshotPath.startsWith(`uploads/${uid}/`)) {
    throw new HttpsError("invalid-argument", "screenshot");
  }
  const reporter = await requireMember(groupId, uid);
  const target = await requireMember(groupId, targetUid);
  if (!isLive(reporter)) throw new HttpsError("failed-precondition", "not-live");
  if (!isLive(target)) throw new HttpsError("failed-precondition", "target-not-live");

  // One open report per reporter/target pair; a new one replaces the old.
  const reportId = `${groupId}_${targetUid}_${uid}`;
  await db.collection("reports").doc(reportId).set({
    groupId,
    reporterUid: uid,
    reporterName: reporter.displayName,
    targetUid,
    targetName: target.displayName,
    reason,
    details,
    screenshotPath,
    status: "open",
    createdAt: FieldValue.serverTimestamp(),
  });

  await evaluateReports(groupId, targetUid);
  return { ok: true };
});

/** Our own activity data outranks reports: only suspend when the data also looks bad. */
function dataLooksGood(m: Member): boolean {
  if (m.state === "setup") return m.ready;
  const last = (m.lastDays ?? []).slice(-2);
  if (last.length > 0) return last.every((d) => d.ok);
  const t = m.today;
  return !!t && t.day === dayKey() && t.opened >= passThreshold(t.required, DAILY_PASS_RATIO);
}

async function evaluateReports(groupId: string, targetUid: string): Promise<void> {
  const since = Timestamp.fromMillis(Date.now() - REPORT_WINDOW_HOURS * 3600 * 1000);
  const open = await db
    .collection("reports")
    .where("groupId", "==", groupId)
    .where("targetUid", "==", targetUid)
    .where("status", "==", "open")
    .get();
  const recent = open.docs.filter((d) => {
    const at = d.get("createdAt") as Timestamp | undefined;
    return !at || at.toMillis() >= since.toMillis();
  });
  const reporters = new Set(recent.map((d) => d.get("reporterUid") as string));
  const members = await loadMembers(groupId);
  const live = members.filter(isLive).length;
  const needed = Math.max(REPORT_MIN, Math.ceil(live * REPORT_RATIO));
  if (reporters.size < needed) return;

  const target = members.find((m) => m.uid === targetUid);
  if (!target || !isLive(target)) return;
  const batch = db.batch();

  if (dataLooksGood(target)) {
    recent.forEach((d) => batch.update(d.ref, { status: "dismissed_by_data" }));
    await batch.commit();
    return;
  }

  const prevState = target.state;
  batch.update(memberRef(groupId, targetUid), { state: "suspended", suspendedFrom: prevState });
  recent.forEach((d) => batch.update(d.ref, { status: "under_review" }));
  batch.set(db.collection("reviews").doc(`${groupId}_${targetUid}`), {
    groupId,
    targetUid,
    targetName: target.displayName,
    targetEmail: target.email,
    reportIds: recent.map((d) => d.id),
    reasons: recent.map((d) => d.get("reason")),
    reporters: [...reporters],
    data: {
      lastDays: target.lastDays ?? [],
      today: target.today ?? null,
      missedDays: target.missedDays ?? 0,
      activeDays: target.activeDays ?? 0,
      state: prevState,
    },
    status: "open",
    createdAt: FieldValue.serverTimestamp(),
  });
  await batch.commit();
  await addEvent(groupId, "suspended", { uid: targetUid, name: target.displayName });
  await notify(targetUid, "suspended", {}, { groupId });
}
