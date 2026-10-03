import 'package:cloud_firestore/cloud_firestore.dart';

import 'config.dart';

typedef Json = Map<String, dynamic>;

DateTime? _ts(dynamic v) => v is Timestamp ? v.toDate() : null;
int _int(dynamic v) => (v as num?)?.toInt() ?? 0;

/// Private account doc: users/{uid}
class UserAccount {
  UserAccount({
    required this.uid,
    required this.email,
    required this.currentGroupId,
    required this.strikes,
    required this.banned,
    required this.locale,
    this.notifications = const {},
  });

  final String uid;
  final String email;
  final String? currentGroupId;
  final int strikes;
  final bool banned;
  final String? locale;

  /// Per-category push settings: daily, group, feedback. Missing = on.
  final Map<String, bool> notifications;
  bool notifyFor(String category) => notifications[category] ?? true;

  factory UserAccount.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return UserAccount(
      uid: d.id,
      email: j['email'] as String? ?? '',
      currentGroupId: j['currentGroupId'] as String?,
      strikes: _int(j['strikes']),
      banned: j['banned'] == true,
      locale: j['locale'] as String?,
      notifications: {for (final e in ((j['notifications'] as Map?) ?? {}).entries) e.key as String: e.value == true},
    );
  }
}

/// users/{uid}/inbox/{id}: in-app copy of every notification.
class InboxItem {
  InboxItem({
    required this.id,
    required this.key,
    required this.title,
    required this.body,
    required this.data,
    required this.read,
    required this.at,
  });

  final String id;
  final String key;
  final String title;
  final String body;
  final Map<String, String> data;
  final bool read;
  final DateTime? at;

  String? get groupId => data['groupId'];

  factory InboxItem.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return InboxItem(
      id: d.id,
      key: j['key'] as String? ?? '',
      title: j['title'] as String? ?? '',
      body: j['body'] as String? ?? '',
      data: {for (final e in ((j['data'] as Map?) ?? {}).entries) e.key as String: '${e.value}'},
      read: j['read'] == true,
      at: _ts(j['at']),
    );
  }
}

enum TrustLevel { probation, newcomer, member, trusted, topTester }

/// Public profile: profiles/{uid}
class Profile {
  Profile({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.trustScore,
    required this.stats,
    required this.badges,
  });

  final String uid;
  final String displayName;
  final String? photoUrl;
  final int trustScore;
  final Map<String, int> stats;
  final List<String> badges;

  int stat(String k) => stats[k] ?? 0;

  int get completionRate {
    final joined = stat('groupsJoined');
    if (joined == 0) return 0;
    return (stat('groupsCompleted') * 100 / joined).round();
  }

  int get activityRate {
    final total = stat('activeDays') + stat('missedDays');
    if (total == 0) return 0;
    return (stat('activeDays') * 100 / total).round();
  }

  TrustLevel get level {
    final completed = stat('groupsCompleted');
    if (trustScore < 40) return TrustLevel.probation;
    if (completed == 0) return TrustLevel.newcomer;
    if (trustScore >= 120 && completed >= 3) return TrustLevel.topTester;
    if (trustScore >= 60) return TrustLevel.trusted;
    return TrustLevel.member;
  }

  factory Profile.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return Profile(
      uid: d.id,
      displayName: j['displayName'] as String? ?? 'Tester',
      photoUrl: j['photoUrl'] as String?,
      trustScore: _int(j['trustScore']),
      stats: {for (final e in ((j['stats'] as Map?) ?? {}).entries) e.key as String: _int(e.value)},
      badges: List<String>.from(j['badges'] as List? ?? const []),
    );
  }
}

class TrustLogEntry {
  TrustLogEntry({required this.delta, required this.reason, required this.score, required this.at});
  final int delta;
  final String reason;
  final int score;
  final DateTime? at;

  factory TrustLogEntry.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return TrustLogEntry(
      delta: _int(j['delta']),
      reason: j['reason'] as String? ?? '',
      score: _int(j['score']),
      at: _ts(j['at']),
    );
  }
}

/// App listing: apps/{id}
class AppListing {
  AppListing({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.packageName,
    required this.description,
    required this.testNotes,
    required this.optInWebUrl,
    required this.optInPlayUrl,
    this.iconUrl,
  });

  final String id;
  final String ownerUid;
  final String name;
  final String packageName;
  final String description;
  final String testNotes;
  final String optInWebUrl;
  final String optInPlayUrl;
  final String? iconUrl;

  static String playUrlFor(String pkg) => 'https://play.google.com/store/apps/details?id=$pkg';
  static String optInUrlFor(String pkg) => 'https://play.google.com/apps/testing/$pkg';

  Json toJson() => {
    'ownerUid': ownerUid,
    'name': name,
    'packageName': packageName,
    'description': description,
    'testNotes': testNotes,
    'optInWebUrl': optInWebUrl,
    'optInPlayUrl': optInPlayUrl,
    'iconUrl': iconUrl,
  };

