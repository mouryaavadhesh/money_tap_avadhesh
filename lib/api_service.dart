import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ApiService {
  Client client = Client();
  dynamic responseLoadAllInProgress;
  static final ApiService apiService = ApiService.initLogic();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool connectionStatus = true;

  factory ApiService() {
    return apiService;
  }

  ApiService.initLogic() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // getApps();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {}

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus = true;
        break;
      case ConnectivityResult.mobile:
        connectionStatus = true;
        break;
      case ConnectivityResult.none:
        connectionStatus = false;

        break;
      default:
        connectionStatus = false;
        break;
    }
  }

  Future getData(String text) async {
    return await client.get(
      "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=" +
          text,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
  }
}
