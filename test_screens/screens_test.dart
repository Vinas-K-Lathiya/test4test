// Renders key screens with fake data to PNGs for visual review:
//   flutter test test_screens/screens_test.dart --update-goldens
// Output: test_screens/goldens/*.png
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:testpact/l10n/app_localizations.dart';
import 'package:testpact/src/ads/ads_service.dart';
import 'package:testpact/src/models.dart';
import 'package:testpact/src/providers.dart';
import 'package:testpact/src/screens/dashboard.dart';
import 'package:testpact/src/screens/group/group_screen.dart';
import 'package:testpact/src/screens/my_apps.dart';
import 'package:testpact/src/screens/profile.dart';
import 'package:testpact/src/screens/sign_in.dart';
import 'package:testpact/src/services/activity_sync.dart';
import 'package:testpact/src/theme.dart';
import 'package:testpact/src/widgets/ui.dart';

const me = 'me';
final today = dayKeyNow();
String dayKeyNow() => DateTime.now().toUtc().toIso8601String().substring(0, 10);

Member m(String uid, String name, String app, String pkg, {MemberState state = MemberState.active, int opened = 0, int req = 12}) =>
    Member(
      uid: uid, email: '$uid@x.com', displayName: name, photoUrl: null, trustScore: 50 + uid.length * 7,
      appId: 'a_$uid', appName: app, packageName: pkg, optInWebUrl: '', optInPlayUrl: '', iconUrl: null,
      testNotes: uid == 'u1' ? 'Create an account and add 2 items to the cart.' : '',
      state: state, late: false, setupDeadline: null, emailsAdded: true, emailsAddedVersion: 1, installedAll: true,
      ready: true, activeSince: '2026-01-01', consecutiveMissed: 0, missedDays: 0, activeDays: 4,
      feedbackTo: uid == me ? {'u2': 1} : const {}, lastDays: const [],
      today: TodayStatus(day: today, installed: req, opened: opened, required: req, usageAccess: true), removedReason: null,
    );

final members = [
  m(me, 'Vinas Lathiya', 'My App', 'com.me.app', opened: 2),
  m('u1', 'Aarav', 'YouTube', 'com.google.android.youtube', opened: 12),
  m('u2', 'Ananya', 'Google Maps', 'com.google.android.apps.maps', opened: 12),
  m('u3', 'Arjun', 'Play Store', 'com.android.vending', opened: 4),
  m('u4', 'Diya', 'Zomato', 'com.application.zomato', opened: 0),
  m('u5', 'Kabir', 'Flipkart', 'com.flipkart.android', opened: 7),
  m('u6', 'Meera', 'Drive', 'com.google.android.apps.docs'),
  m('u7', 'Rohan', 'PhonePe', 'com.phonepe.app'),
  m('u8', 'Sara', 'Duolingo', 'com.duolingo'),
];

final group = Group(
  id: '10mkzabc', tier: 'starter', status: GroupStatus.active, createdAt: DateTime(2026, 9, 28), setupDeadline: null,
  rosterVersion: 1, startDay: DateTime.now().toUtc().subtract(const Duration(days: 4)).toIso8601String().substring(0, 10),
  endDay: '2099-01-01', testDays: 16, size: members.length,
);

final profile = Profile(
  uid: me, displayName: 'Vinas Lathiya', photoUrl: null, trustScore: 50,
  stats: {'groupsCompleted': 1, 'groupsJoined': 2, 'activeDays': 14, 'missedDays': 1, 'feedbackGiven': 9},
  badges: const ['first_pact', 'perfect_streak'],
);

AppListing app(String id, String name, String pkg) => AppListing(
    id: id, ownerUid: me, name: name, packageName: pkg, description: '', testNotes: '', optInWebUrl: '', optInPlayUrl: '');

class FakeSync implements ActivitySync {
  @override
  Future<SyncResult> sync(String groupId, List<Member> apps) async => SyncResult(usageAccess: true, byOwner: {
        for (final (i, a) in apps.indexed)
          a.uid: LocalAppStatus(installed: i != 3, minutes: i < 2 ? 6 : 0, opens: i < 2 ? 1 : 0),
      });
  @override
  Future<void> syncCurrentGroup() async {}
}

