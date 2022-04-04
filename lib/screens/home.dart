import 'package:flutter/material.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onHomeClick(String title,BuildContext context) {
    if (title == "Admin") {
      Flurorouter.router.navigateTo(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/images/walking_logo.png"),
              margin: EdgeInsets.only(bottom: 100),
              width: 100,
            ),
            homeButton("Store",context),
            homeButton("Admin",context),
          ],
        ),
      ),
    );
  }

  Container homeButton(String title,BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: 250,
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: primaryColor),
      child: TextButton(
        onPressed: () => onHomeClick(title,context),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
