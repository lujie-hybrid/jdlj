/*
 * @author: lujie
 * @Date: 2020-07-30 17:15:33
 * @LastEditTime: 2020-08-21 17:04:59
 * @FilePath: \jdlj\lib\pages\product_detail.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/future.dart';
import 'package:jdlj/components/html.dart';
import 'package:jdlj/components/jdButton.dart';
import 'package:jdlj/model/detail_entity.dart';
import 'package:jdlj/screen.dart';
import 'detail/prod_detail.dart';
import 'package:jdlj/provider/jd_provider.dart' show MCart, JdProvider, TabDt;

class JdProDetail extends StatefulWidget {
  final Map arg;
  JdProDetail({Key key, this.arg}) : super(key: key);

  @override
  _JdProDetailState createState() => _JdProDetailState();
}

class _JdProDetailState extends State<JdProDetail>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tb;
  ScrollController _sc;
  // 全局key
  GlobalKey<JdProdInnerDetailState> _prokey = GlobalKey();
  GlobalKey _detailkey = GlobalKey();
  GlobalKey _commentkey = GlobalKey();

  String _detailId;

  double _getPos(GlobalKey _key) {
    if (_key.currentContext == null) return 0;
    RenderBox box = _key.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    return offset.dy;
  }

  double _propos;
  double _detailpos;
  double _commentpos;

  DetailResult _dr;

  Timer _timer;

  Future<DetailResult> _getDetailInterfaceData() async {
    var res = await JdAjax.get("/pcontent?id=$_detailId");
    DetailEntity de = new DetailEntity();
    de.fromJson(res.data);
    return de.result;
  }

  @override
  void initState() {
    super.initState();
    _tb = new TabController(length: 3, vsync: this);
    _sc = new ScrollController();
    _detailId = widget.arg["id"];
    print(_detailId);
  }

  initPos() {
    _detailpos = _getPos(_detailkey);
    _propos = _getPos(_prokey);
    _commentpos = _getPos(_commentkey);
  }

  _callback() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPos();
      _sc.addListener(() {
        if (_propos == null) return;
        double top = _sc.position.pixels + _propos;
        if (top >= _propos && top < _detailpos && _tb.index != 0) {
          _tb.animateTo(0);
        } else if (top >= _detailpos && top < _commentpos && _tb.index != 1) {
          _tb.animateTo(1);
        } else if (top >= _commentpos && _tb.index != 2) {
          _tb.animateTo(2);
        }
      });
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        double pos = _getPos(_commentkey);
        if (pos == _commentpos) {
          timer.cancel();
        } else {
          initPos();
        }
      });
    });
  }

  // // @override
  void didUpdateWidget(JdProDetail oldWidget) {
    initPos();
    super.didUpdateWidget(oldWidget);
    print("更新了，666");
  }

  // @override
  void didChangeDependencies() {
    initPos();
    super.didChangeDependencies();
    print("de 更新");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tb.dispose();
    _sc.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  Future _getMenu() {
    return showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            ScreenAdaptor.width(100.0), ScreenAdaptor.height(100.0), 0, 0),
        items: [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.home),
                SizedBox(
                  width: ScreenAdaptor.width(5.0),
                ),
                Text("首页")
              ],
            ),
          ),
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(
                  width: ScreenAdaptor.width(5.0),
                ),
                Text("搜索")
              ],
            ),
          )
        ]);
  }

  Widget _getBottomCont() {
    return Container(
      width: ScreenAdaptor.width(750.0),
      height: ScreenAdaptor.height(90.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 1.0, color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          JdProvider.connect2<MCart, TabDt>(
            builder: (context, cart, tab, child) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("/", arguments: {"current": 2});
                },
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.shopping_cart),
                        Text("购物车")
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: ScreenAdaptor.height(6.0),
                      child: cart.count == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              width: ScreenAdaptor.width(24.0),
                              height: ScreenAdaptor.width(24.0),
                              alignment: Alignment.center,
                              child: Text(
                                "${cart.count}",
                                style: TextStyle(
                                    fontSize: ScreenAdaptor.fz(10.0),
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0))),
                    )
                  ],
                ),
              );
            },
          ),
          JdProvider.connect<MCart>(
            builder: (context, _, child) {
              return JdButton(
                width: ScreenAdaptor.screenWidth / 3,
                bgColor: Colors.red,
                buttonText: "加入购物车",
                style: TextStyle(color: Colors.white),
                onPress: () {
                  if (_dr.attr != null && _dr.attr.length > 0) {
                    _prokey.currentState.showModal(_dr);
                  } else {
                    _prokey.currentState.showModal(_dr, noAttr: true);
                  }
                },
              );
            },
          ),
          JdProvider.connect<MCart>(
            builder: (context, _, child) {
              return JdButton(
                width: ScreenAdaptor.screenWidth / 3,
                bgColor: Colors.orange,
                buttonText: "立即购买",
                style: TextStyle(color: Colors.white),
                onPress: () {
                  if (_dr.attr != null && _dr.attr.length > 0) {
                    _prokey.currentState.showModal(_dr);
                  } else {
                    _prokey.currentState.showModal(_dr, noAttr: true);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getBody(BuildContext bc, AsyncSnapshot at) {
    _dr = at.data;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _sc,
          child: Column(
            children: <Widget>[
              JdProdInnerDetail(
                key: _prokey,
                dr: _dr,
              ),
              Container(
                key: _detailkey,
                width: ScreenAdaptor.screenWidth,
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
                child: JdHtml(data: _dr?.content),
              ),
              Container(
                key: _commentkey,
                width: double.infinity,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 50,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text("张三或者李四的评论$index"),
                        subtitle: Text("子集评论模拟$index"),
                        trailing: Icon(Icons.mode_comment),
                        leading: Icon(Icons.comment),
                      );
                    }),
              ),
              SizedBox(
                height: ScreenAdaptor.height(90.0),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: _getBottomCont(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              _getMenu();
            },
          )
        ],
        title: Container(
          width: ScreenAdaptor.width(400.0),
          child: TabBar(
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tb,
            onTap: (value) {
              switch (value) {
                case 0:
                  _sc.jumpTo(0);
                  break;
                case 1:
                  _sc.jumpTo(_detailpos - _propos);
                  break;
                case 2:
                  _sc.jumpTo(_commentpos - _propos);
                  break;
                default:
                  break;
              }
            },
            tabs: <Widget>[
              Tab(
                child: Text("商品"),
              ),
              Tab(
                child: Text("详情"),
              ),
              Tab(
                child: Text("评价"),
              )
            ],
          ),
        ),
      ),
      body: JdFuture(
        interface: _getDetailInterfaceData(),
        getChild: _getBody,
        callback: _callback,
      ),
    );
  }
}
