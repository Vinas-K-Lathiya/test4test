import '../firebase_options.dart';

/// App-wide constants. Server-side rules live in functions/src/config.ts — keep in sync.
class AppConfig {
  static const functionsRegion = 'asia-south1';
  static const adminEmails = ['vlathiya5944@gmail.com'];
  static const supportEmail = 'vlathiya5944@gmail.com';
  static const packageName = 'com.fffmv.free_fire_game1';

  /// OAuth "Web client" ID from Firebase Auth → Google provider. Google Sign-In needs it to issue
  /// an ID token that Firebase accepts.
  static const googleWebClientId = '999364978128-sbudg5n4sd278bt0kl9f5nr3p603se6d.apps.googleusercontent.com';

  static const groupSize = 20;
  static const minToStart = 14;
  static const testDays = 16;
  static const setupHours = 48;
  static const dailyPassRatio = 0.9;
  static const kickAfterMissed = 3;

  static String get _site => 'https://${DefaultFirebaseOptions.android.projectId}.web.app';
  static String get privacyUrl => '$_site/privacy';
  static String get termsUrl => '$_site/terms';
  static String get deleteAccountUrl => '$_site/delete-account';
  static const playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';

  /// Firebase/GCP project number, used for Play Integrity (same as messagingSenderId).
  static int get cloudProjectNumber => int.tryParse(DefaultFirebaseOptions.android.messagingSenderId) ?? 0;

  static const locales = ['en', 'hi', 'gu', 'mr', 'es', 'pt'];
  static const localeNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'gu': 'ગુજરાતી',
    'mr': 'मराठी',
    'es': 'Español',
    'pt': 'Português',
  };
}

/// Day boundaries are UTC on both client and server.
String dayKey([DateTime? d]) => (d ?? DateTime.now()).toUtc().toIso8601String().substring(0, 10);

DateTime utcMidnight([DateTime? d]) {
  final u = (d ?? DateTime.now()).toUtc();
  return DateTime.utc(u.year, u.month, u.day);
}

int passThreshold(int required) => (required * AppConfig.dailyPassRatio).ceil();
