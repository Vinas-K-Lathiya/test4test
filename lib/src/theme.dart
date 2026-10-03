import 'package:flutter/material.dart';

class Brand {
  static const indigo = Color(0xFF5B4CF5);
  static const violet = Color(0xFF8A6BFF);
  static const deep = Color(0xFF4338CA);
  static const teal = Color(0xFF0D9488);
  static const green = Color(0xFF16A34A);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFE11D48);
  static const grey = Color(0xFF94A3B8);

  static const ink = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const bg = Color(0xFFF4F5FB);
  static const bgDark = Color(0xFF0B0F1E);
  static const cardDark = Color(0xFF151A2E);

  static const font = 'PlusJakartaSans';

  static const gradient = LinearGradient(
    colors: [Color(0xFF5B4CF5), Color(0xFF7C5CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft lavender wash used behind headers (profile, sign-in pages).
  static const washGradient = LinearGradient(
    colors: [Color(0xFFEDEBFF), Color(0xFFF4F5FB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> softShadow(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const []
      : [BoxShadow(color: const Color(0xFF5B4CF5).withValues(alpha: 0.07), blurRadius: 24, offset: const Offset(0, 8))];
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.indigo,
    brightness: brightness,
    primary: dark ? const Color(0xFFA5B4FC) : Brand.indigo,
    secondary: Brand.teal,
    surface: dark ? Brand.cardDark : Colors.white,
  );
  final base = ThemeData(colorScheme: scheme, useMaterial3: true, brightness: brightness, fontFamily: Brand.font);
  final text = base.textTheme.apply(
    bodyColor: dark ? const Color(0xFFE5E7EB) : Brand.ink,
    displayColor: dark ? Colors.white : Brand.ink,
  );
  final pill = RoundedRectangleBorder(borderRadius: BorderRadius.circular(99));

  return base.copyWith(
    scaffoldBackgroundColor: dark ? Brand.bgDark : Brand.bg,
    textTheme: text.copyWith(
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      bodySmall: text.bodySmall?.copyWith(color: dark ? const Color(0xFF9CA3AF) : Brand.muted),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: dark ? Brand.bgDark : Brand.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: dark ? Colors.white : Brand.ink,
      titleTextStyle: TextStyle(
        fontFamily: Brand.font,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: dark ? Colors.white : Brand.ink,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: dark ? Brand.cardDark : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        shape: pill,
        textStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        shape: pill,
        side: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
        foregroundColor: scheme.primary,
        textStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? Brand.cardDark : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      backgroundColor: dark ? Brand.cardDark : const Color(0xFFEEF0FF),
      selectedColor: scheme.primary,
      labelStyle: TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w600, color: scheme.onSurface),
      secondaryLabelStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700, color: Colors.white),
      checkmarkColor: Colors.white,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: scheme.primary,
      unselectedLabelColor: dark ? const Color(0xFF9CA3AF) : Brand.muted,
      indicatorColor: scheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: scheme.outlineVariant.withValues(alpha: 0.4),
      labelStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700, fontSize: 15),
      unselectedLabelStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w600, fontSize: 15),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontFamily: Brand.font,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: dark ? Colors.white : Brand.ink,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: Brand.font,
        fontSize: 13,
        color: dark ? const Color(0xFF9CA3AF) : Brand.muted,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Brand.indigo,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      elevation: 6,
      extendedTextStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      contentTextStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w600),
    ),
    dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: pill,
        selectedBackgroundColor: scheme.primary,
        selectedForegroundColor: Colors.white,
        textStyle: const TextStyle(fontFamily: Brand.font, fontWeight: FontWeight.w700),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : null),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Brand.indigo : null),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: Brand.indigo),
  );
}
