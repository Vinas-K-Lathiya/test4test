import { initializeApp, getApps } from "firebase-admin/app";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import { setGlobalOptions } from "firebase-functions/v2";
import { HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { ADMIN_EMAILS, FORM_EARLY_AFTER_HOURS } from "./config";

if (getApps().length === 0) initializeApp();

// New projects have a small per-region CPU quota. Fractional CPU + a low instance cap keeps all
// ~23 functions inside it and keeps costs tiny. Raise maxInstances as the user base grows.
setGlobalOptions({ maxInstances: 5, cpu: "gcf_gen1", memory: "256MiB", concurrency: 1 });

export const db = getFirestore();
export { FieldValue, Timestamp };

export const FORM_EARLY_AFTER_MS = FORM_EARLY_AFTER_HOURS * 3600 * 1000;

export type Tier = "starter" | "trusted";
export type GroupStatus = "setup" | "active" | "completed" | "cancelled";
export type MemberState = "setup" | "active" | "suspended" | "removed" | "completed";

export interface DayResult {
  day: string;
  ok: boolean;
  opened: number;
  required: number;
}

export interface Member {
  uid: string;
  email: string;
  displayName: string;
  photoUrl: string | null;
  trustScore: number;
  appId: string;
  appName: string;
  packageName: string;
  optInWebUrl: string;
  optInPlayUrl: string;
  iconUrl: string | null;
  testNotes: string;
  state: MemberState;
  late: boolean;
  joinedAt: Timestamp;
  setupDeadline: Timestamp;
  /** Has the member added the group's emails to their Play Console at least once? Makes their app visible. */
  emailsAdded: boolean;
  /** Roster version the member last confirmed adding emails for. */
  emailsAddedVersion: number;
  installedAll: boolean;
  ready: boolean;
  activeSince: string | null;
  consecutiveMissed: number;
  missedDays: number;
  activeDays: number;
  warnings: number;
  feedbackTo: Record<string, number>;
  lastDays: DayResult[];
  today: { day: string; installed: number; opened: number; required: number; usageAccess: boolean } | null;
  removedReason: string | null;
  reminded?: boolean;
  /** Test-mode stand-in member created by adminTestTools; always "does its part". */
  bot?: boolean;
}

export interface Group {
  tier: Tier;
  status: GroupStatus;
  createdAt: Timestamp;
  setupDeadline: Timestamp;
  setupRounds: number;
  rosterVersion: number;
  startDay: string | null;
  endDay: string | null;
  testDays: number;
  memberUids: string[];
  size: number;
  completedAt?: Timestamp;
  lastEvaluatedDay?: string;
  /** Created by adminTestTools; only the admin is a real member. */
  test?: boolean;
}

export interface AppActivity {
  installed: boolean;
  minutes: number;
  opens: number;
}

/** yyyy-mm-dd in UTC. */
export function dayKey(d: Date = new Date()): string {
  return d.toISOString().slice(0, 10);
}

export function addDays(day: string, n: number): string {
  const d = new Date(day + "T00:00:00Z");
  d.setUTCDate(d.getUTCDate() + n);
  return dayKey(d);
}

/** Whole days from a to b (b - a). */
export function diffDays(a: string, b: string): number {
  return Math.round((Date.parse(b + "T00:00:00Z") - Date.parse(a + "T00:00:00Z")) / 86400000);
}

export function hoursFromNow(h: number): Timestamp {
  return Timestamp.fromMillis(Date.now() + h * 3600 * 1000);
}

export function requireAuth(req: CallableRequest): { uid: string; email: string } {
  if (!req.auth) throw new HttpsError("unauthenticated", "Sign in first.");
  const email = (req.auth.token.email as string | undefined) ?? "";
  return { uid: req.auth.uid, email: email.toLowerCase() };
}

export function isAdminToken(token: Record<string, unknown> | undefined): boolean {
  if (!token) return false;
  const email = String(token.email ?? "").toLowerCase();
  return token.email_verified === true && ADMIN_EMAILS.includes(email);
}

export function requireAdmin(req: CallableRequest): string {
  const { uid } = requireAuth(req);
  if (!isAdminToken(req.auth?.token as Record<string, unknown>)) {
    throw new HttpsError("permission-denied", "Admins only.");
  }
  return uid;
}

export function str(v: unknown, field: string, min = 1, max = 500): string {
  if (typeof v !== "string") throw new HttpsError("invalid-argument", `${field} is required.`);
  const s = v.trim();
  if (s.length < min || s.length > max) {
    throw new HttpsError("invalid-argument", `${field} must be ${min}-${max} characters.`);
  }
  return s;
}

export function groupRef(groupId: string) {
  return db.collection("groups").doc(groupId);
}

export function memberRef(groupId: string, uid: string) {
  return groupRef(groupId).collection("members").doc(uid);
}

export async function addEvent(
  groupId: string,
  type: string,
  data: Record<string, unknown> = {},
): Promise<void> {
  await groupRef(groupId).collection("events").add({ type, ...data, at: FieldValue.serverTimestamp() });
}

/** Members whose apps count in this group right now (not removed / suspended / completed). */
export function isLive(m: Pick<Member, "state">): boolean {
  return m.state === "setup" || m.state === "active";
}

/** Apps `uid` must have installed: live members (other than uid) who have opened their test to the group. */
export function visibleApps(members: Member[], uid: string): Member[] {
  return members.filter((m) => m.uid !== uid && isLive(m) && m.emailsAdded);
}

/** Apps `uid` had to open on `day` during the active phase (an app's first, partial day is excused). */
export function requiredAppsOn(members: Member[], uid: string, day: string): Member[] {
  return members.filter(
    (m) => m.uid !== uid && m.state === "active" && m.activeSince !== null && m.activeSince < day,
  );
}

export function passThreshold(required: number, ratio: number): number {
  return Math.ceil(required * ratio);
}
