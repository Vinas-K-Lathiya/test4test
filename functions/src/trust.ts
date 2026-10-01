import { MAX_STRIKES, TRUST, TRUSTED_TIER_MIN_SCORE } from "./config";
import { db, FieldValue, Tier } from "./util";

export type StatKey =
  | "groupsJoined"
  | "groupsCompleted"
  | "groupsRemoved"
  | "activeDays"
  | "missedDays"
  | "feedbackGiven"
  | "helpfulFeedback"
  | "reportsConfirmed"
  | "perfectGroups";

export interface Profile {
  displayName: string;
  photoUrl: string | null;
  trustScore: number;
  stats: Partial<Record<StatKey, number>>;
  badges: string[];
}

export function tierFor(p: Pick<Profile, "trustScore" | "stats">): Tier {
  const completed = p.stats?.groupsCompleted ?? 0;
  return p.trustScore >= TRUSTED_TIER_MIN_SCORE && completed > 0 ? "trusted" : "starter";
}

function badgesFor(p: Profile): string[] {
  const s = p.stats ?? {};
  const out = new Set(p.badges ?? []);
  if ((s.groupsCompleted ?? 0) >= 1) out.add("first_pact");
  if ((s.groupsCompleted ?? 0) >= 5) out.add("veteran");
  if ((s.perfectGroups ?? 0) >= 1) out.add("perfect_streak");
  if ((s.helpfulFeedback ?? 0) >= 10) out.add("helpful_reviewer");
  if (p.trustScore >= 120 && (s.groupsCompleted ?? 0) >= 3) out.add("top_tester");
  return [...out];
}

/**
 * Atomically change a user's trust score (clamped) and stats, recompute badges,
 * and write a line to their trust log so they can see why the score moved.
 */
export async function applyTrust(
  uid: string,
  delta: number,
  reason: string,
  stats: Partial<Record<StatKey, number>> = {},
): Promise<void> {
  const ref = db.collection("profiles").doc(uid);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) return;
    const p = snap.data() as Profile;
    const score = Math.max(TRUST.min, Math.min(TRUST.max, (p.trustScore ?? TRUST.start) + delta));
    const newStats = { ...(p.stats ?? {}) };
    for (const [k, v] of Object.entries(stats)) {
      newStats[k as StatKey] = (newStats[k as StatKey] ?? 0) + (v ?? 0);
    }
    const next: Profile = { ...p, trustScore: score, stats: newStats };
    tx.update(ref, { trustScore: score, stats: newStats, badges: badgesFor(next) });
    if (delta !== 0) {
      tx.set(ref.collection("trustLog").doc(), { delta, reason, score, at: FieldValue.serverTimestamp() });
    }
  });
}

/** Adds a strike; bans the account from new groups at MAX_STRIKES. Returns the new strike count. */
export async function addStrike(uid: string, reason: string): Promise<number> {
  const ref = db.collection("users").doc(uid);
  return db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) return 0;
    const strikes = ((snap.get("strikes") as number | undefined) ?? 0) + 1;
    tx.update(ref, {
      strikes,
      banned: strikes >= MAX_STRIKES,
      strikeLog: FieldValue.arrayUnion({ reason, at: new Date().toISOString() }),
    });
    return strikes;
  });
}
