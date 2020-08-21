import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:jdlj/screen.dart';

class JdToast {
  static showShortMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: ScreenAdaptor.fz(18.0));
  }
}
