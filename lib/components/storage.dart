/*
 * @author: lujie
 * @Date: 2020-07-30 15:30:39
 * @LastEditTime: 2020-07-30 16:35:09
 * @FilePath: \jdlj\lib\components\storage.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:shared_preferences/shared_preferences.dart';

class JdStorage {
  static Future<bool> setStorage(String key, dynamic value) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.setString(key, value);
  }

  static Future<String> getStorage(String key) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString(key) ?? "";
  }

  static Future<bool> remove(key) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.remove(key);
  }
}
