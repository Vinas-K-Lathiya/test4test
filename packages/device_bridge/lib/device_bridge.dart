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

  /// Private DNS state. `server` is set only when the user picked a specific provider hostname.
  Future<({bool active, String? server, String? mode})> privateDns() async {
    final r = await _ch.invokeMapMethod<String, dynamic>('privateDns') ?? const {};
    return (active: r['active'] == true, server: r['server'] as String?, mode: r['mode'] as String?);
  }

  /// Opens Network & internet settings (where Private DNS lives).
  Future<void> openNetworkSettings() => _ch.invokeMethod('openNetworkSettings');

  /// Opens Android's notification settings page for this app.
  Future<void> openNotificationSettings() => _ch.invokeMethod('openNotificationSettings');

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
