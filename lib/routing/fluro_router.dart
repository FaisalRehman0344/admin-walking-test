import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:web_routing_app/screens/dashboard.dart';
import 'package:web_routing_app/screens/home.dart';
import 'package:web_routing_app/screens/login.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static final _homeHandlar = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const HomeScreen();
  });

  static final _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LoginScreen();
  });

  static final _dashboardHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const DashboardScreen();
  });

  static void routeSettings() {
    router.define("/", handler: _homeHandlar);
    router.define("/dashboard", handler: _dashboardHandler);
    router.define("/login", handler: _loginHandler);

    //Handler for unknown route
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const HomeScreen();
    });
  }
}
