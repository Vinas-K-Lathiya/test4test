import { test } from "node:test";
import assert from "node:assert/strict";
import { evaluateMemberDay } from "./groups";
import { Member, addDays, diffDays, passThreshold, requiredAppsOn } from "./util";

function m(uid: string, state: Member["state"], activeSince: string | null): Member {
  return { uid, state, activeSince, emailsAdded: true } as Member;
}

test("date helpers", () => {
  assert.equal(addDays("2026-02-27", 2), "2026-03-01");
  assert.equal(diffDays("2026-10-01", "2026-10-16"), 15);
  assert.equal(passThreshold(19, 0.9), 18);
});

test("an app's first partial day is excused", () => {
  const ms = [m("a", "active", "2026-10-01"), m("b", "active", "2026-10-02"), m("c", "removed", "2026-10-01")];
  assert.deepEqual(requiredAppsOn(ms, "x", "2026-10-02").map((x) => x.uid), ["a"]);
});

test("day passes at 90% opened, installed required", () => {
  const ms = Array.from({ length: 11 }, (_, i) => m(`u${i}`, "active", "2026-10-01"));
  const me = ms[0];
  const act: Record<string, { installed: boolean; minutes: number; opens: number }> = {};
  for (let i = 1; i < 11; i++) act[`u${i}`] = { installed: true, minutes: 0, opens: 1 };
  assert.equal(evaluateMemberDay(ms, me, "2026-10-02", act).ok, true);
  act.u1 = { installed: true, minutes: 0, opens: 0 };
  assert.equal(evaluateMemberDay(ms, me, "2026-10-02", act).ok, true); // 9/10 opened
  act.u2 = { installed: false, minutes: 5, opens: 3 };
  const r = evaluateMemberDay(ms, me, "2026-10-02", act);
  assert.equal(r.ok, false);
  assert.equal(r.opened, 8);
  assert.equal(r.required, 10);
});
