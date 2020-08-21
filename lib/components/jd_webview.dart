/*
 * @author: lujie
 * @Date: 2020-08-03 14:40:59
 * @LastEditTime: 2020-08-06 09:30:31
 * @FilePath: \jdlj\lib\components\jd_webview.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class JdWebview extends StatefulWidget {
  final String path;
  JdWebview({Key key, this.path}) : super(key: key);

  @override
  _JdWebviewState createState() => _JdWebviewState();
}

class _JdWebviewState extends State<JdWebview> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  // bool isInit = true;

  // double _htmlHeight = 200; // 目的是在回调完成之前先展示出200高度的内容, 提高用户体验

  // static const String HANDLER_NAME = 'InAppWebView';

  @override
  void dispose() {
    super.dispose();
    // webView?.removeJavaScriptHandler(handlerName: HANDLER_NAME);
    webView = null;
  }

  // changeHeight(ConsoleMessage consoleMessage) {
  //   if (double.parse(consoleMessage.message) > 200) {
  //     setState(() {
  //       _htmlHeight = double.parse(consoleMessage.message);
  //     });
  //     print(
  //         "is laoding................${double.parse(consoleMessage.message)}");
  //     widget.callback(double.parse(consoleMessage.message));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
        initialData: InAppWebViewInitialData(data: widget.path ?? ''),
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true, useShouldOverrideUrlLoading: true)),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          setState(() {
            this.url = url;
          });
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          setState(() {
            this.url = url;
          });
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        });
  }
}
