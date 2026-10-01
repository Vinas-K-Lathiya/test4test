import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../services/activity_sync.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Step 1: add everyone's email to your closed test. Step 2: join + install everyone's app.
class SetupTab extends ConsumerStatefulWidget {
  const SetupTab({super.key, required this.group, required this.members});
  final Group group;
  final List<Member> members;
  @override
  ConsumerState<SetupTab> createState() => _SetupTabState();
}

class _SetupTabState extends ConsumerState<SetupTab> with WidgetsBindingObserver {
  Map<String, LocalAppStatus> _local = {};
  bool _checking = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Member? get _me => widget.members.where((m) => m.uid == ref.read(uidProvider)).firstOrNull;

  Future<void> _check() async {
    final me = _me;
    if (me == null || !me.isLive || _checking) return;
    setState(() => _checking = true);
    try {
      final r = await ref
          .read(activitySyncProvider)
          .sync(widget.group.id, visibleAppsFor(widget.members, me.uid));
      if (mounted) setState(() => _local = r.byOwner);
    } catch (_) {
      // Shown as "not verified yet"; user can retry.
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = _me;
    if (me == null) return const SizedBox.shrink();
    final others = widget.members.where((m) => m.uid != me.uid && m.isLive).toList();
    final emails = others.map((m) => m.email).toList();
    final visible = visibleAppsFor(widget.members, me.uid);
    final waitingOn = others.where((m) => !m.emailsAdded).length;
    final emailsDone = me.emailsAddedVersion >= widget.group.rosterVersion;
    final installed = visible.where((a) => _local[a.uid]?.installed ?? false).length;
    final deadline = me.late ? me.setupDeadline : widget.group.setupDeadline;
    final left = deadline?.difference(DateTime.now());

    return RefreshIndicator(
      onRefresh: _check,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 32), children: [
        if (me.state == MemberState.setup && left != null)
          InfoCard(
            icon: Icons.timer_outlined,
            color: left.inHours < 12 ? Brand.red : Brand.indigo,
            title: left.isNegative
                ? l.setupDeadlinePassed
                : l.setupTimeLeft(left.inHours, left.inMinutes.remainder(60)),
            body: me.ready ? l.setupDoneWaiting : l.setupExplain,
          ),
        SectionTitle(l.step1AddEmails),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.addEmailsBody(emails.length)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(emails.join(', '), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(l.copyAllEmails),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: emails.join(',')));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.copied(emails.length))));
                  },
                ),
                if (emailsDone)
                  Chip(
                    avatar: const Icon(Icons.check_circle_rounded, color: Brand.green),
                    label: Text(l.emailsConfirmed),
                  )
                else
                  FilledButton.icon(
                    icon: const Icon(Icons.done_all_rounded),
                    label: Text(l.iAddedEveryone),
                    onPressed: () async {
                      final ok = await confirm(context,
                          title: l.confirmEmailsTitle, body: l.confirmEmailsBody(emails.length), ok: l.yesAdded);
                      if (ok && context.mounted) {
                        await runAction(context, () => ref.read(apiProvider).confirmEmailsAdded(widget.group.id));
                      }
                    },
                  ),
              ]),
              const SizedBox(height: 8),
              Text(l.emailsHowTo, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ),
        SectionTitle(
          l.step2InstallApps(installed, visible.length),
          trailing: _checking
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _check, tooltip: l.checkAgain),
        ),
        if (waitingOn > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l.waitingForOwners(waitingOn), style: Theme.of(context).textTheme.bodySmall),
          ),
        for (final a in visible) ...[
          _InstallCard(app: a, installed: _local[a.uid]?.installed ?? false),
          const SizedBox(height: 8),
        ],
        if (visible.isEmpty && waitingOn == 0)
          Text(l.noAppsYet, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    );
  }
}

class _InstallCard extends StatelessWidget {
  const _InstallCard({required this.app, required this.installed});
  final Member app;
  final bool installed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AppIconView(name: app.appName, url: app.iconUrl, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(app.appName, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(l.byName(app.displayName), style: Theme.of(context).textTheme.bodySmall),
              ]),
            ),
            Icon(installed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: installed ? Brand.green : Brand.grey),
          ]),
          if (!installed) ...[
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: OutlinedButton(onPressed: () => openUrl(app.optInWebUrl), child: Text(l.joinTest)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(onPressed: () => openUrl(app.optInPlayUrl), child: Text(l.install)),
              ),
            ]),
          ],
        ]),
      ),
    );
  }
}
