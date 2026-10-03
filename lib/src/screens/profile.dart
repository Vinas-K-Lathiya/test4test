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
import '../widgets/ui.dart';

class MyProfileTab extends ConsumerWidget {
  const MyProfileTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncView(
      ref.watch(myProfileProvider),
      builder: (p) {
        if (p == null) return const SizedBox.shrink();
        final log = ref.watch(trustLogProvider).value ?? const [];
        final groups = ref.watch(myGroupsProvider).value ?? const [];
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            ProfileHeader(profile: p),
            SectionHeader(l.recentActivity),
            if (log.isEmpty)
              SoftCard(child: Text(l.noTrustHistory, style: Theme.of(context).textTheme.bodyMedium))
            else
              SoftCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    for (final (i, e) in log.take(8).indexed) ...[
                      if (i > 0) const Divider(height: 1, indent: 72),
                      ListTile(
                        leading: ImgTile(
                          trustReasonImage(e.reason),
                          size: 44,
                          color: e.delta >= 0 ? Brand.green : Brand.red,
                        ),
                        title: Text(
                          trustReasonLabel(l, e.reason),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        subtitle: e.at == null ? null : Text(DateFormat.MMMd().add_jm().format(e.at!)),
                        trailing: Text(
                          e.delta > 0 ? '+${e.delta}' : '${e.delta}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: e.delta > 0 ? Brand.green : (e.delta < 0 ? Brand.red : Brand.muted),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            SectionHeader(l.groupHistory),
            if (groups.isEmpty) SoftCard(child: Text(l.noGroupsYet, style: Theme.of(context).textTheme.bodyMedium)),
            for (final g in groups) ...[
              SoftCard(
                padding: const EdgeInsets.all(12),
                onTap: () => context.push('/group/${g.id}'),
                child: Row(
                  children: [
                    ImgTile(g.status == GroupStatus.completed ? 'trophy' : 'people', size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.groupTitle(g.shortId), style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(
                            [
                              groupStatusLabel(l, g.status),
                              if (g.createdAt != null) DateFormat.yMMMd().format(g.createdAt!),
                            ].join(' · '),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Brand.grey),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 12),
            SoftCard(
              padding: const EdgeInsets.all(12),
              onTap: () => context.push('/settings'),
              child: Row(
                children: [
                  const ImgTile('gear', size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l.settings, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Brand.grey),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView(
        ref.watch(profileProvider(uid)),
        builder: (p) {
          if (p == null) return Center(child: Text(context.l10n.errGeneric));
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [ProfileHeader(profile: p)],
          );
        },
      ),
    );
  }
}

/// Avatar + name, trust score card, stats and badges.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = profile;
    final next = p.trustScore < 60 ? 60 : (p.trustScore < 120 ? 120 : null);
    final lvl = levelColor(p.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Avatar block on a soft lavender wash.
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: BoxDecoration(gradient: Brand.washGradient, borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: Brand.gradient),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: AppAvatar(name: p.displayName, url: p.photoUrl, size: 94),
                    ),
                  ),
                  const Positioned(right: -4, bottom: -2, child: Img3d('shield', size: 36)),
                ],
              ),
              const SizedBox(height: 12),
              Text(p.displayName, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Brand.ink)),
              const SizedBox(height: 6),
              StatusPill(levelLabel(l, p.level), color: lvl, icon: Icons.verified_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Trust score card.
        GradientCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Img3d('shield', size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l.trustScore, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                  ),
                  Text('${p.trustScore}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, height: 1)),
                  if (next != null)
                    Text(
                      ' /$next',
                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
              if (next != null) ...[
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: (p.trustScore / next).clamp(0, 1).toDouble(),
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 10),
                Text(
                  l.pointsToNext(next - p.trustScore),
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: StatTile(value: '${p.stat('groupsCompleted')}', label: l.statCompleted, image: 'trophy'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(value: '${p.activityRate}%', label: l.statDailyActivity, image: 'chart'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatTile(value: '${p.stat('feedbackGiven')}', label: l.statFeedback, image: 'speech'),
            ),
          ],
        ),
        SectionHeader(l.badges, subtitle: l.badgesEarned(p.badges.length, allBadges.length)),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allBadges.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final b = allBadges[i];
              final earned = p.badges.contains(b);
              return SizedBox(
                width: 96,
                child: SoftCard(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Img3d(badgeImage(b), size: 48, opacity: earned ? 1 : 0.28),
                          if (!earned) const Icon(Icons.lock_rounded, size: 18, color: Brand.grey),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badgeLabel(l, b),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: earned ? null : Brand.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
