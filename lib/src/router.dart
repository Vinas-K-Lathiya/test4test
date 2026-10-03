import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart';
import 'screens/admin.dart';
import 'screens/app_form.dart';
import 'screens/appeal.dart';
import 'screens/feedback/feedback_form.dart';
import 'screens/group/group_screen.dart';
import 'screens/home_shell.dart';
import 'screens/join_queue.dart';
import 'screens/notifications.dart';
import 'screens/onboarding.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Bridges Riverpod state changes into GoRouter redirects.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
    ref.listen(onboardedProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;
      final signedIn = auth.value != null;
      final loc = state.matchedLocation;
      if (!signedIn) return loc == '/signin' ? null : '/signin';
      if (!ref.read(onboardedProvider)) return loc == '/onboarding' ? null : '/onboarding';
      if (loc == '/signin' || loc == '/onboarding') return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/signin', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/', builder: (_, _) => const HomeShell()),
      GoRoute(path: '/join', builder: (_, _) => const JoinQueueScreen()),
      GoRoute(path: '/apps/new', builder: (_, _) => const AppFormScreen()),
      GoRoute(
        path: '/apps/:id',
        builder: (_, s) => AppFormScreen(appId: s.pathParameters['id']),
      ),
      GoRoute(
        path: '/group/:id',
        builder: (_, s) => GroupScreen(groupId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/group/:id/feedback/:to',
        builder: (_, s) => FeedbackFormScreen(groupId: s.pathParameters['id']!, toUid: s.pathParameters['to']!),
      ),
      GoRoute(
        path: '/profile/:uid',
        builder: (_, s) => PublicProfileScreen(uid: s.pathParameters['uid']!),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/appeal', builder: (_, _) => const AppealScreen()),
      GoRoute(path: '/admin', builder: (_, _) => const AdminScreen()),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
    ],
  );
});
