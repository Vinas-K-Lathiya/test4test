import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { DAILY_PASS_RATIO, REGION } from "./config";
import { dailyTickActive, hourlyTick, tryFormGroup } from "./groups";
import { notify } from "./notify";
import { Member, dayKey, db, passThreshold } from "./util";
import { updateQueueStats } from "./api";

export * from "./api";
export * from "./admin";

const sched = { region: REGION, timeZone: "UTC", timeoutSeconds: 540, memory: "512MiB" as const, maxInstances: 1 };

async function forEachGroup(statuses: string[], fn: (id: string) => Promise<void>): Promise<void> {
  const snap = await db.collection("groups").where("status", "in", statuses).get();
  for (const d of snap.docs) {
    try {
      await fn(d.id);
    } catch (e) {
      logger.error("group tick failed", { groupId: d.id, e });
    }
  }
}

/** Every 15 minutes: form groups from the queue (also handles the "waited long enough" rule). */
export const matchQueue = onSchedule({ ...sched, schedule: "every 15 minutes" }, async () => {
  for (const tier of ["trusted", "starter"] as const) {
    for (let i = 0; i < 20; i++) {
      if (!(await tryFormGroup(tier))) break;
    }
  }
  await updateQueueStats();
});

/** Hourly: setup deadlines, late joiners, reminders, readiness refresh. */
export const hourly = onSchedule({ ...sched, schedule: "every 60 minutes" }, async () => {
  await forEachGroup(["setup", "active"], hourlyTick);
});

/** Daily 00:20 UTC: evaluate yesterday, warnings, auto-kicks, refills, completion. */
export const daily = onSchedule({ ...sched, schedule: "20 0 * * *" }, async () => {
  await forEachGroup(["active"], dailyTickActive);
});

/** Daily 14:00 UTC (19:30 IST): remind active members who haven't finished today. */
export const dailyReminder = onSchedule({ ...sched, schedule: "0 14 * * *" }, async () => {
  const today = dayKey();
  const groups = await db.collection("groups").where("status", "==", "active").get();
  for (const g of groups.docs) {
    const members = await g.ref.collection("members").where("state", "==", "active").get();
    for (const d of members.docs) {
      const m = d.data() as Member;
      const t = m.today;
      const opened = t && t.day === today ? t.opened : 0;
      const required = t && t.day === today ? t.required : 1;
      if (opened < passThreshold(required, DAILY_PASS_RATIO)) {
        await notify(m.uid, "dailyReminder", { n: opened }, { groupId: g.id });
      }
    }
  }
});
