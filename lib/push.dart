/*
 * @author: lujie
 * @Date: 2020-07-24 09:19:43
 * @LastEditTime: 2020-07-24 09:26:21
 * @FilePath: \jdlj\lib\push.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JdPush {
  static final JPush jpush = new JPush();
  static Future<void> initPlatformState() async {
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {},
          onOpenNotification: (Map<String, dynamic> message) async {},
          onReceiveMessage: (Map<String, dynamic> message) async {},
          onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {});
    } on PlatformException {
      print('Failed to get platform version.');
    }

    jpush.setup(
      appKey: "6fd8c42327a1af3a7850cf4d", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
    });
  }
}
