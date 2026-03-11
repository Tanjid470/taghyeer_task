import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:taghyeer_task/presentation/widgets/no_internet_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class ConnectivityService {
  ConnectivityService({
    Connectivity? connectivity,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _connectivity = connectivity ?? Connectivity(),
        _navigatorKey = navigatorKey ?? appNavigatorKey;

  final Connectivity _connectivity;
  final GlobalKey<NavigatorState> _navigatorKey;

  final ValueNotifier<bool> hasInternet = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _showingNoInternet = false;
  Route<void>? _noInternetRoute;

  Future<void> init() async {
    final initialResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(initialResult);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    hasInternet.dispose();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final connected = results.any((result) => result != ConnectivityResult.none);
    hasInternet.value = connected;

    if (!connected && !_showingNoInternet) {
      _showNoInternetScreen();
      return;
    }

    if (connected && _showingNoInternet) {
      _hideNoInternetScreen();
    }
  }

  void _showNoInternetScreen() {
    _showingNoInternet = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = _navigatorKey.currentState;
      if (navigator == null) {
        _showingNoInternet = false;
        return;
      }

      if (_noInternetRoute != null) {
        return;
      }

      _noInternetRoute = MaterialPageRoute<void>(
        settings: const RouteSettings(name: NoInternetScreen.routeName),
        builder: (_) => const NoInternetScreen(),
      );

      navigator.push(_noInternetRoute!).whenComplete(() {
        _noInternetRoute = null;

        // Keep the offline screen visible while there is no connection.
        if (!hasInternet.value) {
          _showingNoInternet = false;
          _showNoInternetScreen();
          return;
        }

        _showingNoInternet = false;
      });
    });
  }

  void _hideNoInternetScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = _navigatorKey.currentState;

      if (navigator == null) {
        _showingNoInternet = false;
        return;
      }

      final route = _noInternetRoute;
      if (route != null) {
        try {
          navigator.removeRoute(route);
        } catch (_) {
          // The route may already be removed by navigation events.
        }
      }

      _noInternetRoute = null;
      _showingNoInternet = false;
    });
  }

}