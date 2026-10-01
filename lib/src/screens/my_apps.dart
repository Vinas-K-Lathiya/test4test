import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n.dart';
import '../providers.dart';
import '../widgets/common.dart';

class MyAppsTab extends ConsumerWidget {
  const MyAppsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(ref.watch(myAppsProvider), builder: (apps) {
      if (apps.isEmpty) {
        return EmptyState(
          icon: Icons.apps_rounded,
          title: l.noAppsTitle,
          body: l.noAppsBody,
          action: FilledButton(onPressed: () => context.push('/apps/new'), child: Text(l.addApp)),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final a = apps[i];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: AppIconView(name: a.name, url: a.iconUrl),
              title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(a.packageName),
              onTap: () => context.push('/apps/${a.id}'),
              trailing: PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    context.push('/apps/${a.id}');
                  } else if (v == 'delete') {
                    final ok = await confirm(context,
                        title: l.deleteAppTitle, body: l.deleteAppBody, ok: l.delete, danger: true);
                    if (ok && context.mounted) {
                      await runAction(context,
                          () => FirebaseFirestore.instance.collection('apps').doc(a.id).delete());
                    }
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(l.edit)),
                  PopupMenuItem(value: 'delete', child: Text(l.delete)),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
