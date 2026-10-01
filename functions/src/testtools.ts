import { HttpsError, onCall } from "firebase-functions/v2/https";
import { REGION, TEST_DAYS, TRUST } from "./config";
import { completeGroup, evaluateGroupDay, loadGroup, loadMembers, refreshReadiness, startGroup } from "./groups";
import {
  Group,
  Member,
  Timestamp,
  addDays,
  addEvent,
  dayKey,
  db,
  diffDays,
  groupRef,
  hoursFromNow,
  memberRef,
  requireAdmin,
} from "./util";

/**
 * Admin-only test harness: lets one person walk through a whole group (setup, daily testing,
 * warnings, completion) with stand-in "bot" members whose apps are common Google apps that are
 * already installed on most phones, so install and usage checks work for real.
 */

const BOT_APPS: [string, string][] = [
  ["YouTube", "com.google.android.youtube"],
  ["Chrome", "com.android.chrome"],
  ["Gmail", "com.google.android.gm"],
  ["Google Maps", "com.google.android.apps.maps"],
  ["Google Photos", "com.google.android.apps.photos"],
  ["Google", "com.google.android.googlequicksearchbox"],
  ["Play Store", "com.android.vending"],
  ["Google Drive", "com.google.android.apps.docs"],
  ["YouTube Music", "com.google.android.apps.youtube.music"],
  ["Google Meet", "com.google.android.apps.tachyon"],
  ["Google Calendar", "com.google.android.calendar"],
  ["Files by Google", "com.google.android.apps.nbu.files"],
  ["WhatsApp", "com.whatsapp"],
];
const BOT_NAMES = ["Aarav", "Diya", "Kabir", "Ananya", "Vihaan", "Isha", "Arjun", "Meera", "Rohan", "Sara", "Dev", "Kiara", "Yash"];

const botUid = (groupId: string, i: number) => `bot_${groupId}_${i}`;

async function requireTestGroup(groupId: string): Promise<Group> {
  const g = await loadGroup(groupId);
  if (!g || g.test !== true) throw new HttpsError("failed-precondition", "not-a-test-group");
  return g;
}

