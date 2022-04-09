import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/colorConverter.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDtPbdO93x1fqCOlmHBD4dPe_05wYCdCe4",
      appId: "1:734321977225:web:cad81dd4242809d6ade358",
      messagingSenderId: "734321977225",
      projectId: "admin-walking-challange",
      storageBucket: "admin-walking-challange.appspot.com",
      authDomain: "admin-walking-challange.firebaseapp.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Flurorouter.routeSettings();
    super.initState();
  }

  Route<dynamic>? routeSettings(RouteSettings settings) {
    return Flurorouter.router.generator(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920,1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:() => MaterialApp(
        title: "Admin Walking Challenge",
        initialRoute: "/login",
        onGenerateRoute: routeSettings,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: createMaterialColor(Color(0xFF5BBABC)),fontFamily: "Segoe UI"),
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      ),
    );
  }
}
