import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../l10n.dart';
import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/labels.dart';

/// Admin tools: review suspended members, resolve appeals, find/ban users, adjust trust.
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (!ref.watch(isAdminProvider)) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l.errGeneric)),
      );
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.admin),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l.adminReviews),
              Tab(text: l.adminAppeals),
              Tab(text: l.adminUsers),
              const Tab(text: 'Test'),
            ],
          ),
        ),
        body: const TabBarView(children: [_Reviews(), _Appeals(), _Users(), _TestTools()]),
      ),
    );
  }
}

Future<String?> _askNote(BuildContext context, String title) {
  final c = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (d) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: c,
        maxLines: 3,
        decoration: InputDecoration(hintText: context.l10n.noteOptional),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d), child: Text(context.l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: Text(context.l10n.confirmAction)),
      ],
    ),
  );
}

class _Reviews extends ConsumerWidget {
  const _Reviews();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(
      ref.watch(openReviewsProvider),
      builder: (items) {
        if (items.isEmpty) return EmptyState(image: 'party', title: l.nothingToReview);
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _ReviewCard(review: items[i]),
        );
      },
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final r = review;
    final reports = ref.watch(reportsByIdsProvider(r.reportIds.join(','))).value ?? const [];
    final lastDays = (r.data['lastDays'] as List? ?? const []).cast<Map>();
    final counts = <String, int>{};
    for (final x in r.reasons) {
      counts[x] = (counts[x] ?? 0) + 1;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.targetName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text(
              '${r.targetEmail} · ${l.groupTitle(r.groupId.substring(0, 5).toUpperCase())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final e in counts.entries) Chip(label: Text('${reportReasonLabel(l, e.key)} ×${e.value}')),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.dataSummary((r.data['activeDays'] as num?)?.toInt() ?? 0, (r.data['missedDays'] as num?)?.toInt() ?? 0),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                for (final d in lastDays)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Tooltip(
                      message: '${d['day']}: ${d['opened']}/${d['required']}',
                      child: StatusDot(d['ok'] == true ? Brand.green : Brand.red, size: 14),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            for (final rep in reports)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '• ${rep['reporterName']}: ${reportReasonLabel(l, rep['reason'] as String? ?? '')}'
                  '${(rep['details'] as String? ?? '').isEmpty ? '' : ' — ${rep['details']}'}',
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final note = await _askNote(context, l.rejectReports);
                      if (note != null && context.mounted) {
                        await runAction(context, () => ref.read(apiProvider).resolveReview(r.id, 'reject', note));
                      }
                    },
                    child: Text(l.rejectReports),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Brand.red),
                    onPressed: () async {
                      final note = await _askNote(context, l.confirmKick);
                      if (note != null && context.mounted) {
                        await runAction(context, () => ref.read(apiProvider).resolveReview(r.id, 'confirm', note));
                      }
                    },
                    child: Text(l.confirmKick),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Appeals extends ConsumerWidget {
  const _Appeals();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(
      ref.watch(openAppealsProvider),
      builder: (items) {
        if (items.isEmpty) return EmptyState(image: 'inbox', title: l.nothingToReview);
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final a = items[i];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.email, style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (a.createdAt != null)
                      Text(
                        DateFormat.yMMMd().add_jm().format(a.createdAt!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    Text(a.text),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final note = await _askNote(context, l.reject);
                              if (note != null && context.mounted) {
                                await runAction(
                                  context,
                                  () => ref.read(apiProvider).resolveAppeal(a.id, 'reject', note),
                                );
                              }
                            },
                            child: Text(l.reject),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final note = await _askNote(context, l.accept);
                              if (note != null && context.mounted) {
                                await runAction(
                                  context,
                                  () => ref.read(apiProvider).resolveAppeal(a.id, 'accept', note),
                                );
                              }
                            },
                            child: Text(l.accept),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Users extends ConsumerStatefulWidget {
  const _Users();
  @override
  ConsumerState<_Users> createState() => _UsersState();
}

class _UsersState extends ConsumerState<_Users> {
  final _email = TextEditingController();
  Map<String, dynamic>? _user;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    await runAction(context, () async {
      final r = await ref.read(apiProvider).findUser(_email.text.trim());
      setState(() => _user = r);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final u = _user;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l.searchByEmail,
            suffixIcon: IconButton(icon: const Icon(Icons.search_rounded), onPressed: _search),
          ),
          onSubmitted: (_) => _search(),
        ),
        const SizedBox(height: 16),
        if (u != null && u['found'] != true) Text(l.userNotFound),
        if (u != null && u['found'] == true)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${u['displayName']}', style: Theme.of(context).textTheme.titleMedium),
                  Text('${u['email']}'),
                  const SizedBox(height: 8),
                  Text(
                    l.userSummary(
                      (u['trustScore'] as num?)?.toInt() ?? 0,
                      (u['strikes'] as num?)?.toInt() ?? 0,
                      u['banned'] == true ? l.yes : l.no,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () async {
                          final banned = u['banned'] != true;
                          final ok = await runAction(
                            context,
                            () => ref.read(apiProvider).setBan(u['uid'] as String, banned),
                          );
                          if (ok) setState(() => _user = {...u, 'banned': banned});
                        },
                        child: Text(u['banned'] == true ? l.unban : l.ban),
                      ),
                      for (final d in [-10, 10])
                        OutlinedButton(
                          onPressed: () async {
                            final note = await _askNote(context, l.adjustTrust);
                            if (note != null && context.mounted) {
                              await runAction(
                                context,
                                () => ref
                                    .read(apiProvider)
                                    .adjustTrust(u['uid'] as String, d, note.isEmpty ? 'manual' : note),
                                success: l.saved,
                              );
                            }
                          },
                          child: Text(d > 0 ? '+$d' : '$d'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Admin-only: walk through a whole group alone using stand-in test members.
class _TestTools extends ConsumerWidget {
  const _TestTools();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.read(apiProvider);
    final groupId = ref.watch(accountProvider).value?.currentGroupId;
    final group = groupId == null ? null : ref.watch(groupProvider(groupId)).value;
    final isTest = group != null && groupId != null;

    Future<void> run(String action, {int? days, bool? miss, String? done}) async {
      Map<String, dynamic>? r;
      final ok = await runAction(context, () async {
        r = await api.testTools(action, groupId: groupId, days: days, miss: miss);
      });
      if (!ok || !context.mounted) return;
      final msg = done ?? (r?['status'] != null ? 'Group is now ${r!['status']}, day ${r!['dayIndex']}' : 'Done');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (action == 'seed' && r?['groupId'] != null) context.push('/group/${r!['groupId']}');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoCard(
          image: 'hammer',
          title: 'Test the full flow alone',
          body:
              'Creates a group with you + 13 test members whose "apps" are Google apps already on most phones '
              '(YouTube, Chrome, Gmail, Maps…). Install checks and usage tracking work for real. '
              'Your real trust score and stats are restored when you delete the test group.',
        ),
        const SizedBox(height: 16),
        if (groupId == null) ...[
          const Text('Step 1: you need one app in "My apps". Then:'),
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.group_add_rounded),
            label: const Text('Create test group'),
            onPressed: () => run('seed', done: 'Test group created'),
          ),
        ] else ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.groups_rounded),
              title: Text('Group #${group?.shortId ?? ''}'),
              subtitle: Text(
                group == null
                    ? ''
                    : group.status == GroupStatus.active
                    ? 'Testing · day ${group.dayIndex} of ${group.testDays}'
                    : group.status.name,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/group/$groupId'),
            ),
          ),
          const SizedBox(height: 12),
          if (group?.status == GroupStatus.setup) ...[
            const Text(
              'Do the Setup tab yourself (copy emails → "I added everyone", install apps). '
              'The test starts automatically when you are ready, or:',
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => run('forceStart', done: 'Test started'),
              child: const Text('Skip setup & start now'),
            ),
          ],
          if (group?.status == GroupStatus.active) ...[
            const Text(
              'Open some apps from the Today tab, then advance. Each advance scores today\'s activity '
              'as one day (+1 trust if ≥90% opened, otherwise a warning).',
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: () => run('advance', days: 1), child: const Text('Advance 1 day')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => run('advance', days: 1, miss: true),
              child: const Text('Advance 1 day as a MISSED day (test warnings / kick)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => run('advance', days: 17),
              child: const Text('Jump to the end (complete the group)'),
            ),
          ],
          const SizedBox(height: 24),
          if (isTest)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Brand.red),
              icon: const Icon(Icons.delete_forever_rounded),
              label: const Text('Delete test group & restore my profile'),
              onPressed: () => run('cleanup', done: 'Test group deleted'),
            ),
        ],
      ],
    );
  }
}
