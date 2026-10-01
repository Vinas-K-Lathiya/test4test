import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n.dart';
import '../models.dart';
import '../theme.dart';
import 'labels.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.name, this.url, this.size = 40});
  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundImage: url != null && url!.isNotEmpty ? NetworkImage(url!) : null,
      child: Text(initials, style: TextStyle(fontSize: size * 0.4, fontWeight: FontWeight.w700)),
    );
  }
}

class AppIconView extends StatelessWidget {
  const AppIconView({super.key, required this.name, this.url, this.size = 44});
  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(size * 0.24);
    if (url != null && url!.isNotEmpty) {
      return ClipRRect(
        borderRadius: r,
        child: Image.network(url!, width: size, height: size, fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(r)),
      );
    }
    return _fallback(r);
  }

  Widget _fallback(BorderRadius r) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(gradient: Brand.gradient, borderRadius: r),
        alignment: Alignment.center,
        child: Text(
          name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.42),
        ),
      );
}

class StatusDot extends StatelessWidget {
  const StatusDot(this.color, {super.key, this.size = 10});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ),
          ?trailing,
        ]),
      );
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.icon, required this.title, this.body, this.color, this.action});
  final IconData icon;
  final String title;
  final String? body;
  final Color? color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: c, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              if (body != null) ...[
                const SizedBox(height: 4),
                Text(body!, style: Theme.of(context).textTheme.bodyMedium),
              ],
              if (action != null) ...[const SizedBox(height: 10), action!],
            ]),
          ),
        ]),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.body, this.action});
  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(body!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ]),
        ),
      );
}

class TrustChip extends StatelessWidget {
  const TrustChip({super.key, required this.level, required this.score, this.dense = false});
  final TrustLevel level;
  final int score;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = levelColor(level);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: dense ? 2 : 4),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(99)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified_user_rounded, size: dense ? 12 : 14, color: c),
        const SizedBox(width: 4),
        Text('${levelLabel(context.l10n, level)} · $score',
            style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: dense ? 11 : 12)),
      ]),
    );
  }
}

/// Renders an AsyncValue with consistent loading / error states.
class AsyncView<T> extends StatelessWidget {
  const AsyncView(this.value, {super.key, required this.builder});
  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => value.when(
        data: builder,
        loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(friendlyError(context, e), textAlign: TextAlign.center),
          ),
        ),
      );
}

String friendlyError(BuildContext context, Object e) {
  final l = context.l10n;
  if (e is FirebaseFunctionsException) {
    final m = e.message ?? '';
    switch (m) {
      case 'device-in-use':
        return l.errDeviceInUse;
      case 'banned':
        return l.errBanned;
      case 'already-in-group':
        return l.errAlreadyInGroup;
      case 'app-not-found':
        return l.errAppNotFound;
      case 'appeal-open':
        return l.errAppealOpen;
      case 'already-rated':
        return l.errAlreadyRated;
    }
    if (m.startsWith('integrity')) return l.errIntegrity;
    if (e.code == 'unavailable' || e.code == 'deadline-exceeded') return l.errNetwork;
    if (e.code == 'invalid-argument' && m.isNotEmpty) return m;
  }
  final s = e.toString();
  if (s.contains('network') || s.contains('SocketException')) return l.errNetwork;
  return l.errGeneric;
}

/// Runs an async action with a blocking progress dialog and a snackbar on success/failure.
Future<bool> runAction(BuildContext context, Future<void> Function() action, {String? success}) async {
  final messenger = ScaffoldMessenger.of(context);
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const PopScope(canPop: false, child: Center(child: CircularProgressIndicator())),
  );
  try {
    await action();
    nav.pop();
    if (success != null) messenger.showSnackBar(SnackBar(content: Text(success)));
    return true;
  } catch (e) {
    nav.pop();
    if (context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(friendlyError(context, e))));
    }
    return false;
  }
}

Future<bool> confirm(BuildContext context, {required String title, required String body, required String ok, bool danger = false}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.cancel)),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: Brand.red) : null,
          onPressed: () => Navigator.pop(c, true),
          child: Text(ok),
        ),
      ],
    ),
  );
  return r ?? false;
}

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