  factory AppListing.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return AppListing(
      id: d.id,
      ownerUid: j['ownerUid'] as String? ?? '',
      name: j['name'] as String? ?? '',
      packageName: j['packageName'] as String? ?? '',
      description: j['description'] as String? ?? '',
      testNotes: j['testNotes'] as String? ?? '',
      optInWebUrl: j['optInWebUrl'] as String? ?? '',
      optInPlayUrl: j['optInPlayUrl'] as String? ?? '',
      iconUrl: j['iconUrl'] as String?,
    );
  }
}

class QueueEntry {
  QueueEntry({required this.appId, required this.tier, required this.joinedAt});
  final String appId;
  final String tier;
  final DateTime? joinedAt;

  factory QueueEntry.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return QueueEntry(
      appId: j['appId'] as String? ?? '',
      tier: j['tier'] as String? ?? 'starter',
      joinedAt: _ts(j['joinedAt']),
    );
  }
}

enum GroupStatus { setup, active, completed, cancelled }

class Group {
  Group({
    required this.id,
    required this.tier,
    required this.status,
    required this.createdAt,
    required this.setupDeadline,
    required this.rosterVersion,
    required this.startDay,
    required this.endDay,
    required this.testDays,
    required this.size,
  });

  final String id;
  final String tier;
  final GroupStatus status;
  final DateTime? createdAt;
  final DateTime? setupDeadline;
  final int rosterVersion;
  final String? startDay;
  final String? endDay;
  final int testDays;
  final int size;

  String get shortId => id.substring(0, id.length < 5 ? id.length : 5).toUpperCase();

  /// 1-based day of the test, or 0 before start.
  int get dayIndex {
    if (startDay == null) return 0;
    final start = DateTime.parse('${startDay}T00:00:00Z');
    return utcMidnight().difference(start).inDays + 1;
  }

  factory Group.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return Group(
      id: d.id,
      tier: j['tier'] as String? ?? 'starter',
      status: GroupStatus.values.firstWhere((s) => s.name == j['status'], orElse: () => GroupStatus.setup),
      createdAt: _ts(j['createdAt']),
      setupDeadline: _ts(j['setupDeadline']),
      rosterVersion: _int(j['rosterVersion']),
      startDay: j['startDay'] as String?,
      endDay: j['endDay'] as String?,
      testDays: _int(j['testDays']) == 0 ? AppConfig.testDays : _int(j['testDays']),
      size: _int(j['size']),
    );
  }
}

enum MemberState { setup, active, suspended, removed, completed }

class DayResult {
  DayResult({required this.day, required this.ok, required this.opened, required this.required});
  final String day;
  final bool ok;
  final int opened;
  final int required;
}

class TodayStatus {
  TodayStatus({
    required this.day,
    required this.installed,
    required this.opened,
    required this.required,
    required this.usageAccess,
  });
  final String day;
  final int installed;
  final int opened;
  final int required;
  final bool usageAccess;

  bool get isToday => day == dayKey();
}

class Member {
  Member({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.trustScore,
    required this.appId,
    required this.appName,
    required this.packageName,
    required this.optInWebUrl,
    required this.optInPlayUrl,
    required this.iconUrl,
    required this.testNotes,
    required this.state,
    required this.late,
    required this.setupDeadline,
    required this.emailsAdded,
    required this.emailsAddedVersion,
    required this.installedAll,
    required this.ready,
    required this.activeSince,
    required this.consecutiveMissed,
    required this.missedDays,
    required this.activeDays,
    required this.feedbackTo,
    required this.lastDays,
    required this.today,
    required this.removedReason,
  });

  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int trustScore;
  final String appId;
  final String appName;
  final String packageName;
  final String optInWebUrl;
  final String optInPlayUrl;
  final String? iconUrl;
  final String testNotes;
  final MemberState state;
  final bool late;
  final DateTime? setupDeadline;
  final bool emailsAdded;
  final int emailsAddedVersion;
  final bool installedAll;
  final bool ready;
  final String? activeSince;
  final int consecutiveMissed;
  final int missedDays;
  final int activeDays;
  final Map<String, int> feedbackTo;
  final List<DayResult> lastDays;
  final TodayStatus? today;
  final String? removedReason;

  bool get isLive => state == MemberState.setup || state == MemberState.active;
  int get feedbackGiven => feedbackTo.values.fold(0, (a, b) => a + b);

