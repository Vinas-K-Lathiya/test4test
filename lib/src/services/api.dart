import 'package:cloud_functions/cloud_functions.dart';

import '../config.dart';

/// Typed wrapper around the Cloud Functions callables.
class Api {
  Api([FirebaseFunctions? f]) : _f = f ?? FirebaseFunctions.instanceFor(region: AppConfig.functionsRegion);
  final FirebaseFunctions _f;

  Future<Map<String, dynamic>> call(String name, [Map<String, dynamic> data = const {}]) async {
    final r = await _f.httpsCallable(name).call<Object?>(data);
    final v = r.data;
    return v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
  }

  Future<String> integrityNonce() async => (await call('getIntegrityNonce'))['nonce'] as String;

  Future<void> bootstrapUser({required String deviceId, required String locale, String? integrityToken}) =>
      call('bootstrapUser', {'deviceId': deviceId, 'locale': locale, 'integrityToken': ?integrityToken});

  Future<void> deleteAccount() => call('deleteAccount');
  Future<void> submitAppeal(String text, {String? groupId}) =>
      call('submitAppeal', {'text': text, 'groupId': ?groupId});

  /// Returns the new group id if joining completed a group right away.
  Future<String?> joinQueue(String appId) async => (await call('joinQueue', {'appId': appId}))['groupId'] as String?;
  Future<void> leaveQueue() => call('leaveQueue');

  Future<void> confirmEmailsAdded(String groupId) => call('confirmEmailsAdded', {'groupId': groupId});
  Future<void> leaveGroup(String groupId) => call('leaveGroup', {'groupId': groupId});

  Future<Map<String, dynamic>> syncActivity({
    required String groupId,
    required Map<String, Map<String, Object>> apps,
    required bool usageAccess,
  }) =>
      call('syncActivity', {'groupId': groupId, 'apps': apps, 'usageAccess': usageAccess});

  Future<void> submitFeedback({
    required String groupId,
    required String toUid,
    required int rating,
    required String category,
    required String text,
    String? screenshotPath,
  }) =>
      call('submitFeedback', {
        'groupId': groupId,
        'toUid': toUid,
        'rating': rating,
        'category': category,
        'text': text,
        'screenshotPath': ?screenshotPath,
      });

  Future<void> rateFeedback(String feedbackId, bool helpful) =>
      call('rateFeedback', {'feedbackId': feedbackId, 'helpful': helpful});

  Future<void> submitReport({
    required String groupId,
    required String targetUid,
    required String reason,
    required String details,
    String? screenshotPath,
  }) =>
      call('submitReport', {
        'groupId': groupId,
        'targetUid': targetUid,
        'reason': reason,
        'details': details,
        'screenshotPath': ?screenshotPath,
      });

  // Admin
  Future<void> resolveReview(String reviewId, String decision, String note) =>
      call('adminResolveReview', {'reviewId': reviewId, 'decision': decision, 'note': note});
  Future<void> resolveAppeal(String appealId, String decision, String note) =>
      call('adminResolveAppeal', {'appealId': appealId, 'decision': decision, 'note': note});
  Future<void> setBan(String uid, bool banned) => call('adminSetBan', {'uid': uid, 'banned': banned});
  Future<void> adjustTrust(String uid, int delta, String reason) =>
      call('adminAdjustTrust', {'uid': uid, 'delta': delta, 'reason': reason});
  Future<Map<String, dynamic>> findUser(String email) => call('adminFindUser', {'email': email});

  /// Admin test harness: action = seed | forceStart | advance | cleanup.
  Future<Map<String, dynamic>> testTools(String action, {String? groupId, int? days, bool? miss}) =>
      call('adminTestTools', {'action': action, 'groupId': ?groupId, 'days': ?days, 'miss': ?miss});
}
