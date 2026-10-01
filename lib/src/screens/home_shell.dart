import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../l10n.dart';
import '../providers.dart';
import '../router.dart';
import '../widgets/common.dart';
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
    ref.read(messagingProvider).start(
          onOpenGroup: (id) => ref.read(routerProvider).push('/group/$id'),
          onForeground: (title, body) => scaffoldMessengerKey.currentState
              ?.showSnackBar(SnackBar(content: Text(body.isEmpty ? title : '$title\n$body'))),
        );
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
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l.settingUp),
                ])
              : EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: friendlyError(context, _bootstrapError!),
                  action: Wrap(spacing: 12, children: [
                    OutlinedButton(onPressed: () => ref.read(authServiceProvider).signOut(), child: Text(l.signOut)),
                    FilledButton(onPressed: _runBootstrap, child: Text(l.retry)),
                  ]),
                ),
        ),
      );
    }
    _startMessaging();

    final isAdmin = ref.watch(isAdminProvider);
    final titles = [l.tabHome, l.tabMyApps, l.tabFeedback, l.tabProfile];
    return Scaffold(
      appBar: AppBar(
        title: Text(_tab == 0 ? 'TestPact' : titles[_tab]),
        actions: [
          if (isAdmin)
            IconButton(
              tooltip: l.admin,
              icon: const Icon(Icons.admin_panel_settings_rounded),
              onPressed: () => context.push('/admin'),
            ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: IndexedStack(index: _tab, children: const [
        DashboardTab(),
        MyAppsTab(),
        FeedbackTab(),
        MyProfileTab(),
      ]),
      floatingActionButton: _tab == 1
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/apps/new'),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.addApp),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: l.tabHome),
          NavigationDestination(icon: const Icon(Icons.apps_outlined), selectedIcon: const Icon(Icons.apps_rounded), label: l.tabMyApps),
          NavigationDestination(icon: const Icon(Icons.forum_outlined), selectedIcon: const Icon(Icons.forum_rounded), label: l.tabFeedback),
          NavigationDestination(icon: const Icon(Icons.person_outline_rounded), selectedIcon: const Icon(Icons.person_rounded), label: l.tabProfile),
        ],
      ),
    );
  }
}
