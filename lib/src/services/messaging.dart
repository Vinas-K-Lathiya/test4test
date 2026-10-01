import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Push notifications: FCM token registration, heads-up display while the app is open,
/// and routing when a notification is tapped (from background, terminated or foreground).
class MessagingService {
  static const channelId = 'testpact_default';
  final _local = FlutterLocalNotificationsPlugin();
  bool _started = false;

  Future<void> start({required void Function(String groupId) onOpenGroup}) async {
    if (_started) return;
    _started = true;

    void routeData(Map<String, dynamic> data) {
      final g = data['groupId'];
      if (g is String && g.isNotEmpty) onOpenGroup(g);
    }

    await _local.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings('ic_stat_testpact')),
      onDidReceiveNotificationResponse: (r) {
        if (r.payload == null) return;
        try {
          routeData(Map<String, dynamic>.from(jsonDecode(r.payload!) as Map));
        } catch (_) {}
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          channelId,
          'Group updates',
          description: 'Reminders, warnings, feedback and group changes',
          importance: Importance.high,
        ));

    final fm = FirebaseMessaging.instance;
    await fm.requestPermission();
    await _saveToken(await fm.getToken());
    fm.onTokenRefresh.listen(_saveToken);

    // Android doesn't display FCM notifications while the app is in the foreground; show them ourselves.
    FirebaseMessaging.onMessage.listen((m) {
      final n = m.notification;
      if (n == null) return;
      _local.show(
        id: m.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: n.title,
        body: n.body,
        payload: jsonEncode(m.data),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            'Group updates',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_stat_testpact',
            color: const Color(0xFF4F46E5),
            // Show the full text when expanded instead of cutting it at one line.
            styleInformation: BigTextStyleInformation(n.body ?? ''),
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((m) => routeData(m.data));
    final initial = await fm.getInitialMessage();
    if (initial != null) routeData(initial.data);
  }

  /// Whether the user allowed notifications at the OS level.
  static Future<bool> permissionGranted() async {
    final s = await FirebaseMessaging.instance.getNotificationSettings();
    return s.authorizationStatus == AuthorizationStatus.authorized ||
        s.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> _saveToken(String? token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || token == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'fcmToken': token});
  }
}
