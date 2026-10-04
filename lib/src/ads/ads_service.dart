import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers.dart';
import 'ad_ids.dart';

/// Remote switches in Firestore config/app:
///   adsEnabled (bool, default true),
///   adsAfterDays (int, default 2): wait before full-screen ads; banner/native show from day one.
class AdsConfig {
  const AdsConfig({required this.enabled, required this.afterDays});
  final bool enabled;
  final int afterDays;
}

final adsConfigProvider = StreamProvider<AdsConfig>((ref) {
  return FirebaseFirestore.instance.collection('config').doc('app').snapshots().map((d) {
    final j = d.data() ?? {};
    return AdsConfig(enabled: j['adsEnabled'] != false, afterDays: (j['adsAfterDays'] as num?)?.toInt() ?? 2);
  });
});

/// User bought 24h ad-free time by watching a rewarded video.
class AdFreeController extends Notifier<DateTime?> {
  static const _key = 'ad_free_until';
  @override
  DateTime? build() {
    final ms = ref.watch(prefsProvider).getInt(_key);
    if (ms == null) return null;
    final until = DateTime.fromMillisecondsSinceEpoch(ms);
    return until.isAfter(DateTime.now()) ? until : null;
  }

  Future<void> grant(Duration d) async {
    final until = DateTime.now().add(d);
    await ref.read(prefsProvider).setInt(_key, until.millisecondsSinceEpoch);
    state = until;
  }
}

final adFreeUntilProvider = NotifierProvider<AdFreeController, DateTime?>(AdFreeController.new);

/// True when this user should see ads right now: enabled remotely, the account is older than
/// [AdsConfig.afterDays], and no active ad-free reward.
/// Full-screen ads (interstitial, app open, rewarded): only after the account's waiting period.
final adsActiveProvider = Provider<bool>((ref) {
  if (ref.watch(adFreeUntilProvider) != null) return false;
  return ref.watch(adsEligibleProvider);
});

/// Banner + native ads: from day one for every signed-in user (unless ad-free or switched off).
final inlineAdsActiveProvider = Provider<bool>((ref) {
  final cfg = ref.watch(adsConfigProvider).value ?? const AdsConfig(enabled: true, afterDays: 2);
  if (!cfg.enabled || ref.watch(adFreeUntilProvider) != null) return false;
  return ref.watch(accountProvider).value != null;
});

/// Admin-only switch (Admin → Test → diagnostics) to see ads immediately, skipping the wait.
class AdsDebugNow extends Notifier<bool> {
  static const _key = 'debug_ads_now';
  @override
  bool build() => ref.watch(prefsProvider).getBool(_key) ?? false;
  Future<void> set(bool v) async {
    await ref.read(prefsProvider).setBool(_key, v);
    state = v;
  }
}

final adsDebugNowProvider = NotifierProvider<AdsDebugNow, bool>(AdsDebugNow.new);

/// Ads are enabled remotely and the account is old enough (ignores the ad-free reward).
final adsEligibleProvider = Provider<bool>((ref) {
  final cfg = ref.watch(adsConfigProvider).value ?? const AdsConfig(enabled: true, afterDays: 2);
  if (!cfg.enabled) return false;
  if (ref.watch(adsDebugNowProvider) && ref.watch(isAdminProvider)) return true;
  final since = ref.watch(accountProvider).value?.createdAt;
  if (since == null) return false;
  return DateTime.now().difference(since) >= Duration(days: cfg.afterDays);
});

/// SDK start-up (with GDPR consent) and the full-screen formats with frequency caps.
class AdsService {
  AdsService(this._ref);
  final Ref _ref;
  bool _started = false;
  bool _canRequest = false;
  InterstitialAd? _interstitial;
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  bool _showingFullScreen = false;

  bool get ready => _started && _canRequest;

  /// Flips to true once the SDK is initialised and consent allows ads; ad widgets listen to it.
  final readyNotifier = ValueNotifier<bool>(false);

  /// When consent info couldn't be fetched we still serve ads, but never personalised ones.
  bool _nonPersonalized = false;
  AdRequest get request => AdRequest(nonPersonalizedAds: _nonPersonalized);

  // ---- Diagnostics (shown in Admin → Test) -------------------------------------------------
  String consentStatus = 'not started';
  String? consentError;
  final lastResult = <String, String>{};
  final diagnostics = ValueNotifier<int>(0);

  void report(String format, String result) {
    lastResult[format] = '${DateTime.now().toIso8601String().substring(11, 19)}  $result';
    diagnostics.value++;
  }

