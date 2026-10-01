import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'events_tab.dart';
import 'members_tab.dart';
import 'setup_tab.dart';
import 'today_tab.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(uidProvider);
    final groupV = ref.watch(groupProvider(groupId));
    final membersV = ref.watch(membersProvider(groupId));

    return groupV.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text(friendlyError(context, e)))),
      data: (group) {
        if (group == null) return Scaffold(appBar: AppBar(), body: Center(child: Text(l.errGeneric)));
        final members = membersV.value ?? const <Member>[];
        final me = members.where((m) => m.uid == uid).firstOrNull;
        final needsSetup = me != null &&
            me.isLive &&
            (me.state == MemberState.setup || me.emailsAddedVersion < group.rosterVersion);
        final showToday = group.status == GroupStatus.active || group.status == GroupStatus.completed;

        final tabs = <(String, Widget)>[
          if (showToday) (l.tabToday, TodayTab(group: group, members: members)),
          if (needsSetup || group.status == GroupStatus.setup) (l.tabSetup, SetupTab(group: group, members: members)),
          (l.tabMembers, MembersTab(group: group, members: members)),
          (l.tabActivity, EventsTab(groupId: groupId)),
        ];

        final subtitle = switch (group.status) {
          GroupStatus.active => l.dayOf(group.dayIndex.clamp(1, group.testDays), group.testDays),
          _ => groupStatusLabel(l, group.status),
        };

        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.groupTitle(group.shortId)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ]),
              actions: [
                if (me != null && me.isLive)
                  PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v != 'leave') return;
                      final ok = await confirm(context,
                          title: l.leaveGroupTitle, body: l.leaveGroupBody, ok: l.leave, danger: true);
                      if (ok && context.mounted) {
                        final done = await runAction(context, () => ref.read(apiProvider).leaveGroup(groupId));
                        if (done && context.mounted) context.pop();
                      }
                    },
                    itemBuilder: (_) => [PopupMenuItem(value: 'leave', child: Text(l.leaveGroup))],
                  ),
              ],
              bottom: TabBar(isScrollable: tabs.length > 3, tabs: [for (final t in tabs) Tab(text: t.$1)]),
            ),
            body: Column(children: [
              if (me != null && !me.isLive) _StateBanner(me: me),
              Expanded(child: TabBarView(children: [for (final t in tabs) t.$2])),
            ]),
          ),
        );
      },
    );
  }
}

class _StateBanner extends StatelessWidget {
  const _StateBanner({required this.me});
  final Member me;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (color, text) = switch (me.state) {
      MemberState.suspended => (Brand.amber, l.suspendedBody),
      MemberState.removed => (Brand.red, l.youWereRemoved(removedReasonLabel(l, me.removedReason))),
      MemberState.completed => (Brand.green, l.youCompleted),
      _ => (Brand.grey, ''),
    };
    return Material(
      color: color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        child: Row(children: [
          Expanded(child: Text(text)),
          if (me.state == MemberState.removed || me.state == MemberState.suspended)
            TextButton(onPressed: () => context.push('/appeal'), child: Text(l.appeal)),
        ]),
      ),
    );
  }
}
