import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:universal_html/html.dart';
import 'package:web_routing_app/screens/home.dart';
import 'package:web_routing_app/routing/fluro_router.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    final loader = document.getElementsByClassName('indeterminate');
    if (loader.isNotEmpty) {
      loader.first.remove();
    }

    Flurorouter.routeSettings();

    super.initState();
  }

  Route<dynamic>? routeSettings(RouteSettings settings) {
    return Flurorouter.router.generator(settings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login",
      onGenerateRoute: routeSettings,
      debugShowCheckedModeBanner: false,
    );
  }
}
