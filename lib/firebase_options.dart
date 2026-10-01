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
    apiKey: 'AIzaSyD-ErDZT83kmlnb_jT7cnprcdGOMbaMOB4',
    appId: '1:999364978128:android:10c388fc5657a6a0c1c5d5',
    messagingSenderId: '999364978128',
    projectId: 'testpact-vlathiya',
    storageBucket: 'testpact-vlathiya.firebasestorage.app',
  );
}
