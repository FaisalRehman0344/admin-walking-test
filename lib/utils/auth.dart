import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/toast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmailPassword(String email, String password) async {
    User? user;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('auth', true);
        if (user.email != null) await prefs.setString("email", user.email!);
      }

      return "Sign In Successfully";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  void signOut(BuildContext context) async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    showToast('Signed Out Successfully');
    Timer(Duration(seconds: 1), () {
      Flurorouter.router.navigateTo(context, "/login");
    });
  }

  static void checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = await prefs.getBool("auth") ?? false;
    if (!login) Flurorouter.router.navigateTo(context, "/login");
  }
}
