/*
 * @author: lujie
 * @Date: 2020-07-24 11:18:24
 * @LastEditTime: 2020-08-04 15:28:48
 * @FilePath: \jdlj\lib\tabs\home.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/components/jdSwiper.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/best_entity.dart';
import 'package:jdlj/model/hot_entity.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/model/slider_entity.dart';
import 'package:jdlj/components/ajax.dart';

class JdHome extends StatefulWidget {
  JdHome({Key key}) : super(key: key);

  @override
  _JdHomeState createState() => _JdHomeState();
}

class _JdHomeState extends State<JdHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // 轮播图数据
  List<SliderResult> _sr;

  // 猜你喜欢数据
  List<HotResult> _he;

  // 热门商品
  List<BestResult> _be;

  // 获取轮播图接口数据
  void _getSliderInterface() async {
    var res = await JdAjax.get("/focus");
    SliderEntity se = new SliderEntity();
    se.fromJson(res.data);
    setState(() {
      _sr = se.result;
    });
  }

  // 获取猜你喜欢数据
  void _getHotInterface() async {
    var res = await JdAjax.get("/plist?is_hot=1");
    HotEntity he = new HotEntity();
    he.fromJson(res.data);
    setState(() {
      _he = he.result;
    });
  }

  // 获取热门推荐数据
  void _getBestInterface() async {
    var res = await JdAjax.get("/plist?is_best=1");
    BestEntity be = new BestEntity();
    be.fromJson(res.data);
    setState(() {
      _be = be.result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSliderInterface();
    _getHotInterface();
    _getBestInterface();
  }

  // 轮播图
  Widget _getSliderCont(int index) {
    String str = _sr[index].pic.replaceAll(new RegExp(r'\\'), '/');
    return Image.network("${JdConfig.domain}/$str", fit: BoxFit.cover);
  }

  // 获取标题
  Widget _getTitle(String title) {
    return Container(
      child: Text(title),
      margin: EdgeInsets.symmetric(vertical: ScreenAdaptor.height(20.0)),
      padding: EdgeInsets.only(left: ScreenAdaptor.width(8.0)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.red, width: ScreenAdaptor.width(5.0)))),
    );
  }

  //刻画猜你喜欢
  Widget _getHot() {
    if (_he == null || _he.length == 0) return Text("");
    return Container(
      width: double.infinity,
      height: ScreenAdaptor.height(170.0),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String str = _he[index].sPic.replaceAll(new RegExp(r'\\'), '/');
          return Container(
            margin: EdgeInsets.only(right: ScreenAdaptor.width(16.0)),
            child: Column(
              children: <Widget>[
                Image.network(
                  "${JdConfig.domain}/$str",
                  width: ScreenAdaptor.width(140.0),
                  height: ScreenAdaptor.height(140.0),
                  fit: BoxFit.cover,
                ),
                Text(
                  "\$${_he[index].price}",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          );
        },
        itemCount: _he.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  // 获取内容列表

  List<Widget> _getListCont() {
    if (_be == null || _be.length == 0) return [Text("")];
    double w = (ScreenAdaptor.screenWidth - ScreenAdaptor.width(40)) / 2;
    return _be.map((item) {
      String str = item.pic.replaceAll(new RegExp(r'\\'), '/');
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(ScreenAdaptor.width(20.0)),
          width: w,
          decoration:
              BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  "${JdConfig.domain}/$str",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: ScreenAdaptor.height(10.0),
              ),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: ScreenAdaptor.height(10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "\$${item.price}",
                    style: TextStyle(
                        color: Colors.red, fontSize: ScreenAdaptor.fz(20.0)),
                  ),
                  Text(
                    "\$${item.oldPrice}",
                    style: TextStyle(decoration: TextDecoration.lineThrough),
                  )
                ],
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed("/prodetail", arguments: {"id": item.sId});
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        JdSwiper(
          count: _sr?.length,
          swiperChild: _getSliderCont,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getTitle("猜你喜欢"),
              _getHot(),
              _getTitle("热门推荐"),
              Wrap(
                runSpacing: ScreenAdaptor.width(20),
                spacing: ScreenAdaptor.width(20),
                children: _getListCont(),
              )
            ],
          ),
        )
      ],
    );
  }
}
