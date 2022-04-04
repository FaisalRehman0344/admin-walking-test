import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/auth.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:web_routing_app/utils/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _fKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  void onInputChange(String title, String val) {
    if (title == "User Name") {
      email = val;
    } else if (title == "Password") {
      password = val;
    }
  }

  void onSubmit() async {
    AuthService authService = new AuthService();
    if (_fKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String message =
          await authService.signInWithEmailPassword(email, password);
      setState(() {
        _isLoading = false;
      });
      showToast(message);
      if (message == "Sign In Successfully") {
        Timer(Duration(seconds: 1),
            () => Flurorouter.router.navigateTo(context, "/dashboard"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blueGrey,
            width: size.width,
            height: size.height,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: Colors.blueGrey.withOpacity(.3),
            width: size.width,
            height: size.height,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 70),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.3),
                  borderRadius: BorderRadius.circular(20)),
              width: size.width * .28,
              height: size.height * .6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/walking_logo.png",
                    width: 80,
                  ),
                  Text(
                    "LOGIN YOUR ACCOUNT",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Form(
                    key: _fKey,
                    child: Column(
                      children: [
                        loginField("User Name"),
                        loginField("Password"),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                          fixedSize: MaterialStateProperty.all(
                              Size(double.infinity, 20))),
                      onPressed: onSubmit,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(.5)),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField loginField(String title) {
    return TextFormField(
      obscureText: title == "Password",
      onChanged: (val) => onInputChange(title, val),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Please enter $title";
        } else
          return null;
      },
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w200),
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: title,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.only(top: 10)),
    );
  }
}
