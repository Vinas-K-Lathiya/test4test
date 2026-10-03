import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import '../../widgets/ui.dart';
import 'report_sheet.dart';

class MembersTab extends ConsumerWidget {
  const MembersTab({super.key, required this.group, required this.members});
  final Group group;
  final List<Member> members;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(uidProvider);
    final live = members.where((m) => m.isLive || m.state == MemberState.completed).toList();
    final gone = members.where((m) => !(m.isLive || m.state == MemberState.completed)).toList();
    final greens = live.where((m) => memberColor(m) == Brand.green).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(label: l.statMembers, value: '${live.length}', image: 'people'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(label: l.statOnTrack, value: '$greens', image: 'check', color: Brand.green),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(label: l.statRemoved, value: '${gone.length}', image: 'noentry'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(l.membersLegend, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final m in [...live, ...gone]) ...[
          _MemberTile(member: m, isMe: m.uid == uid, group: group, members: members),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({required this.member, required this.isMe, required this.group, required this.members});
  final Member member;
  final bool isMe;
  final Group group;
  final List<Member> members;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = member;
    final t = m.today != null && m.today!.isToday ? m.today : null;
    final total = visibleAppsFor(members, m.uid).length;
    final String subtitle;
    if (!m.isLive) {
      subtitle = memberStateLabel(l, m.state);
    } else if (m.state == MemberState.setup) {
      subtitle = l.memberSetupLine(m.emailsAdded ? '✓' : '✗', t?.installed ?? 0, total);
    } else {
      subtitle = l.memberActiveLine(t?.installed ?? 0, t?.opened ?? 0, total, m.feedbackGiven);
    }

    return SoftCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            AppAvatar(name: m.displayName, url: m.photoUrl, size: 46),
            Positioned(right: -1, bottom: -1, child: StatusDot(memberColor(m), size: 13)),
          ],
        ),
        title: Text(
          isMe ? '${m.displayName} (${l.you})' : m.displayName,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${m.appName} · $subtitle'),
            if (m.consecutiveMissed > 0 && m.isLive)
              Text(l.missedInARow(m.consecutiveMissed), style: const TextStyle(color: Brand.red)),
          ],
        ),
        trailing: TrustChip(level: levelForScore(m.trustScore), score: m.trustScore, dense: true),
        onTap: () => _showSheet(context, ref),
      ),
    );
  }

  void _showSheet(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final me = members.where((x) => x.uid == ref.read(uidProvider)).firstOrNull;
    final canReport = !isMe && member.isLive && (me?.isLive ?? false);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: AppAvatar(name: member.displayName, url: member.photoUrl),
              title: Text(member.displayName),
              subtitle: Text(member.email),
            ),
            if (member.lastDays.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text(l.lastDays, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    for (final d in member.lastDays)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Tooltip(
                          message: '${d.day}: ${d.opened}/${d.required}',
                          child: StatusDot(d.ok ? Brand.green : Brand.red, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ListTile(
              leading: const Icon(Icons.person_search_rounded),
              title: Text(l.viewProfile),
              onTap: () {
                Navigator.pop(c);
                context.push('/profile/${member.uid}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop_rounded),
              title: Text(l.openInPlay),
              onTap: () => openUrl(member.optInPlayUrl),
            ),
            if (canReport)
              ListTile(
                leading: const Icon(Icons.flag_rounded, color: Brand.red),
                title: Text(l.reportMember, style: const TextStyle(color: Brand.red)),
                onTap: () {
                  Navigator.pop(c);
                  showReportSheet(context, groupId: group.id, target: member);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
