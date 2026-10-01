import { HttpsError, onCall } from "firebase-functions/v2/https";
import { MAX_STRIKES, REGION, TRUST } from "./config";
import { completeMember, loadGroup, removeMember } from "./groups";
import { notify } from "./notify";
import { applyTrust } from "./trust";
import { Member, addEvent, db, FieldValue, memberRef, requireAdmin, str } from "./util";

const opts = { region: REGION };

/** Confirm (kick) or reject (reinstate) a suspended member after reviewing reports + data. */
export const adminResolveReview = onCall(opts, async (req) => {
  const adminUid = requireAdmin(req);
  const id = str(req.data?.reviewId, "reviewId", 1, 200);
  const decision = req.data?.decision;
  const note = typeof req.data?.note === "string" ? req.data.note.slice(0, 1000) : "";
  if (decision !== "confirm" && decision !== "reject") throw new HttpsError("invalid-argument", "decision");

  const ref = db.collection("reviews").doc(id);
  const review = await ref.get();
  if (!review.exists || review.get("status") !== "open") throw new HttpsError("failed-precondition", "not-open");
  const groupId = review.get("groupId") as string;
  const targetUid = review.get("targetUid") as string;
  const reportIds = (review.get("reportIds") as string[]) ?? [];
  const reporters = (review.get("reporters") as string[]) ?? [];

  await ref.update({ status: decision === "confirm" ? "confirmed" : "rejected", note, adminUid, resolvedAt: FieldValue.serverTimestamp() });
  const batch = db.batch();
  reportIds.forEach((r) =>
    batch.update(db.collection("reports").doc(r), { status: decision === "confirm" ? "confirmed" : "rejected" }),
  );
  await batch.commit();

  if (decision === "confirm") {
    await removeMember(groupId, targetUid, "reported");
    return { ok: true };
  }

  // Rejected: reinstate and lightly penalise the false reporters.
  const mSnap = await memberRef(groupId, targetUid).get();
  const m = mSnap.data() as (Member & { suspendedFrom?: string }) | undefined;
  const g = await loadGroup(groupId);
  if (m && m.state === "suspended" && g) {
    if (g.status === "completed") {
      await completeMember(groupId, m);
    } else {
      await mSnap.ref.update({ state: m.suspendedFrom === "setup" ? "setup" : "active", consecutiveMissed: 0 });
      await addEvent(groupId, "reinstated", { uid: targetUid, name: m.displayName });
      await notify(targetUid, "reinstated", {}, { groupId });
    }
  }
  for (const r of reporters) await applyTrust(r, TRUST.falseReport, "false_report");
  return { ok: true };
});

export const adminResolveAppeal = onCall(opts, async (req) => {
  const adminUid = requireAdmin(req);
  const id = str(req.data?.appealId, "appealId", 1, 200);
  const decision = req.data?.decision;
  const note = typeof req.data?.note === "string" ? req.data.note.slice(0, 1000) : "";
  if (decision !== "accept" && decision !== "reject") throw new HttpsError("invalid-argument", "decision");
  const ref = db.collection("appeals").doc(id);
  const a = await ref.get();
  if (!a.exists || a.get("status") !== "open") throw new HttpsError("failed-precondition", "not-open");
  const uid = a.get("uid") as string;
  await ref.update({ status: decision === "accept" ? "accepted" : "rejected", note, adminUid, resolvedAt: FieldValue.serverTimestamp() });
  if (decision === "accept") {
    const user = db.collection("users").doc(uid);
    await db.runTransaction(async (tx) => {
      const s = await tx.get(user);
      if (!s.exists) return;
      const strikes = Math.max(0, ((s.get("strikes") as number) ?? 0) - 1);
      tx.update(user, { strikes, banned: strikes >= MAX_STRIKES });
      if (s.get("deviceHash")) tx.set(db.collection("devices").doc(s.get("deviceHash")), { banned: false }, { merge: true });
    });
    await applyTrust(uid, 15, "appeal_accepted");
  }
  await notify(uid, "appealResolved", { name: note || (decision === "accept" ? "Accepted ✅" : "Rejected") });
  return { ok: true };
});

export const adminSetBan = onCall(opts, async (req) => {
  requireAdmin(req);
  const uid = str(req.data?.uid, "uid", 1, 128);
  const banned = req.data?.banned === true;
  const user = await db.collection("users").doc(uid).get();
  if (!user.exists) throw new HttpsError("not-found", "user");
  await user.ref.update({ banned, ...(banned ? {} : { strikes: 0 }) });
  const deviceHash = user.get("deviceHash") as string | undefined;
  if (deviceHash) await db.collection("devices").doc(deviceHash).set({ banned }, { merge: true });
  const groupId = user.get("currentGroupId") as string | null;
  if (banned && groupId) await removeMember(groupId, uid, "reported");
  return { ok: true };
});

export const adminAdjustTrust = onCall(opts, async (req) => {
  requireAdmin(req);
  const uid = str(req.data?.uid, "uid", 1, 128);
  const delta = Number(req.data?.delta);
  const reason = str(req.data?.reason, "reason", 3, 200);
  if (!Number.isInteger(delta) || Math.abs(delta) > 100) throw new HttpsError("invalid-argument", "delta");
  await applyTrust(uid, delta, `admin: ${reason}`);
  return { ok: true };
});

export const adminFindUser = onCall(opts, async (req) => {
  requireAdmin(req);
  const email = str(req.data?.email, "email", 3, 200).toLowerCase();
  const q = await db.collection("users").where("email", "==", email).limit(1).get();
  if (q.empty) return { found: false };
  const u = q.docs[0];
  const p = await db.collection("profiles").doc(u.id).get();
  return {
    found: true,
    uid: u.id,
    email: u.get("email"),
    banned: u.get("banned") === true,
    strikes: u.get("strikes") ?? 0,
    currentGroupId: u.get("currentGroupId") ?? null,
    displayName: p.get("displayName") ?? "",
    trustScore: p.get("trustScore") ?? 0,
    stats: p.get("stats") ?? {},
  };
});
