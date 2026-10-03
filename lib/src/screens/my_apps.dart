import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n.dart';
import '../models.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/ui.dart';

enum _AppState { testing, queued, ready }

class MyAppsTab extends ConsumerStatefulWidget {
  const MyAppsTab({super.key});
  @override
  ConsumerState<MyAppsTab> createState() => _MyAppsTabState();
}

class _MyAppsTabState extends ConsumerState<MyAppsTab> {
  _AppState? _filter;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final uid = ref.watch(uidProvider);
    final account = ref.watch(accountProvider).value;
    final queue = ref.watch(queueEntryProvider).value;
    final groupId = account?.currentGroupId;
    final members = groupId == null ? const <Member>[] : ref.watch(membersProvider(groupId)).value ?? const [];
    final testingAppId = members.where((m) => m.uid == uid).firstOrNull?.appId;

    _AppState stateOf(AppListing a) => a.id == testingAppId
        ? _AppState.testing
        : a.id == queue?.appId
        ? _AppState.queued
        : _AppState.ready;

    return AsyncView(
      ref.watch(myAppsProvider),
      builder: (apps) {
        if (apps.isEmpty) {
          return EmptyState(
            image: 'package',
            title: l.noAppsTitle,
            body: l.noAppsBody,
            action: FilledButton.icon(
              onPressed: () => context.push('/apps/new'),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.addApp),
            ),
          );
        }
        final count = {for (final s in _AppState.values) s: apps.where((a) => stateOf(a) == s).length};
        final shown = _filter == null ? apps : apps.where((a) => stateOf(a) == _filter).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip('${l.filterAll} (${apps.length})', _filter == null, () => setState(() => _filter = null)),
                  _chip(
                    '${l.statusTesting} (${count[_AppState.testing]})',
                    _filter == _AppState.testing,
                    () => setState(() => _filter = _AppState.testing),
                  ),
                  _chip(
                    '${l.inQueueShort} (${count[_AppState.queued]})',
                    _filter == _AppState.queued,
                    () => setState(() => _filter = _AppState.queued),
                  ),
                  _chip(
                    '${l.statusReady} (${count[_AppState.ready]})',
                    _filter == _AppState.ready,
                    () => setState(() => _filter = _AppState.ready),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (final a in shown) ...[_AppCard(app: a, state: stateOf(a)), const SizedBox(height: 12)],
          ],
        );
      },
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
  );
}

class _AppCard extends StatelessWidget {
  const _AppCard({required this.app, required this.state});
  final AppListing app;
  final _AppState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, color) = switch (state) {
      _AppState.testing => (l.statusTesting, Brand.green),
      _AppState.queued => (l.inQueueShort, Brand.amber),
      _AppState.ready => (l.statusReady, Brand.indigo),
    };
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 4, 14),
      onTap: () => context.push('/apps/${app.id}'),
      child: Row(
        children: [
          AppIconView(name: app.name, url: app.iconUrl, size: 54),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  app.packageName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                StatusPill(label, color: color),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (v) async {
              if (v == 'edit') {
                context.push('/apps/${app.id}');
              } else if (v == 'delete') {
                final ok = await confirm(
                  context,
                  title: l.deleteAppTitle,
                  body: l.deleteAppBody,
                  ok: l.delete,
                  danger: true,
                );
                if (ok && context.mounted) {
                  await runAction(context, () => FirebaseFirestore.instance.collection('apps').doc(app.id).delete());
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(l.edit)),
              PopupMenuItem(value: 'delete', child: Text(l.delete)),
            ],
          ),
        ],
      ),
    );
  }
}
