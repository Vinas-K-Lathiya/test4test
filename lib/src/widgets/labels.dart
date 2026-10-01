import 'package:flutter/material.dart';

import '../l10n.dart';
import '../models.dart';
import '../theme.dart';

String levelLabel(AppLocalizations l, TrustLevel level) => switch (level) {
      TrustLevel.probation => l.levelProbation,
      TrustLevel.newcomer => l.levelNewcomer,
      TrustLevel.member => l.levelMember,
      TrustLevel.trusted => l.levelTrusted,
      TrustLevel.topTester => l.levelTopTester,
    };

Color levelColor(TrustLevel level) => switch (level) {
      TrustLevel.probation => Brand.red,
      TrustLevel.newcomer => Brand.grey,
      TrustLevel.member => Brand.teal,
      TrustLevel.trusted => Brand.indigo,
      TrustLevel.topTester => Brand.violet,
    };

TrustLevel levelForScore(int score) {
  if (score < 40) return TrustLevel.probation;
  if (score >= 120) return TrustLevel.topTester;
  if (score >= 60) return TrustLevel.trusted;
  return TrustLevel.member;
}

String reportReasonLabel(AppLocalizations l, String r) => switch (r) {
      'not_installed' => l.reasonNotInstalled,
      'uninstalled' => l.reasonUninstalled,
      'not_opening' => l.reasonNotOpening,
      'email_not_added' => l.reasonEmailNotAdded,
      'spam_abuse' => l.reasonSpam,
      'fake_feedback' => l.reasonFakeFeedback,
      _ => l.reasonOther,
    };

const reportReasons = [
  'not_installed',
  'uninstalled',
  'not_opening',
  'email_not_added',
  'spam_abuse',
  'fake_feedback',
  'other',
];

String categoryLabel(AppLocalizations l, String c) => switch (c) {
      'bug' => l.catBug,
      'ux' => l.catUx,
      'idea' => l.catIdea,
      'praise' => l.catPraise,
      _ => l.catOther,
    };

const feedbackCategories = ['bug', 'ux', 'idea', 'praise', 'other'];

String badgeLabel(AppLocalizations l, String b) => switch (b) {
      'first_pact' => l.badgeFirstPact,
      'veteran' => l.badgeVeteran,
      'perfect_streak' => l.badgePerfect,
      'helpful_reviewer' => l.badgeHelpful,
      'top_tester' => l.badgeTopTester,
      _ => b,
    };

IconData badgeIcon(String b) => switch (b) {
      'first_pact' => Icons.flag_rounded,
      'veteran' => Icons.military_tech_rounded,
      'perfect_streak' => Icons.local_fire_department_rounded,
      'helpful_reviewer' => Icons.rate_review_rounded,
      'top_tester' => Icons.workspace_premium_rounded,
      _ => Icons.star_rounded,
    };

String removedReasonLabel(AppLocalizations l, String? r) => switch (r) {
      'setup_failed' => l.removedSetup,
      'inactive' => l.removedInactive,
      'reported' => l.removedReported,
      'left' => l.removedLeft,
      'group_cancelled' => l.removedCancelled,
      'group_ended' => l.removedEnded,
      _ => l.removedOther,
    };

String trustReasonLabel(AppLocalizations l, String r) {
  if (r.startsWith('admin:')) return l.trustAdmin(r.substring(6).trim());
  return switch (r) {
    'group_completed' => l.trustGroupCompleted,
    'active_day' => l.trustActiveDay,
    'missed_day' => l.trustMissedDay,
    'helpful_feedback' => l.trustHelpfulFeedback,
    'kicked_inactive' => l.trustKickedInactive,
    'kicked_reported' => l.trustKickedReported,
    'setup_failed' => l.trustSetupFailed,
    'left_group' => l.trustLeftGroup,
    'false_report' => l.trustFalseReport,
    'appeal_accepted' => l.trustAppealAccepted,
    _ => r,
  };
}

String groupStatusLabel(AppLocalizations l, GroupStatus s) => switch (s) {
      GroupStatus.setup => l.statusSetup,
      GroupStatus.active => l.statusActive,
      GroupStatus.completed => l.statusCompleted,
      GroupStatus.cancelled => l.statusCancelled,
    };

String memberStateLabel(AppLocalizations l, MemberState s) => switch (s) {
      MemberState.setup => l.stateSetup,
      MemberState.active => l.stateActive,
      MemberState.suspended => l.stateSuspended,
      MemberState.removed => l.stateRemoved,
      MemberState.completed => l.stateCompleted,
    };

/// Traffic-light status for a member in the group list.
Color memberColor(Member m) {
  switch (m.state) {
    case MemberState.removed:
    case MemberState.completed:
      return Brand.grey;
    case MemberState.suspended:
      return Brand.amber;
    case MemberState.setup:
      return m.ready ? Brand.green : Brand.amber;
    case MemberState.active:
      if (m.consecutiveMissed > 0) return Brand.red;
      final t = m.today;
      if (t != null && t.isToday && t.opened >= (t.required * 0.9).ceil()) return Brand.green;
      return Brand.amber;
  }
}
