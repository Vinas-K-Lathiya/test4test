import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../config.dart';
import '../l10n.dart';
import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/labels.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final account = ref.watch(accountProvider).value;
    final profile = ref.watch(myProfileProvider).value;
    final queue = ref.watch(queueEntryProvider).value;
    final apps = ref.watch(myAppsProvider).value ?? const [];
    if (account == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        if (profile != null) _Greeting(profile: profile),
        const SizedBox(height: 12),
        if (account.banned)
          InfoCard(
            icon: Icons.block_rounded,
            color: Brand.red,
            title: l.bannedTitle,
            body: l.bannedBody(account.strikes),
            action: FilledButton.tonal(onPressed: () => context.push('/appeal'), child: Text(l.appeal)),
          )
        else if (account.currentGroupId != null)
          _CurrentGroupCard(groupId: account.currentGroupId!)
        else if (queue != null)
          _QueueCard(entry: queue, appName: apps.where((a) => a.id == queue.appId).firstOrNull?.name ?? '')
        else
          _JoinCard(hasApps: apps.isNotEmpty),
        if (account.strikes > 0 && !account.banned) ...[
          const SizedBox(height: 12),
          InfoCard(
            icon: Icons.warning_amber_rounded,
            color: Brand.amber,
            title: l.strikesTitle(account.strikes),
            body: l.strikesBody,
            action: TextButton(onPressed: () => context.push('/appeal'), child: Text(l.appeal)),
          ),
        ],
        SectionTitle(l.howItWorks),
        _Steps(),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.info_outline_rounded,
          color: Brand.teal,
          title: l.googleRuleTitle,
          body: l.googleRuleBody,
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});
  final Profile profile;
  @override
  Widget build(BuildContext context) => Row(children: [
        AppAvatar(name: profile.displayName, url: profile.photoUrl, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.l10n.hello(profile.displayName.split(' ').first),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            TrustChip(level: profile.level, score: profile.trustScore),
          ]),
        ),
      ]);
}

class _JoinCard extends StatelessWidget {
  const _JoinCard({required this.hasApps});
  final bool hasApps;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: Brand.gradient, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 32),
        const SizedBox(height: 12),
        Text(l.joinCardTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(hasApps ? l.joinCardBody : l.joinCardNoApps, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Brand.indigo),
          onPressed: () => context.push(hasApps ? '/join' : '/apps/new'),
          child: Text(hasApps ? l.joinGroup : l.addYourApp),
        ),
      ]),
    );
  }
}

class _QueueCard extends ConsumerWidget {
  const _QueueCard({required this.entry, required this.appName});
  final QueueEntry entry;
  final String appName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final stats = ref.watch(queueStatsProvider).value ?? const {};
    final waiting = stats[entry.tier] ?? 0;
    final joined = entry.joinedAt == null ? '' : DateFormat.MMMd().add_jm().format(entry.joinedAt!);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(l.inQueueTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 12),
          Text(l.inQueueBody(appName, entry.tier == 'trusted' ? l.tierTrusted : l.tierStarter)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (waiting / AppConfig.groupSize).clamp(0, 1).toDouble(),
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(l.queueWaiting(waiting, AppConfig.groupSize), style: Theme.of(context).textTheme.bodySmall),
          if (joined.isNotEmpty) Text(l.queueJoinedAt(joined), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => runAction(context, () => ref.read(apiProvider).leaveQueue()),
            child: Text(l.leaveQueue),
          ),
        ]),
      ),
    );
  }
}

class _CurrentGroupCard extends ConsumerWidget {
  const _CurrentGroupCard({required this.groupId});
  final String groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(uidProvider);
    final group = ref.watch(groupProvider(groupId)).value;
    final members = ref.watch(membersProvider(groupId)).value ?? const [];
    final me = members.where((m) => m.uid == uid).firstOrNull;
    if (group == null || me == null) return const Card(child: SizedBox(height: 120));

    final t = me.today;
    final today = t != null && t.isToday ? t : null;
    final visible = visibleAppsFor(members, me.uid).length;
    final opened = today?.opened ?? 0;
    final status = group.status == GroupStatus.active
        ? l.dayOf(group.dayIndex.clamp(1, group.testDays), group.testDays)
        : groupStatusLabel(l, group.status);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.push('/group/$groupId'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: Brand.gradient, borderRadius: BorderRadius.circular(22)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(l.groupTitle(group.shortId),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(99)),
              child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 16),
          if (group.status == GroupStatus.active && me.state == MemberState.active) ...[
            Text(l.openedToday(opened, visible), style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: visible == 0 ? 1 : (opened / visible).clamp(0, 1).toDouble(),
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ] else if (me.state == MemberState.setup)
            Text(me.ready ? l.setupDoneWaiting : l.setupTodo, style: const TextStyle(color: Colors.white))
          else if (me.state == MemberState.suspended)
            Text(l.suspendedBody, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          Row(children: [
            Text(l.openGroup, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ]),
        ]),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = <(IconData, String, String)>[
      (Icons.add_box_rounded, l.step1Title, l.step1Body),
      (Icons.groups_rounded, l.step2Title, l.step2Body),
      (Icons.playlist_add_check_rounded, l.step3Title, l.step3Body),
      (Icons.today_rounded, l.step4Title, l.step4Body),
      (Icons.emoji_events_rounded, l.step5Title, l.step5Body),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          for (var i = 0; i < steps.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(steps[i].$1, size: 20),
              ),
              title: Text('${i + 1}. ${steps[i].$2}', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(steps[i].$3),
            ),
        ]),
      ),
    );
  }
}
