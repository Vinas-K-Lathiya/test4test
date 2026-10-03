import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_bridge/device_bridge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'services/activity_sync.dart';
import 'services/api.dart';
import 'services/auth.dart';
import 'services/messaging.dart';

final _db = FirebaseFirestore.instance;

// ---- Services ---------------------------------------------------------------

/// Overridden in main() with the loaded instance.
final prefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());
final apiProvider = Provider((ref) => Api());
final deviceProvider = Provider((ref) => const DeviceBridge());
final authServiceProvider = Provider((ref) => AuthService(ref.watch(apiProvider), ref.watch(deviceProvider)));
final activitySyncProvider = Provider((ref) => ActivitySync(ref.watch(apiProvider), ref.watch(deviceProvider)));
final messagingProvider = Provider((ref) => MessagingService());

// ---- Settings ---------------------------------------------------------------

class LocaleController extends Notifier<Locale?> {
  static const _key = 'locale';

  @override
  Locale? build() {
    final code = ref.watch(prefsProvider).getString(_key);
    return code == null ? null : Locale(code);
  }

  Future<void> set(String? code) async {
    final prefs = ref.read(prefsProvider);
    if (code == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, code);
    }
    state = code == null ? null : Locale(code);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && code != null) {
      await _db.collection('users').doc(uid).update({'locale': code}).catchError((_) {});
    }
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class OnboardingController extends Notifier<bool> {
  static const _key = 'onboarded_v1';
  @override
  bool build() => ref.watch(prefsProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    await ref.read(prefsProvider).setBool(_key, true);
    state = true;
  }
}

final onboardedProvider = NotifierProvider<OnboardingController, bool>(OnboardingController.new);

// ---- Auth & account ---------------------------------------------------------

final authStateProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final uidProvider = Provider<String?>((ref) => ref.watch(authStateProvider).value?.uid);

final isAdminProvider = Provider<bool>((ref) {
  ref.watch(authStateProvider);
  return ref.read(authServiceProvider).isAdmin;
});

/// users/{uid} – null while it doesn't exist yet (before bootstrap).
final accountProvider = StreamProvider<UserAccount?>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(null);
  return _db.collection('users').doc(uid).snapshots().map((d) => d.exists ? UserAccount.fromDoc(d) : null);
});

final profileProvider = StreamProvider.family<Profile?, String>((ref, uid) {
  return _db.collection('profiles').doc(uid).snapshots().map((d) => d.exists ? Profile.fromDoc(d) : null);
});

final myProfileProvider = Provider<AsyncValue<Profile?>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return const AsyncValue.data(null);
  return ref.watch(profileProvider(uid));
});

final trustLogProvider = StreamProvider<List<TrustLogEntry>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('profiles')
      .doc(uid)
      .collection('trustLog')
      .orderBy('at', descending: true)
      .limit(50)
      .snapshots()
      .map((s) => s.docs.map(TrustLogEntry.fromDoc).toList());
});

// ---- Notifications ----------------------------------------------------------

final inboxProvider = StreamProvider<List<InboxItem>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('users')
      .doc(uid)
      .collection('inbox')
      .orderBy('at', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map(InboxItem.fromDoc).toList());
});

final unreadCountProvider = Provider<int>(
  (ref) => (ref.watch(inboxProvider).value ?? const []).where((i) => !i.read).length,
);

/// OS-level notification permission; invalidate to re-check after returning from settings.
final notificationPermissionProvider = FutureProvider<bool>((ref) => MessagingService.permissionGranted());

// ---- Apps & queue -----------------------------------------------------------

final myAppsProvider = StreamProvider<List<AppListing>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('apps')
      .where('ownerUid', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map(AppListing.fromDoc).toList()..sort((a, b) => a.name.compareTo(b.name)));
});

final queueEntryProvider = StreamProvider<QueueEntry?>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(null);
  return _db.collection('queue').doc(uid).snapshots().map((d) => d.exists ? QueueEntry.fromDoc(d) : null);
});

final queueStatsProvider = StreamProvider<Map<String, int>>((ref) {
  return _db.collection('stats').doc('queue').snapshots().map((d) {
    final j = d.data() ?? {};
    return {'starter': (j['starter'] as num?)?.toInt() ?? 0, 'trusted': (j['trusted'] as num?)?.toInt() ?? 0};
  });
});

// ---- Groups -----------------------------------------------------------------

final groupProvider = StreamProvider.family<Group?, String>((ref, id) {
  return _db.collection('groups').doc(id).snapshots().map((d) => d.exists ? Group.fromDoc(d) : null);
});

final membersProvider = StreamProvider.family<List<Member>, String>((ref, id) {
  return _db
      .collection('groups')
      .doc(id)
      .collection('members')
      .snapshots()
      .map((s) => s.docs.map(Member.fromDoc).toList()..sort((a, b) => a.displayName.compareTo(b.displayName)));
});

final eventsProvider = StreamProvider.family<List<GroupEvent>, String>((ref, id) {
  return _db
      .collection('groups')
      .doc(id)
      .collection('events')
      .orderBy('at', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map(GroupEvent.fromDoc).toList());
});

final myGroupsProvider = StreamProvider<List<Group>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('groups')
      .where('memberUids', arrayContains: uid)
      .orderBy('createdAt', descending: true)
      .limit(30)
      .snapshots()
      .map((s) => s.docs.map(Group.fromDoc).toList());
});

// ---- Feedback ---------------------------------------------------------------

final feedbackReceivedProvider = StreamProvider<List<FeedbackItem>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('feedback')
      .where('toUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map(FeedbackItem.fromDoc).toList());
});

final feedbackGivenProvider = StreamProvider<List<FeedbackItem>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('feedback')
      .where('fromUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map(FeedbackItem.fromDoc).toList());
});

// ---- Appeals & admin --------------------------------------------------------

final myAppealsProvider = StreamProvider<List<Appeal>>((ref) {
  final uid = ref.watch(uidProvider);
  if (uid == null) return Stream.value(const []);
  return _db
      .collection('appeals')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map(
        (s) =>
            s.docs.map(Appeal.fromDoc).toList()
              ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))),
      );
});

final openReviewsProvider = StreamProvider<List<Review>>((ref) {
  return _db
      .collection('reviews')
      .where('status', isEqualTo: 'open')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Review.fromDoc).toList());
});

final openAppealsProvider = StreamProvider<List<Appeal>>((ref) {
  return _db
      .collection('appeals')
      .where('status', isEqualTo: 'open')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Appeal.fromDoc).toList());
});

final reportsByIdsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, idsCsv) async {
  final ids = idsCsv.split(',').where((e) => e.isNotEmpty).toList();
  final docs = await Future.wait(ids.map((id) => _db.collection('reports').doc(id).get()));
  return docs.where((d) => d.exists).map((d) => d.data()!).toList();
});
