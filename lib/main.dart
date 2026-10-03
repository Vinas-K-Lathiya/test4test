import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/providers.dart';
import 'src/services/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  await scheduleBackgroundSync();
  runApp(ProviderScope(overrides: [prefsProvider.overrideWithValue(prefs)], child: const TestPactApp()));
}
