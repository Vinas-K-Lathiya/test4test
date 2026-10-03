import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// What the app knows about newer versions.
class UpdateStatus {
  const UpdateStatus({required this.currentBuild, required this.required, required this.optional, required this.play});

  final int currentBuild;

  /// Below config/app.minVersionCode: the app is blocked until updated.
  final bool required;

  /// Below config/app.latestVersionCode, or Google Play reports a newer build.
  final bool optional;

  /// Google Play's info; null when the app wasn't installed from Play (e.g. sideloaded APK).
  final AppUpdateInfo? play;

  bool get playHasUpdate => play?.updateAvailability == UpdateAvailability.updateAvailable;
  bool get canImmediate => playHasUpdate && (play?.immediateUpdateAllowed ?? false);
  bool get canFlexible => playHasUpdate && (play?.flexibleUpdateAllowed ?? false);
}

/// Checks Firestore config/app {minVersionCode, latestVersionCode} and Google Play.
/// To force everyone below build N to update: set config/app.minVersionCode = N.
final updateStatusProvider = FutureProvider<UpdateStatus>((ref) async {
  final info = await PackageInfo.fromPlatform();
  final build = int.tryParse(info.buildNumber) ?? 0;
  int minBuild = 0, latestBuild = 0;
  try {
    final c = await FirebaseFirestore.instance.collection('config').doc('app').get();
    minBuild = (c.data()?['minVersionCode'] as num?)?.toInt() ?? 0;
    latestBuild = (c.data()?['latestVersionCode'] as num?)?.toInt() ?? 0;
  } catch (_) {}
  AppUpdateInfo? play;
  try {
    play = await InAppUpdate.checkForUpdate();
  } catch (_) {
    // Not installed from Google Play (debug / sideloaded build).
  }
  final playNewer = play?.updateAvailability == UpdateAvailability.updateAvailable;
  return UpdateStatus(
    currentBuild: build,
    required: build < minBuild,
    optional: build < latestBuild || playNewer,
    play: play,
  );
});
