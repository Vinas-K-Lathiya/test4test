import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'ads_service.dart';

/// Providers that don't block ads, so users may keep them on.
bool _isSafeDns(String host) {
  final h = host.toLowerCase();
  return h == 'dns.google' ||
      h.endsWith('.dns.google') ||
      h == 'one.one.one.one' ||
      h == '1dot1dot1dot1.cloudflare-dns.com' ||
      h.endsWith('quad9.net');
}

/// Does the ad server resolve to a real address? Ad-blocking DNS answers 0.0.0.0 / nothing.
Future<bool> _adServerBlocked() async {
  try {
    final r = await InternetAddress.lookup('googleads.g.doubleclick.net').timeout(const Duration(seconds: 4));
    return r.isEmpty || r.every((a) => a.isLoopback || a.address == '0.0.0.0' || a.address == '::');
  } catch (_) {
    return true;
  }
}

/// The Private DNS hostname that must be turned off, or null if everything is fine.
final blockingPrivateDnsProvider = FutureProvider<String?>((ref) async {
  if (!Platform.isAndroid) return null;
  try {
    final dns = await ref.read(deviceProvider).privateDns();
    final host = dns.server;
    if (host == null || host.isEmpty) return null; // Off or Automatic
    if (_isSafeDns(host) && !await _adServerBlocked()) return null;
    return host;
  } catch (_) {
    return null;
  }
});

/// Once ads are active for a user (after 2 days), a Private DNS provider that blocks ads must be
/// turned off. Rechecks every time the app comes back to the foreground.
class PrivateDnsGate extends ConsumerStatefulWidget {
  const PrivateDnsGate({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<PrivateDnsGate> createState() => _PrivateDnsGateState();
}

class _PrivateDnsGateState extends ConsumerState<PrivateDnsGate> with WidgetsBindingObserver {
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(blockingPrivateDnsProvider);
  }

  Future<void> _recheck() async {
    setState(() => _checking = true);
    ref.invalidate(blockingPrivateDnsProvider);
    await ref.read(blockingPrivateDnsProvider.future);
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(adsEligibleProvider)) return widget.child;
    final host = ref.watch(blockingPrivateDnsProvider).value;
    if (host == null) return widget.child;

    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          children: [
            Center(
              child: Container(
                width: 168,
                height: 168,
                decoration: const BoxDecoration(gradient: Brand.washGradient, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Img3d('globe', size: 104),
              ),
            ),
            const SizedBox(height: 24),
            Text(l.privateDnsTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(
              l.privateDnsBody,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Brand.muted, height: 1.4),
            ),
            const SizedBox(height: 8),
            Center(
              child: StatusPill(host, color: Brand.red, icon: Icons.dns_rounded),
            ),
            const SizedBox(height: 20),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, step) in [l.privateDnsStep1, l.privateDnsStep2, l.privateDnsStep3].indexed)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Brand.indigo.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(color: Brand.indigo, fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(step, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(deviceProvider).openNetworkSettings(),
              icon: const Icon(Icons.settings_rounded),
              label: Text(l.openSettings),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _checking ? null : _recheck,
              child: _checking
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l.privateDnsDone),
            ),
          ],
        ),
      ),
    );
  }
}
