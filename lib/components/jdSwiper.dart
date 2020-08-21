/*
 * @author: lujie
 * @Date: 2020-07-24 11:26:22
 * @LastEditTime: 2020-07-28 10:30:52
 * @FilePath: \jdlj\lib\components\jdSwiper.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

typedef JdSwiperBuilder = Widget Function(int index);

class JdSwiper extends StatefulWidget {
  final JdSwiperBuilder swiperChild;
  final int count;
  final double ar;

  JdSwiper({Key key, @required this.swiperChild, @required this.count, this.ar})
      : super(key: key);

  @override
  _JdSwiperState createState() => _JdSwiperState();
}

class _JdSwiperState extends State<JdSwiper> {
  @override
  Widget build(BuildContext context) {
    if (widget.count == null || widget.count == 0) return Text("");
    return AspectRatio(
      aspectRatio: widget.ar ?? 2,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return widget.swiperChild(index);
        },
        itemCount: widget.count ?? 0,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}
