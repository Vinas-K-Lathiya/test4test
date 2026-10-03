import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n.dart';
import '../providers.dart';
import '../router.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/ui.dart';
import 'dashboard.dart';
import 'feedback/feedback_tab.dart';
import 'my_apps.dart';
import 'profile.dart';

/// Makes sure the account exists (bootstrap) and hosts the 4 main tabs.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;
  Future<void>? _bootstrap;
  Object? _bootstrapError;

  void _runBootstrap() {
    final locale = Localizations.localeOf(context).languageCode;
    setState(() {
      _bootstrapError = null;
      _bootstrap = ref.read(authServiceProvider).bootstrap(locale).catchError((Object e) {
        if (mounted) setState(() => _bootstrapError = e);
      });
    });
  }

  void _startMessaging() {
    ref.read(messagingProvider).start(onOpenGroup: (id) => ref.read(routerProvider).push('/group/$id'));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final account = ref.watch(accountProvider);

    if (account.isLoading && !account.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (account.value == null) {
      if (_bootstrap == null && _bootstrapError == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _runBootstrap());
      }
      return Scaffold(
        body: Center(
          child: _bootstrapError == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(l.settingUp)],
                )
              : EmptyState(
                  image: 'warning',
                  title: friendlyError(context, _bootstrapError!),
                  action: Wrap(
                    spacing: 12,
                    children: [
                      OutlinedButton(onPressed: () => ref.read(authServiceProvider).signOut(), child: Text(l.signOut)),
                      FilledButton(onPressed: _runBootstrap, child: Text(l.retry)),
                    ],
                  ),
                ),
        ),
      );
    }
    _startMessaging();

    final isAdmin = ref.watch(isAdminProvider);
    final unread = ref.watch(unreadCountProvider);
    final titles = [l.tabHome, l.tabMyApps, l.tabFeedback, l.tabProfile];
    final bell = IconButton(
      tooltip: l.notificationsInbox,
      onPressed: () => context.push('/notifications'),
      icon: Badge(
        isLabelVisible: unread > 0,
        backgroundColor: Brand.red,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: const Icon(Icons.notifications_none_rounded, size: 27),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 20,
        title: _tab == 0
            ? Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/branding/logo_round.png', width: 34, height: 34),
                  ),
                  const SizedBox(width: 10),
                  const Text('TestPact'),
                ],
              )
            : Text(titles[_tab]),
        actions: [
          if (isAdmin && _tab == 0)
            IconButton(
              tooltip: l.admin,
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 26),
              onPressed: () => context.push('/admin'),
            ),
          bell,
          if (_tab == 3)
            IconButton(
              tooltip: l.settings,
              icon: const Icon(Icons.settings_outlined, size: 26),
              onPressed: () => context.push('/settings'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _tab, children: const [DashboardTab(), MyAppsTab(), FeedbackTab(), MyProfileTab()]),
      floatingActionButton: _tab == 1
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: Brand.gradient,
                boxShadow: [
                  BoxShadow(color: Brand.indigo.withValues(alpha: 0.4), blurRadius: 18, offset: const Offset(0, 8)),
                ],
              ),
              child: FloatingActionButton(
                tooltip: l.addApp,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () => context.push('/apps/new'),
                child: const Icon(Icons.add_rounded, size: 30),
              ),
            )
          : null,
      bottomNavigationBar: AppBottomNav(
        index: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: [
          (Icons.home_outlined, Icons.home_rounded, l.tabHome),
          (Icons.grid_view_outlined, Icons.grid_view_rounded, l.tabMyApps),
          (Icons.rate_review_outlined, Icons.rate_review_rounded, l.tabFeedback),
          (Icons.person_outline_rounded, Icons.person_rounded, l.tabProfile),
        ],
      ),
    );
  }
}
