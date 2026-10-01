import 'package:flutter/services.dart';

/// Usage of one app since a point in time.
class AppUsage {
  const AppUsage({required this.minutes, required this.opens});
  final int minutes;
  final int opens;
}

/// Thin Dart wrapper around the native `testpact/device` channel.
///
/// Every call is limited to the package names passed in; the plugin never lists
/// other apps installed on the device.
class DeviceBridge {
  const DeviceBridge();

  static const _ch = MethodChannel('testpact/device');

  Future<String> deviceId() async => (await _ch.invokeMethod<String>('deviceId')) ?? '';

  Future<Map<String, bool>> installed(List<String> packages) async {
    if (packages.isEmpty) return {};
    final r = await _ch.invokeMapMethod<String, bool>('installed', {'packages': packages});
    return r ?? {};
  }

  Future<bool> hasUsageAccess() async => (await _ch.invokeMethod<bool>('hasUsageAccess')) ?? false;

  Future<void> openUsageAccessSettings() => _ch.invokeMethod('openUsageAccessSettings');

  Future<Map<String, AppUsage>> usageSince(List<String> packages, DateTime start) async {
    if (packages.isEmpty) return {};
    final r = await _ch.invokeMapMethod<String, dynamic>('usageSince', {
      'packages': packages,
      'startMillis': start.millisecondsSinceEpoch,
    });
    return {
      for (final e in (r ?? {}).entries)
        e.key: AppUsage(
          minutes: ((e.value as Map)['minutes'] as num?)?.toInt() ?? 0,
          opens: ((e.value as Map)['opens'] as num?)?.toInt() ?? 0,
        ),
    };
  }

  /// Launches the app; returns false if it isn't installed.
  Future<bool> launch(String package) async =>
      (await _ch.invokeMethod<bool>('launch', {'package': package})) ?? false;

  Future<String> integrityToken(String nonce, {int cloudProjectNumber = 0}) async =>
      (await _ch.invokeMethod<String>('integrityToken', {
        'nonce': nonce,
        'cloudProjectNumber': cloudProjectNumber,
      })) ??
      '';
}
