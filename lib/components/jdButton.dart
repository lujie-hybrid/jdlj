/*
 * @author: lujie
 * @Date: 2020-08-03 09:59:08
 * @LastEditTime: 2020-08-10 16:03:31
 * @FilePath: \jdlj\lib\components\jdButton.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */

import 'package:flutter/material.dart';
import 'package:jdlj/screen.dart';

class JdButton extends StatelessWidget {
  final String buttonText;
  final Color bgColor;
  final double width;
  final double borderRadius;
  final TextStyle style;
  final Function onPress;
  const JdButton(
      {Key key,
      this.buttonText,
      this.bgColor,
      this.width,
      this.borderRadius = 30.0,
      this.onPress,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPress != null) {
          onPress();
        }
      },
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: ScreenAdaptor.height(16.0),
            horizontal: ScreenAdaptor.width(30.0)),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                BorderRadius.circular(ScreenAdaptor.width(borderRadius))),
        child: Text(
          buttonText,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
