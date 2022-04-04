import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      webBgColor: "linear-gradient(to right,#5BBABC,#004344)",
      textColor: Colors.white,
      webPosition: "right",
      fontSize: 16.0);
}
