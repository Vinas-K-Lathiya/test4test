/** Central tuning knobs for TestPact. Change here, redeploy, done. */

export const REGION = "asia-south1";
export const TIME_ZONE = "UTC"; // Day boundaries are UTC everywhere (client + server).

export const ADMIN_EMAILS = ["vlathiya5944@gmail.com"];

/** Members per group when it is formed. */
export const GROUP_SIZE = 20;
/** Google requires 12; we never start a test with fewer than this. */
export const MIN_TO_START = 14;
/** During the first days of a test, refill when active members drop below this. */
export const REFILL_BELOW = 15;
/** Active days (1-based) during which refills are still allowed. Late joiners still get >= 14 days. */
export const REFILL_MAX_DAY = 2;
/** Length of a test in days. Google needs 14; 2 extra days of buffer. */
export const TEST_DAYS = 16;
/** Hours members have to finish setup. */
export const SETUP_HOURS = 48;
/** Hours a refilled (late) member has to finish setup. */
export const LATE_SETUP_HOURS = 24;
/** How many 24h setup extensions a group may get before it starts or is cancelled. */
export const MAX_SETUP_ROUNDS = 3;
/** A smaller group may form if the oldest person in the queue has waited this long. */
export const FORM_EARLY_AFTER_HOURS = 48;

/** Fraction of assigned apps that must be opened for a day to count as active. */
export const DAILY_PASS_RATIO = 0.9;
/** Consecutive missed days before an automatic kick. */
export const KICK_AFTER_MISSED = 3;

/** Distinct reporters needed: max(REPORT_MIN, ceil(activeMembers * REPORT_RATIO)) within REPORT_WINDOW_HOURS. */
export const REPORT_MIN = 3;
export const REPORT_RATIO = 0.25;
export const REPORT_WINDOW_HOURS = 48;

export const MAX_STRIKES = 3;

export const TRUST = {
  start: 50,
  min: 0,
  max: 300,
  groupCompleted: 10,
  goodDay: 1,
  helpfulFeedback: 2,
  missedDay: -5,
  confirmedReport: -15,
  kicked: -30,
  setupFailed: -10,
  leftGroup: -20,
  falseReport: -3,
} as const;

/** Users below this score, or with zero completed groups, are matched in "starter" groups. */
export const TRUSTED_TIER_MIN_SCORE = 60;
