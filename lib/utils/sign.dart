import 'dart:convert';

import 'package:crypto/crypto.dart';

class JdSign {
  static getSign(Map msg) {
    List keyList = msg.keys.toList();
    keyList.sort();
    String val = "";
    keyList.forEach((element) {
      val += "$element${msg[element]}";
    });
    return md5.convert(utf8.encode(val)).toString();
  }
}