export const adminTestTools = onCall({ region: REGION, timeoutSeconds: 300 }, async (req) => {
  const adminUid = requireAdmin(req);
  const action = String(req.data?.action ?? "");
  const userRef = db.collection("users").doc(adminUid);

  // ---- Create a test group: admin + 13 bots, in setup --------------------------------
  if (action === "seed") {
    const [user, profile, apps] = await Promise.all([
      userRef.get(),
      db.collection("profiles").doc(adminUid).get(),
      db.collection("apps").where("ownerUid", "==", adminUid).limit(1).get(),
    ]);
    if (user.get("currentGroupId")) throw new HttpsError("failed-precondition", "already-in-group");
    if (apps.empty) throw new HttpsError("failed-precondition", "add-an-app-first");
    const app = apps.docs[0];
    const ref = db.collection("groups").doc();
    const now = Timestamp.now();
    const batch = db.batch();

    const base = {
      late: false,
      joinedAt: now,
      setupDeadline: hoursFromNow(48),
      activeSince: null,
      consecutiveMissed: 0,
      missedDays: 0,
      activeDays: 0,
      warnings: 0,
      feedbackTo: {},
      lastDays: [],
      today: null,
      removedReason: null,
      testNotes: "",
    };
    const me: Member = {
      ...base,
      uid: adminUid,
      email: user.get("email"),
      displayName: profile.get("displayName") ?? "Admin",
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
      emailsAdded: false,
      emailsAddedVersion: 0,
      installedAll: false,
      ready: false,
    };
    batch.set(memberRef(ref.id, adminUid), me);

    const uids = [adminUid];
    BOT_APPS.forEach(([appName, pkg], i) => {
      const uid = botUid(ref.id, i);
      uids.push(uid);
      const trust = 50 + ((i * 7) % 45);
      const bot: Member = {
        ...base,
        uid,
        email: `${BOT_NAMES[i].toLowerCase()}.test@example.com`,
        displayName: `${BOT_NAMES[i]} (test)`,
        photoUrl: null,
        trustScore: trust,
        appId: `bot_app_${i}`,
        appName,
        packageName: pkg,
        optInWebUrl: `https://play.google.com/store/apps/details?id=${pkg}`,
        optInPlayUrl: `https://play.google.com/store/apps/details?id=${pkg}`,
        iconUrl: null,
        testNotes: `Test member. Open ${appName} for a minute.`,
        state: "setup",
        emailsAdded: true,
        emailsAddedVersion: 1,
        installedAll: true,
        ready: true,
        bot: true,
      };
      batch.set(memberRef(ref.id, uid), bot);
      batch.set(db.collection("profiles").doc(uid), {
        displayName: bot.displayName,
        photoUrl: null,
        trustScore: trust,
        stats: { groupsJoined: 1 + (i % 4), groupsCompleted: i % 4, activeDays: 10 * (i % 4) },
        badges: i % 4 > 0 ? ["first_pact"] : [],
        bot: true,
      });
    });

    const group: Group & { adminSnapshot: Record<string, unknown> } = {
      tier: "starter",
      status: "setup",
      createdAt: now,
      setupDeadline: hoursFromNow(48),
      setupRounds: 0,
      rosterVersion: 1,
      startDay: null,
      endDay: null,
      testDays: TEST_DAYS,
      memberUids: uids,
      size: uids.length,
      test: true,
      // Restored on cleanup so testing doesn't permanently change the admin's real trust/stats.
      adminSnapshot: {
        trustScore: profile.get("trustScore") ?? TRUST.start,
        stats: profile.get("stats") ?? {},
        badges: profile.get("badges") ?? [],
        at: now,
      },
    };
    batch.set(ref, group);
    batch.update(userRef, { currentGroupId: ref.id });
    batch.delete(db.collection("queue").doc(adminUid));
    await batch.commit();
    await addEvent(ref.id, "formed", { count: uids.length });
    return { groupId: ref.id };
  }

  const groupId = String(req.data?.groupId ?? "");
  const g = await requireTestGroup(groupId);

  // ---- Start now, even if the admin's setup isn't finished ----------------------------
  if (action === "forceStart") {
    if (g.status !== "setup") throw new HttpsError("failed-precondition", "not-in-setup");
    await memberRef(groupId, adminUid).update({ ready: true, emailsAdded: true, emailsAddedVersion: g.rosterVersion });
    await startGroup(groupId);
    return { ok: true };
  }

  // ---- Jump forward N days, scoring today's real activity (or a simulated miss) -------
  if (action === "advance") {
    const days = Math.max(1, Math.min(TEST_DAYS + 1, Number(req.data?.days) || 1));
    const miss = req.data?.miss === true;
    if (g.status === "setup") await refreshReadiness(groupId);
    for (let i = 0; i < days; i++) {
      const cur = await loadGroup(groupId);
      if (!cur || cur.status !== "active" || !cur.startDay || !cur.endDay) {
        throw new HttpsError("failed-precondition", "group-not-active");
      }
      // Pretend one more day has passed by moving every date back by a day.
      const members = await loadMembers(groupId);
      const batch = db.batch();
      batch.update(groupRef(groupId), {
        startDay: addDays(cur.startDay, -1),
        endDay: addDays(cur.endDay, -1),
        lastEvaluatedDay: null,
      });
      for (const m of members) {
        if (m.activeSince) batch.update(memberRef(groupId, m.uid), { activeSince: addDays(m.activeSince, -1) });
      }
      await batch.commit();
      const today = dayKey();
      await evaluateGroupDay(groupId, today, { force: true, emptyFor: miss ? adminUid : undefined });
      const after = await loadGroup(groupId);
      if (after?.status === "active" && after.startDay && diffDays(after.startDay, today) + 1 > after.testDays) {
        await completeGroup(groupId);
        break;
      }
      if (after?.status !== "active") break;
    }
    const fin = await loadGroup(groupId);
    return { status: fin?.status, dayIndex: fin?.startDay ? diffDays(fin.startDay, dayKey()) + 1 : 0 };
  }

  // ---- Delete the test group and restore the admin's real profile --------------------
  if (action === "cleanup") {
    const snap = (await groupRef(groupId).get()).get("adminSnapshot") as
      | { trustScore: number; stats: unknown; badges: unknown; at: Timestamp }
      | undefined;
    const members = await loadMembers(groupId);
    for (const m of members.filter((x) => x.bot)) {
      await db.recursiveDelete(db.collection("profiles").doc(m.uid));
    }
    const fb = await db.collection("feedback").where("groupId", "==", groupId).get();
    const reps = await db.collection("reports").where("groupId", "==", groupId).get();
    const batch = db.batch();
    fb.docs.forEach((d) => batch.delete(d.ref));
    reps.docs.forEach((d) => batch.delete(d.ref));
    batch.delete(db.collection("reviews").doc(`${groupId}_${adminUid}`));
    if (snap) {
      const profileRef = db.collection("profiles").doc(adminUid);
      batch.update(profileRef, { trustScore: snap.trustScore, stats: snap.stats, badges: snap.badges });
      const log = await profileRef.collection("trustLog").where("at", ">=", snap.at).get();
      log.docs.forEach((d) => batch.delete(d.ref));
    }
    const user = await userRef.get();
    if (user.get("currentGroupId") === groupId) batch.update(userRef, { currentGroupId: null });
    if (user.get("strikes") > 0 && snap) {
      // Strikes earned during the test (e.g. simulated kicks) are undone too.
      const before = ((user.get("strikeLog") as { at: string }[] | undefined) ?? []).filter(
        (s) => s.at < snap.at.toDate().toISOString(),
      );
      batch.update(userRef, { strikes: before.length, banned: false, strikeLog: before });
    }
    await batch.commit();
    await db.recursiveDelete(groupRef(groupId));
    return { ok: true };
  }

  throw new HttpsError("invalid-argument", "unknown-action");
});
