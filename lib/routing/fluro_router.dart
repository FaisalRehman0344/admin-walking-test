import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:web_routing_app/screens/challenges.dart';
import 'package:web_routing_app/screens/dashboard.dart';
import 'package:web_routing_app/screens/home.dart';
import 'package:web_routing_app/screens/login.dart';
import 'package:web_routing_app/screens/settings/settings.dart';
import 'package:web_routing_app/screens/store.dart';
import 'package:web_routing_app/screens/users.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static final _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const LoginScreen();
  });

  static final _dashboardHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const DashboardScreen();
  });

  static final _challengesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const ChallengesScreen();
  });

  static final _storeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const StoreScreen();
  });

  static final _usersHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const UsersScreen();
  });

  static final _settingsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return const SettingsScreen();
  });

  static void routeSettings() {
    // router.define("/", handler: _homeHandlar);
    router.define("/dashboard", handler: _dashboardHandler,);
    router.define("/login", handler: _loginHandler);
    router.define("/store", handler: _storeHandler);
    router.define("/challenges", handler: _challengesHandler);
    router.define("/users", handler: _usersHandler);
    router.define("/settings", handler: _settingsHandler);

    //Handler for unknown route
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const DashboardScreen();
    });
  }
}
