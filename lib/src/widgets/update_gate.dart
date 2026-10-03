import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';

import '../config.dart';
import '../l10n.dart';
import '../services/updates.dart';
import '../theme.dart';
import 'common.dart';
import 'ui.dart';

/// Blocks the app when an update is required; offers optional updates once per launch.
class UpdateGate extends ConsumerStatefulWidget {
  const UpdateGate({super.key, required this.child, required this.navigatorKey});
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  ConsumerState<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends ConsumerState<UpdateGate> {
  bool _offered = false;

  Future<void> _updateNow(UpdateStatus s) async {
    try {
      if (s.canImmediate) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
    } catch (_) {}
    await openUrl(AppConfig.playStoreUrl);
  }

  /// Downloads in the background via Play, then offers a restart.
  Future<void> _flexible(UpdateStatus s) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l = context.l10n;
    try {
      final r = await InAppUpdate.startFlexibleUpdate();
      if (r != AppUpdateResult.success) return;
      messenger?.showSnackBar(
        SnackBar(
          duration: const Duration(days: 1),
          content: Text(l.updateDownloaded),
          action: SnackBarAction(label: l.restart, onPressed: InAppUpdate.completeFlexibleUpdate),
        ),
      );
    } catch (_) {
      await openUrl(AppConfig.playStoreUrl);
    }
  }

  void _offer(UpdateStatus s) {
    if (_offered) return;
    _offered = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctx = widget.navigatorKey.currentContext;
      if (ctx == null || !mounted) return;
      final l = context.l10n;
      final go = await showDialog<bool>(
        context: ctx,
        builder: (d) => AlertDialog(
          icon: const Img3d('sparkles', size: 56),
          title: Text(l.updateAvailableTitle),
          content: Text(l.updateAvailableBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d, false), child: Text(l.later)),
            FilledButton(onPressed: () => Navigator.pop(d, true), child: Text(l.updateNow)),
          ],
        ),
      );
      if (go != true) return;
      if (s.canFlexible) {
        await _flexible(s);
      } else {
        await _updateNow(s);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(updateStatusProvider).value;
    if (status != null && status.required) return _requiredScreen(context, status);
    if (status != null && status.optional) _offer(status);
    return widget.child;
  }

  Widget _requiredScreen(BuildContext context, UpdateStatus s) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 168,
                  height: 168,
                  decoration: const BoxDecoration(gradient: Brand.washGradient, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Img3d('rocket', size: 104),
                ),
                const SizedBox(height: 28),
                Text(
                  l.updateRequiredTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(l.updateRequiredBody, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => _updateNow(s),
                  icon: const Icon(Icons.system_update_rounded),
                  label: Text(l.updateNow),
                ),
                const SizedBox(height: 12),
                Text(l.appVersion('${s.currentBuild}'), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
