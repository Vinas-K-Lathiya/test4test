import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n.dart';
import 'providers.dart';
import 'router.dart';
import 'theme.dart';
import 'ads/private_dns_gate.dart';
import 'widgets/connectivity_gate.dart';
import 'widgets/update_gate.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class TestPactApp extends ConsumerWidget {
  const TestPactApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'TestPact',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      builder: (context, child) => ConnectivityGate(
        child: PrivateDnsGate(
          child: UpdateGate(navigatorKey: rootNavigatorKey, child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
