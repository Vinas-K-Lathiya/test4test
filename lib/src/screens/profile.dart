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

class MyProfileTab extends ConsumerWidget {
  const MyProfileTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(ref.watch(myProfileProvider), builder: (p) {
      if (p == null) return const SizedBox.shrink();
      final log = ref.watch(trustLogProvider).value ?? const [];
      final groups = ref.watch(myGroupsProvider).value ?? const [];
      return ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 32), children: [
        ProfileHeader(profile: p),
        SectionTitle(l.groupHistory),
        if (groups.isEmpty) Text(l.noGroupsYet, style: Theme.of(context).textTheme.bodyMedium),
        for (final g in groups)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.groups_rounded),
              title: Text(l.groupTitle(g.shortId)),
              subtitle: Text([
                groupStatusLabel(l, g.status),
                if (g.createdAt != null) DateFormat.yMMMd().format(g.createdAt!),
              ].join(' · ')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/group/${g.id}'),
            ),
          ),
        SectionTitle(l.trustHistory),
        if (log.isEmpty) Text(l.noTrustHistory, style: Theme.of(context).textTheme.bodyMedium),
        Card(
          child: Column(children: [
            for (final e in log.take(30))
              ListTile(
                dense: true,
                leading: Text(
                  e.delta > 0 ? '+${e.delta}' : '${e.delta}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: e.delta > 0 ? Brand.green : Brand.red,
                  ),
                ),
                title: Text(trustReasonLabel(l, e.reason)),
                trailing: Text(e.at == null ? '' : DateFormat.MMMd().format(e.at!)),
              ),
          ]),
        ),
      ]);
    });
  }
}

class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView(ref.watch(profileProvider(uid)), builder: (p) {
        if (p == null) return Center(child: Text(context.l10n.errGeneric));
        return ListView(padding: const EdgeInsets.all(16), children: [ProfileHeader(profile: p)]);
      }),
    );
  }
}

/// Avatar, trust score with progress to next level, stats grid and badges.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final next = p.trustScore < 60 ? 60 : (p.trustScore < 120 ? 120 : null);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: Brand.gradient, borderRadius: BorderRadius.circular(22)),
        child: Column(children: [
          AppAvatar(name: p.displayName, url: p.photoUrl, size: 72),
          const SizedBox(height: 10),
          Text(p.displayName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
            child: Text(levelLabel(l, p.level),
                style: TextStyle(color: levelColor(p.level), fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 16),
          Text('${p.trustScore}',
              style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1)),
          Text(l.trustScore, style: const TextStyle(color: Colors.white70)),
          if (next != null) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (p.trustScore / next).clamp(0, 1).toDouble(),
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 6),
            Text(l.pointsToNext(next - p.trustScore), style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ]),
      ),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.3,
        children: [
          _StatBox(value: '${p.stat('groupsCompleted')}', label: l.statCompleted),
          _StatBox(value: '${p.completionRate}%', label: l.statCompletionRate),
          _StatBox(value: '${p.activityRate}%', label: l.statDailyActivity),
          _StatBox(value: '${p.stat('activeDays')}', label: l.statActiveDays),
          _StatBox(value: '${p.stat('feedbackGiven')}', label: l.statFeedback),
          _StatBox(value: '${p.stat('helpfulFeedback')}', label: l.statHelpful),
        ],
      ),
      SectionTitle(l.badges),
      if (p.badges.isEmpty)
        Text(l.noBadges, style: Theme.of(context).textTheme.bodyMedium)
      else
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final b in p.badges)
            Chip(avatar: Icon(badgeIcon(b), color: Brand.violet), label: Text(badgeLabel(l, b))),
        ]),
    ]);
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            Text(label, textAlign: TextAlign.center, maxLines: 2, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );
}
