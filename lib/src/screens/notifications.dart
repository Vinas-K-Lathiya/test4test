import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../l10n.dart';
import '../providers.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/labels.dart';
import '../widgets/ui.dart';

/// In-app inbox of every notification the server sent (pushes can be missed or dismissed).
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  CollectionReference<Map<String, dynamic>> _inbox(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('inbox');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final uid = ref.watch(uidProvider);
    final unread = ref.watch(unreadCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsInbox),
        actions: [
          if (unread > 0 && uid != null)
            TextButton(
              onPressed: () async {
                final items = ref.read(inboxProvider).value ?? const [];
                final batch = FirebaseFirestore.instance.batch();
                for (final i in items.where((i) => !i.read)) {
                  batch.update(_inbox(uid).doc(i.id), {'read': true});
                }
                await batch.commit();
              },
              child: Text(l.markAllRead),
            ),
        ],
      ),
      body: AsyncView(
        ref.watch(inboxProvider),
        builder: (items) {
          if (items.isEmpty) {
            return EmptyState(image: 'bell', title: l.noNotifications, body: l.noNotificationsBody);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final n = items[i];
              final (_, color) = _style(n.key);
              return Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Brand.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Brand.red),
                ),
                onDismissed: (_) => _inbox(uid!).doc(n.id).delete(),
                child: SoftCard(
                  padding: EdgeInsets.zero,
                  color: n.read
                      ? null
                      : Color.alphaBlend(
                          Brand.indigo.withValues(alpha: 0.06),
                          Theme.of(context).cardTheme.color ?? Colors.white,
                        ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    leading: ImgTile(notificationImage(n.key), size: 48, color: color),
                    title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.w800)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(n.body),
                        if (n.at != null) ...[
                          const SizedBox(height: 4),
                          Text(_when(context, n.at!), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ],
                    ),
                    trailing: n.read ? null : const StatusDot(Brand.indigo),
                    onTap: () {
                      if (!n.read) _inbox(uid!).doc(n.id).update({'read': true});
                      if (n.groupId != null) context.push('/group/${n.groupId}');
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _when(BuildContext context, DateTime at) {
    final diff = DateTime.now().difference(at);
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (diff.inDays == 0) return DateFormat.jm(locale).format(at);
    return DateFormat.MMMd(locale).add_jm().format(at);
  }

  (IconData, Color) _style(String key) => switch (key) {
    'warning1' || 'warning2' || 'setupReminder' => (Icons.warning_amber_rounded, Brand.amber),
    'kicked' || 'setupFailed' || 'suspended' || 'groupCancelled' => (Icons.error_outline_rounded, Brand.red),
    'completed' => (Icons.emoji_events_rounded, Brand.violet),
    'newFeedback' => (Icons.rate_review_rounded, Brand.teal),
    'dailyReminder' => (Icons.alarm_rounded, Brand.indigo),
    'reinstated' || 'testStarted' => (Icons.check_circle_rounded, Brand.green),
    _ => (Icons.groups_rounded, Brand.indigo),
  };
}
