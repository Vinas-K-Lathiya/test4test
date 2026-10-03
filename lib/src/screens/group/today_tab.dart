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
import '../../widgets/ui.dart';

/// Daily testing: progress, who's done, and the list of apps to open + review.
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

  void _viewMembers() {
    final c = DefaultTabController.maybeOf(context);
    if (c != null) c.animateTo(c.length - 2); // Members is always second to last.
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
    final others = widget.members.where((m) => m.uid != me.uid && m.isLive).toList();

    return RefreshIndicator(
      onRefresh: _sync,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          if (me.isLive && me.emailsAddedVersion < widget.group.rosterVersion && me.state == MemberState.active)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InfoCard(image: 'handshake', color: Brand.amber, title: l.newMembersTitle, body: l.newMembersBody),
            ),
          GradientCard(
            gradient: done ? Brand.successGradient : Brand.gradient,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                SizedBox(
                  width: 84,
                  height: 84,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: apps.isEmpty ? 0 : opened / apps.length,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                      Text('$opened/${apps.length}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        done ? l.todayDone : l.todayTitle,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        done ? l.todayDoneBody : l.todayBody(needed),
                        style: const TextStyle(color: Colors.white70, height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(l.dayResetsAt(resetText), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!_usageAccess) ...[
            const SizedBox(height: 14),
            InfoCard(
              image: 'chart',
              color: Brand.amber,
              title: l.usageAccessOffTitle,
              body: l.usageAccessOffBody,
              action: OutlinedButton(
                onPressed: () => ref.read(deviceProvider).openUsageAccessSettings(),
                child: Text(l.grantUsageAccess),
              ),
            ),
          ],
          SectionHeader(l.groupMembersCount(others.length + 1), action: l.viewAll, onAction: _viewMembers),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final m in others.take(6)) _MemberBubble(member: m),
                if (others.length > 6) _MoreBubble(count: others.length - 6, onTap: _viewMembers),
              ],
            ),
          ),
          SectionHeader(
            l.todaysTasks,
            subtitle: l.tasksCompleted(apps.length, opened),
            trailing: _syncing
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton(onPressed: _sync, icon: const Icon(Icons.refresh_rounded), tooltip: l.checkAgain),
          ),
          for (final a in apps) ...[
            _TaskCard(
              app: a,
              status: _local[a.uid],
              feedbackCount: me.feedbackTo[a.uid] ?? 0,
              onOpen: () => _open(a),
              onFeedback: () => context.push('/group/${widget.group.id}/feedback/${a.uid}'),
            ),
            const SizedBox(height: 12),
          ],
          if (apps.isEmpty) EmptyState(image: 'hourglass', title: l.noAppsYet),
        ],
      ),
    );
  }
}

class _MemberBubble extends StatelessWidget {
  const _MemberBubble({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = member.today != null && member.today!.isToday ? member.today : null;
    final (label, color) = member.state == MemberState.setup
        ? (l.stateSetup, Brand.amber)
        : t != null && t.opened >= passThreshold(t.required) && t.required > 0
        ? (l.memberDone, Brand.green)
        : t != null && t.opened > 0
        ? (l.memberTesting, Brand.indigo)
        : (l.memberPending, Brand.amber);
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Stack(
            children: [
              AppAvatar(name: member.displayName, url: member.photoUrl, size: 54),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            member.displayName.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusDot(color, size: 7),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Brand.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreBubble extends StatelessWidget {
  const _MoreBubble({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 74,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: Brand.indigo.withValues(alpha: 0.1), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '+$count',
              style: const TextStyle(color: Brand.indigo, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),
          Text(context.l10n.more, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        ],
      ),
    ),
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
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

    return SoftCard(
      padding: const EdgeInsets.all(14),
      border: opened ? Brand.green.withValues(alpha: 0.35) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconView(name: app.appName, url: app.iconUrl, size: 50),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.appName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Text(l.byName(app.displayName), style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    StatusPill(label, color: color),
                  ],
                ),
              ),
              Icon(
                opened ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: opened ? Brand.green : Brand.grey.withValues(alpha: 0.6),
                size: 28,
              ),
            ],
          ),
          if (app.testNotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Brand.amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Img3d('bulb', size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      app.testNotes,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: installed
                    ? FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 42)),
                        onPressed: onOpen,
                        child: Text(l.open),
                      )
                    : FilledButton.tonal(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 42)),
                        onPressed: () => openUrl(app.optInWebUrl),
                        child: Text(l.joinTest),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
                  onPressed: onFeedback,
                  child: Text(feedbackCount > 0 ? l.feedbackGivenCount(feedbackCount) : l.giveFeedback),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
