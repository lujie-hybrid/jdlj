import 'package:flutter/material.dart';

typedef JdFutureChildBuilder = Widget Function(
    BuildContext bc, AsyncSnapshot as);

class JdFuture extends StatelessWidget {
  final Future interface;

  final JdFutureChildBuilder getChild;

  final Function callback;

  const JdFuture({Key key, this.interface, this.getChild, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext bc, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print('还没有开始网络请求');
            return Text('还没有开始网络请求');
          case ConnectionState.active:
            print('active');
            return Text('ConnectionState.active');
          case ConnectionState.waiting:
            print('waiting');
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (callback != null) {
              callback();
            }
            return getChild(context, snapshot);
          default:
            return Text('还没有开始网络请求');
        }
      },
      future: this.interface,
    );
  }
}
