import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../l10n.dart';
import '../theme.dart';
import 'ad_ids.dart';
import 'ads_service.dart';

/// Builds [child] only when inline ads (banner/native) are on and the SDK is ready.
class _WhenAds extends ConsumerWidget {
  const _WhenAds({required this.builder});
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(inlineAdsActiveProvider)) return const SizedBox.shrink();
    final ads = ref.watch(adsServiceProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: ads.readyNotifier,
      builder: (context, ready, _) => ready ? builder(context) : const SizedBox.shrink(),
    );
  }
}

/// Full-width adaptive banner pinned under content (e.g. bottom of a screen). Collapses if no fill.
class BannerAdSlot extends StatelessWidget {
  const BannerAdSlot({super.key});
  @override
  Widget build(BuildContext context) => _WhenAds(builder: (_) => const _Banner());
}

class _Banner extends ConsumerStatefulWidget {
  const _Banner();
  @override
  ConsumerState<_Banner> createState() => _BannerState();
}

class _BannerState extends ConsumerState<_Banner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null) _load();
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) return;
    final ads = ref.read(adsServiceProvider);
    _ad = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: ads.request,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          ads.report('banner', 'loaded');
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, e) {
          ads.report('banner', 'error ${e.code}: ${e.message}');
          ad.dispose();
          _ad = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      width: double.infinity,
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}

/// Native ad rendered as a soft card that matches the app, clearly labelled "Ad".
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key, this.padding = EdgeInsets.zero});
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => _WhenAds(
    builder: (_) => Padding(padding: padding, child: const _Native()),
  );
}

class _Native extends ConsumerStatefulWidget {
  const _Native();
  @override
  ConsumerState<_Native> createState() => _NativeState();
}

class _NativeState extends ConsumerState<_Native> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad != null) return;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ads = ref.read(adsServiceProvider);
    _ad = NativeAd(
      adUnitId: AdIds.native,
      request: ads.request,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          ads.report('native', 'loaded');
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, e) {
          ads.report('native', 'error ${e.code}: ${e.message}');
          ad.dispose();
          _ad = null;
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 16,
        mainBackgroundColor: dark ? Brand.cardDark : Colors.white,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Brand.indigo,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: dark ? Colors.white : Brand.ink,
          style: NativeTemplateFontStyle.bold,
          size: 15,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(textColor: Brand.muted, size: 13),
        tertiaryTextStyle: NativeTemplateTextStyle(textColor: Brand.muted, size: 12),
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            context.l10n.adLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          height: 112,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: Brand.softShadow(context)),
          clipBehavior: Clip.antiAlias,
          child: AdWidget(ad: ad),
        ),
      ],
    );
  }
}
