import 'package:device_bridge/device_bridge.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../../firebase_options.dart';
import 'activity_sync.dart';
import 'api.dart';

const _syncTask = 'testpact.syncActivity';

/// Runs in a background isolate every few hours so testers get credit even if they
/// open apps from the launcher instead of from TestPact.
@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, _) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      await ActivitySync(Api(), const DeviceBridge()).syncCurrentGroup();
    } catch (_) {
      // Next run will try again.
    }
    return true;
  });
}

Future<void> scheduleBackgroundSync() async {
  await Workmanager().initialize(backgroundDispatcher);
  await Workmanager().registerPeriodicTask(
    _syncTask,
    _syncTask,
    frequency: const Duration(hours: 2),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
