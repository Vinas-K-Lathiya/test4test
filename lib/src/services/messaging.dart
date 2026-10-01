import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Registers the FCM token on the user doc and routes notification taps.
class MessagingService {
  bool _started = false;

  Future<void> start({
    required void Function(String groupId) onOpenGroup,
    required void Function(String title, String body) onForeground,
  }) async {
    if (_started) return;
    _started = true;
    final fm = FirebaseMessaging.instance;
    await fm.requestPermission();
    await _saveToken(await fm.getToken());
    fm.onTokenRefresh.listen(_saveToken);

    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n != null) onForeground(n.title ?? '', n.body ?? '');
    });
    void route(RemoteMessage m) {
      final g = m.data['groupId'];
      if (g is String && g.isNotEmpty) onOpenGroup(g);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(route);
    final initial = await fm.getInitialMessage();
    if (initial != null) route(initial);
  }

  Future<void> _saveToken(String? token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || token == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'fcmToken': token});
  }
}
