/*
 * @author: lujie
 * @Date: 2020-07-24 11:09:03
 * @LastEditTime: 2020-08-06 10:25:41
 * @FilePath: \jdlj\lib\screen.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaptor {
  static void init(context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
  }

  static double width(double value) {
    return ScreenUtil().setWidth(value);
  }

  static double height(double value) {
    return ScreenUtil().setHeight(value);
  }

  static double fz(double value) {
    return ScreenUtil().setSp(value);
  }

  static double get screenWidth => ScreenUtil.screenWidth;
  static double get screenHeight => ScreenUtil.screenHeight;
  static double get statusBarHeight => ScreenUtil.statusBarHeight;
  static double get bottomBarHeight => ScreenUtil.bottomBarHeight;
  static double get pixelRatio => ScreenUtil.pixelRatio;
}
