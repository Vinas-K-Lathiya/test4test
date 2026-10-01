import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n.dart';
import '../services/connectivity.dart';
import '../theme.dart';

/// Covers the whole app with a "No internet" screen while offline and removes it automatically
/// (with a short "Back online" message) when the connection returns.
class ConnectivityGate extends ConsumerStatefulWidget {
  const ConnectivityGate({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends ConsumerState<ConnectivityGate> {
  bool _wasOffline = false;
  bool _retrying = false;

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineProvider);
    ref.listen(onlineProvider, (prev, next) {
      if (next && _wasOffline) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
          content: Text(context.l10n.backOnline),
          backgroundColor: Brand.green,
          duration: const Duration(seconds: 2),
        ));
      }
      _wasOffline = !next;
    });

    return Stack(children: [
      widget.child,
      IgnorePointer(
        ignoring: online,
        child: AnimatedOpacity(
          opacity: online ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: online ? const SizedBox.shrink() : _offlineScreen(context),
        ),
      ),
    ]);
  }

  Widget _offlineScreen(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(color: Brand.indigo.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.wifi_off_rounded, size: 56, color: Brand.indigo),
              ),
              const SizedBox(height: 28),
              Text(l.noInternetTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(l.noInternetBody, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _retrying
                    ? null
                    : () async {
                        setState(() => _retrying = true);
                        await ref.read(onlineProvider.notifier).recheck();
                        if (mounted) setState(() => _retrying = false);
                      },
                icon: _retrying
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh_rounded),
                label: Text(_retrying ? l.checkingConnection : l.retry),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