  factory Member.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    final t = j['today'] as Map?;
    return Member(
      uid: d.id,
      email: j['email'] as String? ?? '',
      displayName: j['displayName'] as String? ?? 'Tester',
      photoUrl: j['photoUrl'] as String?,
      trustScore: _int(j['trustScore']),
      appId: j['appId'] as String? ?? '',
      appName: j['appName'] as String? ?? '',
      packageName: j['packageName'] as String? ?? '',
      optInWebUrl: j['optInWebUrl'] as String? ?? '',
      optInPlayUrl: j['optInPlayUrl'] as String? ?? '',
      iconUrl: j['iconUrl'] as String?,
      testNotes: j['testNotes'] as String? ?? '',
      state: MemberState.values.firstWhere((s) => s.name == j['state'], orElse: () => MemberState.setup),
      late: j['late'] == true,
      setupDeadline: _ts(j['setupDeadline']),
      emailsAdded: j['emailsAdded'] == true,
      emailsAddedVersion: _int(j['emailsAddedVersion']),
      installedAll: j['installedAll'] == true,
      ready: j['ready'] == true,
      activeSince: j['activeSince'] as String?,
      consecutiveMissed: _int(j['consecutiveMissed']),
      missedDays: _int(j['missedDays']),
      activeDays: _int(j['activeDays']),
      feedbackTo: {for (final e in ((j['feedbackTo'] as Map?) ?? {}).entries) e.key as String: _int(e.value)},
      lastDays: [
        for (final x in (j['lastDays'] as List? ?? const []))
          DayResult(
            day: (x as Map)['day'] as String? ?? '',
            ok: x['ok'] == true,
            opened: _int(x['opened']),
            required: _int(x['required']),
          ),
      ],
      today: t == null
          ? null
          : TodayStatus(
              day: t['day'] as String? ?? '',
              installed: _int(t['installed']),
              opened: _int(t['opened']),
              required: _int(t['required']),
              usageAccess: t['usageAccess'] == true,
            ),
      removedReason: j['removedReason'] as String?,
    );
  }
}

/// Apps `uid` should have installed: same rule as the server's visibleApps().
List<Member> visibleAppsFor(List<Member> members, String uid) =>
    members.where((m) => m.uid != uid && m.isLive && m.emailsAdded).toList();

class GroupEvent {
  GroupEvent({required this.type, required this.data, required this.at});
  final String type;
  final Json data;
  final DateTime? at;

  factory GroupEvent.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return GroupEvent(type: j['type'] as String? ?? '', data: j, at: _ts(j['at']));
  }
}

class FeedbackItem {
  FeedbackItem({
    required this.id,
    required this.groupId,
    required this.fromUid,
    required this.fromName,
    required this.toUid,
    required this.appName,
    required this.rating,
    required this.category,
    required this.text,
    required this.screenshotPath,
    required this.helpful,
    required this.createdAt,
  });

  final String id;
  final String groupId;
  final String fromUid;
  final String fromName;
  final String toUid;
  final String appName;
  final int rating;
  final String category;
  final String text;
  final String? screenshotPath;
  final bool? helpful;
  final DateTime? createdAt;

  factory FeedbackItem.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return FeedbackItem(
      id: d.id,
      groupId: j['groupId'] as String? ?? '',
      fromUid: j['fromUid'] as String? ?? '',
      fromName: j['fromName'] as String? ?? '',
      toUid: j['toUid'] as String? ?? '',
      appName: j['appName'] as String? ?? '',
      rating: _int(j['rating']),
      category: j['category'] as String? ?? 'other',
      text: j['text'] as String? ?? '',
      screenshotPath: j['screenshotPath'] as String?,
      helpful: j['helpful'] as bool?,
      createdAt: _ts(j['createdAt']),
    );
  }
}

class Appeal {
  Appeal({
    required this.id,
    required this.uid,
    required this.email,
    required this.text,
    required this.status,
    required this.note,
    required this.createdAt,
  });
  final String id;
  final String uid;
  final String email;
  final String text;
  final String status;
  final String? note;
  final DateTime? createdAt;

  factory Appeal.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return Appeal(
      id: d.id,
      uid: j['uid'] as String? ?? '',
      email: j['email'] as String? ?? '',
      text: j['text'] as String? ?? '',
      status: j['status'] as String? ?? 'open',
      note: j['note'] as String?,
      createdAt: _ts(j['createdAt']),
    );
  }
}

class Review {
  Review({
    required this.id,
    required this.groupId,
    required this.targetUid,
    required this.targetName,
    required this.targetEmail,
    required this.reportIds,
    required this.reasons,
    required this.data,
    required this.createdAt,
  });

  final String id;
  final String groupId;
  final String targetUid;
  final String targetName;
  final String targetEmail;
  final List<String> reportIds;
  final List<String> reasons;
  final Json data;
  final DateTime? createdAt;

  factory Review.fromDoc(DocumentSnapshot<Json> d) {
    final j = d.data() ?? {};
    return Review(
      id: d.id,
      groupId: j['groupId'] as String? ?? '',
      targetUid: j['targetUid'] as String? ?? '',
      targetName: j['targetName'] as String? ?? '',
      targetEmail: j['targetEmail'] as String? ?? '',
      reportIds: List<String>.from(j['reportIds'] as List? ?? const []),
      reasons: List<String>.from(j['reasons'] as List? ?? const []),
      data: Map<String, dynamic>.from(j['data'] as Map? ?? const {}),
      createdAt: _ts(j['createdAt']),
    );
  }
}
