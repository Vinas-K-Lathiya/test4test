import 'package:flutter/foundation.dart';

/// AdMob unit IDs. Debug builds use Google's official test units so testing on your own phone
/// never counts as invalid traffic on the real account.
class AdIds {
  static const appId = 'ca-app-pub-6123927127117956~8215108263';

  static String get banner =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/7275673524' : 'ca-app-pub-3940256099942544/9214589741';
  static String get interstitial =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/1288849676' : 'ca-app-pub-3940256099942544/1033173712';
  static String get rewardedInterstitial =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/3533627221' : 'ca-app-pub-3940256099942544/5354046379';
  static String get rewarded =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/2220545550' : 'ca-app-pub-3940256099942544/5224354917';
  static String get native =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/9363529246' : 'ca-app-pub-3940256099942544/2247696110';
  static String get appOpen =>
      kReleaseMode ? 'ca-app-pub-6123927127117956/8573191750' : 'ca-app-pub-3940256099942544/9257395921';
}
