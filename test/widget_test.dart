import 'package:flutter_test/flutter_test.dart';
import 'package:testpact/src/config.dart';
import 'package:testpact/src/models.dart';

Member _m(String uid, MemberState state, {bool emailsAdded = true}) => Member(
      uid: uid,
      email: '$uid@x.com',
      displayName: uid,
      photoUrl: null,
      trustScore: 50,
      appId: 'a$uid',
      appName: 'App $uid',
      packageName: 'com.$uid.app',
      optInWebUrl: '',
      optInPlayUrl: '',
      iconUrl: null,
      testNotes: '',
      state: state,
      late: false,
      setupDeadline: null,
      emailsAdded: emailsAdded,
      emailsAddedVersion: 1,
      installedAll: false,
      ready: false,
      activeSince: null,
      consecutiveMissed: 0,
      missedDays: 0,
      activeDays: 0,
      feedbackTo: const {},
      lastDays: const [],
      today: null,
      removedReason: null,
    );

void main() {
  test('visible apps: others, live, and only after owner added emails (give first)', () {
    final members = [
      _m('me', MemberState.active),
      _m('a', MemberState.active),
      _m('b', MemberState.setup, emailsAdded: false),
      _m('c', MemberState.removed),
      _m('d', MemberState.suspended),
      _m('e', MemberState.setup),
    ];
    expect(visibleAppsFor(members, 'me').map((m) => m.uid), ['a', 'e']);
  });

  test('daily pass threshold is 90% rounded up', () {
    expect(passThreshold(19), 18);
    expect(passThreshold(10), 9);
    expect(passThreshold(0), 0);
  });

  test('trust levels', () {
    Profile p(int score, int completed) => Profile(
          uid: 'x',
          displayName: 'x',
          photoUrl: null,
          trustScore: score,
          stats: {'groupsCompleted': completed},
          badges: const [],
        );
    expect(p(30, 5).level, TrustLevel.probation);
    expect(p(50, 0).level, TrustLevel.newcomer);
    expect(p(55, 1).level, TrustLevel.member);
    expect(p(80, 1).level, TrustLevel.trusted);
    expect(p(130, 3).level, TrustLevel.topTester);
  });

  test('day key is UTC', () {
    expect(dayKey(DateTime.utc(2026, 10, 1, 23, 59)), '2026-10-01');
  });
}