  /// Call once after sign-in. Shows Google's consent form where the law requires it (EEA/UK).
  Future<void> start() async {
    if (_started || !Platform.isAndroid) return;
    _started = true;
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((e) {
          if (e != null) consentError = 'form: ${e.errorCode} ${e.message}';
        });
        if (!done.isCompleted) done.complete();
      },
      (e) {
        consentError = 'update: ${e.errorCode} ${e.message}';
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        consentError ??= 'timeout';
      },
    );
    consentStatus = (await ConsentInformation.instance.getConsentStatus()).name;
    _canRequest = await ConsentInformation.instance.canRequestAds();
    if (!_canRequest && consentError != null) {
      // Consent service unreachable / not configured: serve non-personalised ads only.
      _canRequest = true;
      _nonPersonalized = true;
    }
    diagnostics.value++;
    if (!_canRequest) return;
    await MobileAds.instance.initialize();
    readyNotifier.value = true;
    diagnostics.value++;
    _preloadInterstitial();
    _preloadAppOpen();
  }

  bool get _active => _ref.read(adsActiveProvider);

  // ---- Interstitial: only at natural break points, max 1 per 15 min and 3 per day ----------

  void _preloadInterstitial() {
    if (!ready || _interstitial != null) return;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          report('interstitial', 'loaded');
        },
        onAdFailedToLoad: (e) {
          _interstitial = null;
          report('interstitial', 'error ${e.code}: ${e.message}');
        },
      ),
    );
  }

  Future<void> maybeShowInterstitial() async {
    if (!ready || !_active || _showingFullScreen) return;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final last = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('ad_i_last') ?? 0);
    final dayKey = '${now.year}-${now.month}-${now.day}';
    final todayCount = prefs.getString('ad_i_day') == dayKey ? (prefs.getInt('ad_i_count') ?? 0) : 0;
    if (now.difference(last) < const Duration(minutes: 15) || todayCount >= 3) return;
    final ad = _interstitial;
    if (ad == null) {
      _preloadInterstitial();
      return;
    }
    _interstitial = null;
    _showingFullScreen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _showingFullScreen = false;
        _preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _showingFullScreen = false;
        _preloadInterstitial();
      },
    );
    await prefs.setInt('ad_i_last', now.millisecondsSinceEpoch);
    await prefs.setString('ad_i_day', dayKey);
    await prefs.setInt('ad_i_count', todayCount + 1);
    await ad.show();
  }

  // ---- App open: only when returning after 4+ hours away, never on first launch ------------

  void _preloadAppOpen() {
    if (!ready || _appOpen != null) return;
    AppOpenAd.load(
      adUnitId: AdIds.appOpen,
      request: request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpen = ad;
          _appOpenLoadedAt = DateTime.now();
          report('appOpen', 'loaded');
        },
        onAdFailedToLoad: (e) {
          _appOpen = null;
          report('appOpen', 'error ${e.code}: ${e.message}');
        },
      ),
    );
  }

  Future<void> onAppResumed(Duration away) async {
    if (!ready || !_active || _showingFullScreen || away < const Duration(hours: 4)) return;
    final ad = _appOpen;
    // App open ads expire after 4 hours.
    if (ad == null || DateTime.now().difference(_appOpenLoadedAt!) > const Duration(hours: 4)) {
      _appOpen?.dispose();
      _appOpen = null;
      _preloadAppOpen();
      return;
    }
    _appOpen = null;
    _showingFullScreen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _showingFullScreen = false;
        _preloadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _showingFullScreen = false;
        _preloadAppOpen();
      },
    );
    await ad.show();
  }

  // ---- Rewarded: user chooses to watch a video for 24h without ads --------------------------

  Future<bool> watchForAdFree() async {
    if (!ready) return false;
    final loaded = Completer<RewardedAd?>();
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          report('rewarded', 'loaded');
          loaded.complete(ad);
        },
        onAdFailedToLoad: (e) {
          report('rewarded', 'error ${e.code}: ${e.message}');
          loaded.complete(null);
        },
      ),
    );
    final ad = await loaded.future.timeout(const Duration(seconds: 20), onTimeout: () => null);
    if (ad == null) return false;
    final earned = Completer<bool>();
    _showingFullScreen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _showingFullScreen = false;
        if (!earned.isCompleted) earned.complete(false);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _showingFullScreen = false;
        if (!earned.isCompleted) earned.complete(false);
      },
    );
    await ad.show(
      onUserEarnedReward: (_, _) async {
        await _ref.read(adFreeUntilProvider.notifier).grant(const Duration(hours: 24));
        if (!earned.isCompleted) earned.complete(true);
      },
    );
    return earned.future;
  }

  /// Admin diagnostics: load and show one interstitial right now, ignoring caps.
  Future<void> debugShowInterstitial() async {
    if (!ready) {
      report('interstitial', 'SDK not ready');
      return;
    }
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          report('interstitial', 'loaded (debug)');
          ad.show();
        },
        onAdFailedToLoad: (e) => report('interstitial', 'error ${e.code}: ${e.message}'),
      ),
    );
  }

  bool get nonPersonalized => _nonPersonalized;

  /// "Privacy options" entry for users in regions that require it.
  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  Future<void> showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});
}

final adsServiceProvider = Provider<AdsService>(AdsService.new);

/// Watches app lifecycle to trigger the (rare) app-open ad.
class AppOpenAdObserver with WidgetsBindingObserver {
  AppOpenAdObserver(this._ads);
  final AdsService _ads;
  DateTime? _pausedAt;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _pausedAt = DateTime.now();
    if (state == AppLifecycleState.resumed && _pausedAt != null) {
      _ads.onAppResumed(DateTime.now().difference(_pausedAt!));
      _pausedAt = null;
    }
  }
}
