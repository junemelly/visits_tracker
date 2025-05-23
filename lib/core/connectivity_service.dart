import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final wasOnline = _isOnline;
      _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (wasOnline != _isOnline) {
        notifyListeners();
      }
    } as void Function(ConnectivityResult event)?);
  }

  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> results = (await Connectivity().checkConnectivity()) as List<ConnectivityResult>;
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    return _isOnline;
  }
}