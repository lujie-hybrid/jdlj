import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:jdlj/screen.dart';

class JdHtml extends StatefulWidget {
  final String data;

  JdHtml({Key key, this.data}) : super(key: key);

  @override
  _JdHtmlState createState() => _JdHtmlState();
}

class _JdHtmlState extends State<JdHtml> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Html(
        data: widget.data,
        style: {
          "html,body": Style(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          "img": Style(
              width: (ScreenAdaptor.screenWidth - ScreenAdaptor.width(40.0))),
          "p": Style(
              width: (ScreenAdaptor.screenWidth - ScreenAdaptor.width(40.0))),
          "div": Style(
              width: (ScreenAdaptor.screenWidth - ScreenAdaptor.width(40.0))),
        },
      ),
    );
  }
}
