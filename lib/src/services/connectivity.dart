import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// true = we can actually reach the internet (not just "connected to Wi-Fi").
class ConnectivityController extends Notifier<bool> {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _poll;
  bool _checking = false;

  @override
  bool build() {
    _sub = Connectivity().onConnectivityChanged.listen((_) => recheck());
    ref.onDispose(() {
      _sub?.cancel();
      _poll?.cancel();
    });
    Future.microtask(recheck);
    return true; // optimistic until the first check finishes
  }

  Future<void> recheck() async {
    if (_checking) return;
    _checking = true;
    try {
      final links = await Connectivity().checkConnectivity();
      final online = !links.every((l) => l == ConnectivityResult.none) && await _reachable();
      state = online;
      // While offline, keep probing: some networks come back without a connectivity event.
      _poll?.cancel();
      if (!online) _poll = Timer(const Duration(seconds: 5), recheck);
    } finally {
      _checking = false;
    }
  }

  static Future<bool> _reachable() async {
    for (final host in const ['firestore.googleapis.com', 'google.com']) {
      try {
        final r = await InternetAddress.lookup(host).timeout(const Duration(seconds: 4));
        if (r.isNotEmpty && r.first.rawAddress.isNotEmpty) return true;
      } catch (_) {}
    }
    return false;
  }
}

final onlineProvider = NotifierProvider<ConnectivityController, bool>(ConnectivityController.new);
