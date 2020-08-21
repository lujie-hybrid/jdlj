import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdlj/components/storage.dart';

class JdUser with ChangeNotifier {
  Map _userinfo;

  get userinfo => _userinfo;

  JdUser() {
    this.initData();
  }

  initData() async {
    String val = await JdStorage.getStorage("userInfo");
    _userinfo = val.isNotEmpty ? json.decode(val) : null;
    notifyListeners();
  }

  void setUserInfo(Map value) {
    _userinfo = value;
    JdStorage.setStorage("userInfo", json.encode(_userinfo));
    notifyListeners();
  }

  void removeUserInfo() {
    JdStorage.remove("userInfo").then((value) {
      if (value) {
        _userinfo = null;
        notifyListeners();
      }
    });
  }
}
