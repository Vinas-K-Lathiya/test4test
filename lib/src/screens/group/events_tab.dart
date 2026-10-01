import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../l10n.dart';
import '../../models.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(ref.watch(eventsProvider(groupId)), builder: (events) {
      if (events.isEmpty) return EmptyState(icon: Icons.timeline_rounded, title: l.noActivity);
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: events.length,
        itemBuilder: (context, i) {
          final e = events[i];
          final (icon, color, text) = _describe(l, e);
          return ListTile(
            leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color, size: 20)),
            title: Text(text),
            subtitle: e.at == null ? null : Text(DateFormat.MMMd().add_jm().format(e.at!)),
          );
        },
      );
    });
  }

  (IconData, Color, String) _describe(AppLocalizations l, GroupEvent e) {
    final name = e.data['name'] as String? ?? '';
    return switch (e.type) {
      'formed' => (Icons.groups_rounded, Brand.indigo, l.evFormed((e.data['count'] as num?)?.toInt() ?? 0)),
      'joined' => (Icons.person_add_rounded, Brand.indigo, l.evJoined(name)),
      'emailsAdded' => (Icons.mark_email_read_rounded, Brand.teal, l.evEmailsAdded(name)),
      'started' => (Icons.flag_rounded, Brand.green, l.evStarted),
      'memberActive' => (Icons.check_circle_rounded, Brand.green, l.evMemberActive(name)),
      'warning' => (Icons.warning_amber_rounded, Brand.amber, l.evWarning(name)),
      'removed' => (Icons.person_remove_rounded, Brand.red, l.evRemoved(name, removedReasonLabel(l, e.data['reason'] as String?))),
      'suspended' => (Icons.gavel_rounded, Brand.amber, l.evSuspended(name)),
      'reinstated' => (Icons.restore_rounded, Brand.green, l.evReinstated(name)),
      'completed' => (Icons.emoji_events_rounded, Brand.violet, l.evCompleted),
      'cancelled' => (Icons.cancel_rounded, Brand.grey, l.evCancelled),
      _ => (Icons.circle_outlined, Brand.grey, e.type),
    };
  }
}
