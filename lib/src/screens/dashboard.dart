import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../ads/ad_widgets.dart';
import '../config.dart';
import '../l10n.dart';
import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/labels.dart';
import '../widgets/ui.dart';

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
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        if (profile != null) _Greeting(profile: profile),
        const SizedBox(height: 18),
        if (account.banned)
          InfoCard(
            image: 'noentry',
            color: Brand.red,
            title: l.bannedTitle,
            body: l.bannedBody(account.strikes),
            action: FilledButton(onPressed: () => context.push('/appeal'), child: Text(l.appeal)),
          )
        else if (account.currentGroupId != null)
          _CurrentGroupCard(groupId: account.currentGroupId!)
        else if (queue != null)
          _QueueCard(entry: queue, appName: apps.where((a) => a.id == queue.appId).firstOrNull?.name ?? '')
        else
          _JoinCard(hasApps: apps.isNotEmpty),
        if (account.strikes > 0 && !account.banned) ...[
          const SizedBox(height: 14),
          InfoCard(
            image: 'warning',
            color: Brand.amber,
            title: l.strikesTitle(account.strikes),
            body: l.strikesBody,
            action: TextButton(onPressed: () => context.push('/appeal'), child: Text(l.appeal)),
          ),
        ],
        const NativeAdCard(padding: EdgeInsets.only(top: 18)),
        SectionHeader(l.howItWorks),
        ..._steps(l).indexed.expand(
          (e) => [StepRow(number: e.$1 + 1, image: e.$2.$1, title: e.$2.$2, body: e.$2.$3), const SizedBox(height: 10)],
        ),
        const SizedBox(height: 6),
        InfoCard(image: 'shield', color: Brand.teal, title: l.googleRuleTitle, body: l.googleRuleBody),
      ],
    );
  }

  List<(String, String, String)> _steps(AppLocalizations l) => [
    ('memo', l.step1Title, l.step1Body),
    ('people', l.step2Title, l.step2Body),
    ('clipboard', l.step3Title, l.step3Body),
    ('calendar', l.step4Title, l.step4Body),
    ('trophy', l.step5Title, l.step5Body),
  ];
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});
  final Profile profile;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Brand.gradient),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: AppAvatar(name: profile.displayName, url: profile.photoUrl, size: 56),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Brand.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      l.hello(profile.displayName.split(' ').first).replaceAll('👋', '').trim(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Img3d('wave', size: 28),
                ],
              ),
              Text(l.welcomeBack, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Brand.muted)),
              const SizedBox(height: 6),
              TrustChip(level: profile.level, score: profile.trustScore),
            ],
          ),
        ),
      ],
    );
  }
}

class _JoinCard extends StatelessWidget {
  const _JoinCard({required this.hasApps});
  final bool hasApps;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GradientCard(
      image: hasApps ? 'rocket' : 'phone',
      imageSize: 104,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.joinCardTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 8),
          Text(
            hasApps ? l.joinCardBody : l.joinCardNoApps,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          OnGradientButton(
            icon: hasApps ? Icons.group_add_rounded : Icons.add_rounded,
            label: hasApps ? l.joinGroup : l.addYourApp,
            onPressed: () => context.push(hasApps ? '/join' : '/apps/new'),
          ),
        ],
      ),
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
    return GradientCard(
      image: 'hourglass',
      imageSize: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.inQueueTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            l.inQueueBody(appName, entry.tier == 'trusted' ? l.tierTrusted : l.tierStarter),
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: (waiting / AppConfig.groupSize).clamp(0, 1).toDouble(),
            borderRadius: BorderRadius.circular(8),
            minHeight: 8,
            color: Colors.white,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 8),
          Text(
            l.queueWaiting(waiting, AppConfig.groupSize),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          if (joined.isNotEmpty)
            Text(l.queueJoinedAt(joined), style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          OnGradientButton(
            icon: Icons.logout_rounded,
            label: l.leaveQueue,
            onPressed: () => runAction(context, () => ref.read(apiProvider).leaveQueue()),
          ),
        ],
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
    if (group == null || me == null) {
      return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
    }

    final t = me.today;
    final today = t != null && t.isToday ? t : null;
    final visible = visibleAppsFor(members, me.uid).length;
    final opened = today?.opened ?? 0;
    final active = group.status == GroupStatus.active && me.state == MemberState.active;
    final status = group.status == GroupStatus.active
        ? l.dayOf(group.dayIndex.clamp(1, group.testDays), group.testDays)
        : groupStatusLabel(l, group.status);

    final String body;
    if (active) {
      body = l.openedToday(opened, visible);
    } else if (me.state == MemberState.setup) {
      body = me.ready ? l.setupDoneWaiting : l.setupTodo;
    } else if (me.state == MemberState.suspended) {
      body = l.suspendedBody;
    } else {
      body = status;
    }

    return GradientCard(
      image: active ? 'calendar' : (me.state == MemberState.setup ? 'clipboard' : 'people'),
      imageSize: 92,
      onTap: () => context.push('/group/$groupId'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(99)),
            child: Text(status, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          ),
          const SizedBox(height: 10),
          Text(l.groupTitle(group.shortId), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: Colors.white, height: 1.35)),
          if (active) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: visible == 0 ? 1 : (opened / visible).clamp(0, 1).toDouble(),
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
          const SizedBox(height: 16),
          OnGradientButton(label: l.openGroup, onPressed: () => context.push('/group/$groupId')),
        ],
      ),
    );
  }
}
