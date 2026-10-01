import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../services/activity_sync.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Daily testing checklist: open every assigned app, see live verification, leave feedback.
class TodayTab extends ConsumerStatefulWidget {
  const TodayTab({super.key, required this.group, required this.members});
  final Group group;
  final List<Member> members;
  @override
  ConsumerState<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends ConsumerState<TodayTab> with WidgetsBindingObserver {
  Map<String, LocalAppStatus> _local = {};
  bool _usageAccess = true;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coming back from a tested app: refresh so the tick appears right away.
    if (state == AppLifecycleState.resumed) _sync();
  }

  Member? get _me => widget.members.where((m) => m.uid == ref.read(uidProvider)).firstOrNull;

  Future<void> _sync() async {
    final me = _me;
    if (me == null || !me.isLive || _syncing) return;
    setState(() => _syncing = true);
    try {
      final r = await ref.read(activitySyncProvider).sync(widget.group.id, visibleAppsFor(widget.members, me.uid));
      if (mounted) {
        setState(() {
          _local = r.byOwner;
          _usageAccess = r.usageAccess;
        });
      }
    } catch (_) {
      // keep last values
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Future<void> _open(Member app) async {
    await ActivitySync.recordOpen(app.packageName);
    final launched = await ref.read(deviceProvider).launch(app.packageName);
    if (!launched) await openUrl(app.optInPlayUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = _me;
    if (me == null) return const SizedBox.shrink();
    final apps = visibleAppsFor(widget.members, me.uid);
    final opened = apps.where((a) => _local[a.uid]?.opened ?? false).length;
    final needed = passThreshold(apps.length);
    final done = apps.isNotEmpty && opened >= needed;
    final resetAt = utcMidnight().add(const Duration(days: 1)).toLocal();
    final resetText = TimeOfDay.fromDateTime(resetAt).format(context);

    return RefreshIndicator(
      onRefresh: _sync,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 32), children: [
        if (me.isLive && me.emailsAddedVersion < widget.group.rosterVersion && me.state == MemberState.active)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoCard(
              icon: Icons.person_add_alt_1_rounded,
              color: Brand.amber,
              title: l.newMembersTitle,
              body: l.newMembersBody,
            ),
          ),
        _ProgressHeader(opened: opened, total: apps.length, needed: needed, done: done, resetText: resetText, syncing: _syncing),
        if (!_usageAccess) ...[
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.query_stats_rounded,
            color: Brand.amber,
            title: l.usageAccessOffTitle,
            body: l.usageAccessOffBody,
            action: OutlinedButton(
              onPressed: () => ref.read(deviceProvider).openUsageAccessSettings(),
              child: Text(l.grantUsageAccess),
            ),
          ),
        ],
        SectionTitle(l.yourTestList),
        for (final a in apps) ...[
          _AppTile(
            app: a,
            status: _local[a.uid],
            feedbackCount: me.feedbackTo[a.uid] ?? 0,
            onOpen: () => _open(a),
            onFeedback: () => context.push('/group/${widget.group.id}/feedback/${a.uid}'),
          ),
          const SizedBox(height: 8),
        ],
        if (apps.isEmpty) EmptyState(icon: Icons.hourglass_empty_rounded, title: l.noAppsYet),
      ]),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.opened,
    required this.total,
    required this.needed,
    required this.done,
    required this.resetText,
    required this.syncing,
  });
  final int opened, total, needed;
  final bool done, syncing;
  final String resetText;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: done
            ? const LinearGradient(colors: [Brand.teal, Brand.green])
            : Brand.gradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(
              value: total == 0 ? 0 : opened / total,
              strokeWidth: 7,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
            Text('$opened/$total', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(done ? l.todayDone : l.todayTitle,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 4),
            Text(done ? l.todayDoneBody : l.todayBody(needed),
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(l.dayResetsAt(resetText), style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        if (syncing)
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
      ]),
    );
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.app,
    required this.status,
    required this.feedbackCount,
    required this.onOpen,
    required this.onFeedback,
  });
  final Member app;
  final LocalAppStatus? status;
  final int feedbackCount;
  final VoidCallback onOpen;
  final VoidCallback onFeedback;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final installed = status?.installed ?? false;
    final opened = status?.opened ?? false;
    final (color, label) = !installed
        ? (Brand.red, l.notInstalled)
        : opened
            ? (Brand.green, l.openedMinutes(status!.minutes))
            : (Brand.amber, l.notOpenedYet);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AppIconView(name: app.appName, url: app.iconUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(app.appName, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Row(children: [
                  StatusDot(color),
                  const SizedBox(width: 6),
                  Flexible(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
                ]),
              ]),
            ),
          ]),
          if (app.testNotes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('💡 ${app.testNotes}', style: Theme.of(context).textTheme.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: installed
                  ? FilledButton.icon(onPressed: onOpen, icon: const Icon(Icons.open_in_new_rounded), label: Text(l.open))
                  : FilledButton.tonal(onPressed: () => openUrl(app.optInWebUrl), child: Text(l.joinTest)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onFeedback,
                icon: Icon(feedbackCount > 0 ? Icons.check_rounded : Icons.rate_review_outlined),
                label: Text(feedbackCount > 0 ? l.feedbackGivenCount(feedbackCount) : l.giveFeedback),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
