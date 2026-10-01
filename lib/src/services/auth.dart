import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_bridge/device_bridge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config.dart';
import 'api.dart';

class AuthService {
  AuthService(this._api, this._device);
  final Api _api;
  final DeviceBridge _device;
  final _auth = FirebaseAuth.instance;
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(serverClientId: AppConfig.googleWebClientId);
    _initialized = true;
  }

  /// Returns false if the user cancelled.
  Future<bool> signInWithGoogle() async {
    await _init();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      rethrow;
    }
  }

  /// Creates the account on first sign-in; enforces one account per device and Play Integrity.
  Future<void> bootstrap(String locale) async {
    final deviceId = await _device.deviceId();
    String? token;
    final config = await FirebaseFirestore.instance.collection('config').doc('app').get();
    if (config.data()?['integrityRequired'] == true) {
      final nonce = await _api.integrityNonce();
      token = await _device.integrityToken(nonce, cloudProjectNumber: AppConfig.cloudProjectNumber);
    }
    await _api.bootstrapUser(deviceId: deviceId, locale: locale, integrityToken: token);
  }

  Future<void> signOut() async {
    await _init();
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  bool get isAdmin {
    final u = _auth.currentUser;
    return u != null && u.emailVerified && AppConfig.adminEmails.contains(u.email?.toLowerCase());
  }
}
