import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> with WidgetsBindingObserver {
  final _page = PageController();
  int _index = 0;
  bool _usage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkUsage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _page.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkUsage();
  }

  Future<void> _checkUsage() async {
    final v = await ref.read(deviceProvider).hasUsageAccess().catchError((_) => false);
    if (mounted) setState(() => _usage = v);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = [
      _Page(icon: Icons.handshake_rounded, title: l.ob1Title, points: [l.ob1P1, l.ob1P2, l.ob1P3]),
      _Page(icon: Icons.verified_user_rounded, title: l.ob2Title, points: [l.ob2P1, l.ob2P2, l.ob2P3]),
      _Page(
        icon: Icons.insights_rounded,
        title: l.ob3Title,
        points: [l.ob3P1, l.ob3P2],
        extra: Column(children: [
          const SizedBox(height: 16),
          InfoCard(
            icon: _usage ? Icons.check_circle_rounded : Icons.query_stats_rounded,
            color: _usage ? Brand.green : Brand.indigo,
            title: l.usageAccessTitle,
            body: l.usageAccessBody,
            action: _usage
                ? Text(l.granted, style: const TextStyle(color: Brand.green, fontWeight: FontWeight.w700))
                : OutlinedButton(
                    onPressed: () => ref.read(deviceProvider).openUsageAccessSettings(),
                    child: Text(l.grantUsageAccess),
                  ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.notifications_active_rounded,
            title: l.notificationsTitle,
            body: l.notificationsBody,
            action: OutlinedButton(
              onPressed: () => FirebaseMessaging.instance.requestPermission(),
              child: Text(l.allowNotifications),
            ),
          ),
        ]),
      ),
    ];
    final last = _index == pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView(
              controller: _page,
              onPageChanged: (i) => setState(() => _index = i),
              children: pages,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < pages.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                width: i == _index ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _index ? Brand.indigo : Brand.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ]),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (last) {
                    ref.read(onboardedProvider.notifier).complete();
                  } else {
                    _page.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  }
                },
                child: Text(last ? l.getStarted : l.next),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.icon, required this.title, required this.points, this.extra});
  final IconData icon;
  final String title;
  final List<String> points;
  final Widget? extra;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(gradient: Brand.gradient, borderRadius: BorderRadius.circular(24)),
            child: Icon(icon, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 28),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          for (final p in points)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.check_circle_rounded, color: Brand.teal, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(p, style: Theme.of(context).textTheme.bodyLarge)),
              ]),
            ),
          ?extra,
        ],
      );
}
