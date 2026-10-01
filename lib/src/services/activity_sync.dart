import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_bridge/device_bridge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models.dart';
import 'api.dart';

/// What this phone sees for one assigned app today.
class LocalAppStatus {
  const LocalAppStatus({required this.installed, required this.minutes, required this.opens});
  final bool installed;
  final int minutes;
  final int opens;
  bool get opened => installed && (opens > 0 || minutes >= 1);
}

class SyncResult {
  SyncResult({required this.byOwner, required this.usageAccess});
  final Map<String, LocalAppStatus> byOwner;
  final bool usageAccess;
}

/// Reads install + usage data for the assigned apps and reports it to the server.
class ActivitySync {
  ActivitySync(this._api, this._device);
  final Api _api;
  final DeviceBridge _device;

  static String _openKey(String pkg) => 'opens_${dayKey()}_$pkg';

  /// Remembers an "Open" tap from inside TestPact (counts even without Usage Access).
  static Future<void> recordOpen(String pkg) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_openKey(pkg), (p.getInt(_openKey(pkg)) ?? 0) + 1);
  }

  Future<SyncResult> sync(String groupId, List<Member> apps) async {
    final pkgs = apps.map((a) => a.packageName).toList();
    final installed = await _device.installed(pkgs);
    final usageAccess = await _device.hasUsageAccess();
    final usage = usageAccess ? await _device.usageSince(pkgs, utcMidnight()) : <String, AppUsage>{};
    final prefs = await SharedPreferences.getInstance();

    final byOwner = <String, LocalAppStatus>{};
    for (final a in apps) {
      final u = usage[a.packageName];
      final localOpens = prefs.getInt(_openKey(a.packageName)) ?? 0;
      byOwner[a.uid] = LocalAppStatus(
        installed: installed[a.packageName] ?? false,
        minutes: u?.minutes ?? 0,
        opens: (u?.opens ?? 0) > localOpens ? u!.opens : localOpens,
      );
    }
    await _api.syncActivity(
      groupId: groupId,
      usageAccess: usageAccess,
      apps: {
        for (final e in byOwner.entries)
          e.key: {'installed': e.value.installed, 'minutes': e.value.minutes, 'opens': e.value.opens},
      },
    );
    return SyncResult(byOwner: byOwner, usageAccess: usageAccess);
  }

  /// Used by the background worker: figures out the current group itself.
  Future<void> syncCurrentGroup() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final db = FirebaseFirestore.instance;
    final user = await db.collection('users').doc(uid).get();
    final groupId = user.data()?['currentGroupId'] as String?;
    if (groupId == null) return;
    final ms = await db.collection('groups').doc(groupId).collection('members').get();
    final members = ms.docs.map(Member.fromDoc).toList();
    final me = members.where((m) => m.uid == uid).firstOrNull;
    if (me == null || !me.isLive) return;
    await sync(groupId, visibleAppsFor(members, uid));
  }
}