List<Override> overrides({bool inGroup = true}) => [
      authStateProvider.overrideWith((ref) => const Stream.empty()),
      uidProvider.overrideWithValue(me),
      isAdminProvider.overrideWithValue(true),
      accountProvider.overrideWith((ref) => Stream.value(UserAccount(
          uid: me, email: 'me@x.com', currentGroupId: inGroup ? group.id : null, strikes: 0, banned: false, locale: 'en'))),
      profileProvider.overrideWith((ref, uid) => Stream.value(profile)),
      myProfileProvider.overrideWithValue(AsyncValue.data(profile)),
      queueEntryProvider.overrideWith((ref) => Stream.value(null)),
      queueStatsProvider.overrideWith((ref) => Stream.value({'starter': 7, 'trusted': 2})),
      myAppsProvider.overrideWith((ref) => Stream.value([
            app('a_me', 'My App', 'com.me.app'),
            app('a2', 'Recipe Book', 'com.me.recipes'),
            app('a3', 'Habit Tracker', 'com.me.habits'),
          ])),
      groupProvider.overrideWith((ref, id) => Stream.value(group)),
      membersProvider.overrideWith((ref, id) => Stream.value(members)),
      eventsProvider.overrideWith((ref, id) => Stream.value(const [])),
      myGroupsProvider.overrideWith((ref) => Stream.value([group])),
      inboxProvider.overrideWith((ref) => Stream.value(const [])),
      unreadCountProvider.overrideWithValue(3),
      trustLogProvider.overrideWith((ref) => Stream.value([
            TrustLogEntry(delta: 10, reason: 'group_completed', score: 50, at: DateTime(2026, 9, 30, 18, 5)),
            TrustLogEntry(delta: 2, reason: 'helpful_feedback', score: 40, at: DateTime(2026, 9, 29, 10, 12)),
            TrustLogEntry(delta: -5, reason: 'missed_day', score: 38, at: DateTime(2026, 9, 27, 0, 20)),
          ])),
      activitySyncProvider.overrideWithValue(FakeSync()),
      adsActiveProvider.overrideWithValue(false),
      inlineAdsActiveProvider.overrideWithValue(false),
      adsEligibleProvider.overrideWithValue(false),
    ];

Widget frame({required Widget child, String? title, int tab = 0, bool logo = false}) => Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              toolbarHeight: 64,
              titleSpacing: 20,
              title: logo
                  ? Row(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/branding/logo_round.png', width: 34, height: 34)),
                      const SizedBox(width: 10),
                      Text(title),
                    ])
                  : Text(title),
              actions: [
                IconButton(onPressed: () {}, icon: Badge(label: const Text('3'), backgroundColor: Brand.red, child: const Icon(Icons.notifications_none_rounded, size: 27))),
                const SizedBox(width: 8),
              ],
            ),
      body: child,
      bottomNavigationBar: AppBottomNav(index: tab, onTap: (_) {}, items: const [
        (Icons.home_outlined, Icons.home_rounded, 'Home'),
        (Icons.grid_view_outlined, Icons.grid_view_rounded, 'My apps'),
        (Icons.rate_review_outlined, Icons.rate_review_rounded, 'Feedback'),
        (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
      ]),
    );

Future<void> shot(WidgetTester tester, String name, Widget screen, {List<Override>? ov, double h = 915}) async {
  tester.view.physicalSize = Size(412 * 3, h * 3);
  tester.view.devicePixelRatio = 3;
  final key = GlobalKey();
  await tester.pumpWidget(ProviderScope(
    overrides: ov ?? overrides(),
    child: RepaintBoundary(
      key: key,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: screen,
      ),
    ),
  ));
  for (var i = 0; i < 3; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(() async {
      for (final e in find.byType(Image).evaluate()) {
        await precacheImage((e.widget as Image).image, e);
      }
    });
  }
  await tester.pump(const Duration(seconds: 1));
  await expectLater(find.byKey(key), matchesGoldenFile('goldens/$name.png'));
}

Future<void> loadFonts() async {
  final jakarta = FontLoader('PlusJakartaSans');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    jakarta.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$w.ttf'));
  }
  await jakarta.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(
        File('/opt/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf').readAsBytesSync())));
  await icons.load();
}

void main() {
  setUpAll(loadFonts);

  testWidgets('home', (t) => shot(t, '1_home', frame(title: 'TestPact', logo: true, child: const DashboardTab())));
  testWidgets('home_join', (t) => shot(t, '2_home_join', frame(title: 'TestPact', logo: true, child: const DashboardTab()),
      ov: overrides(inGroup: false)));
  testWidgets('my_apps', (t) => shot(t, '3_my_apps', frame(title: 'My apps', tab: 1, child: const MyAppsTab())));
  testWidgets('group', (t) => shot(t, '4_group_today', GroupScreen(groupId: group.id)));
  testWidgets('profile', (t) => shot(t, '5_profile', frame(title: 'Profile', tab: 3, child: const MyProfileTab()), h: 1500));
  testWidgets('sign_in', (t) => shot(t, '6_sign_in', const SignInScreen()));
}
