// PLACEHOLDER — replaced when you run `flutterfire configure` (see docs/SETUP.md step 3).
// The app compiles with these values but cannot talk to Firebase until you do.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('TestPact supports Android only.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'testpact-app',
    storageBucket: 'testpact-app.firebasestorage.app',
  );
}
