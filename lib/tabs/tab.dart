/*
 * @author: lujie
 * @Date: 2020-07-23 17:24:15
 * @LastEditTime: 2020-08-26 13:17:18
 * @FilePath: \jdlj\lib\tabs\tab.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, MCart;
import 'package:jdlj/push.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/tabs/cart.dart';
import 'package:jdlj/tabs/category.dart';
import 'package:jdlj/tabs/home.dart';
import 'package:jdlj/tabs/person.dart';

class JdTab extends StatefulWidget {
  final Map arg;
  JdTab({Key key, this.arg}) : super(key: key);

  @override
  _JdTabState createState() => _JdTabState();
}

class _JdTabState extends State<JdTab> {
  int _currentIndex = 0;
  List<Widget> _pages = [JdHome(), JdCategory(), JdCart(), JdPerson()];
  PageController _pg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.arg != null) {
      _currentIndex = widget.arg["current"];
    }
    _pg = new PageController(initialPage: _currentIndex);
    JdPush.initPlatformState();
  }

  Widget _getAppBarWidget(BuildContext ctx) {
    return AppBar(
      centerTitle: true,
      title: _currentIndex == 0 || _currentIndex == 1
          ? InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/search");
              },
              child: Container(
                width: ScreenAdaptor.screenWidth / 2,
                height: ScreenAdaptor.height(50.0),
                padding: EdgeInsets.only(left: ScreenAdaptor.width(20.0)),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 0.9),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdaptor.width(30.0)))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: ScreenAdaptor.width(26.0),
                    ),
                    SizedBox(
                      width: ScreenAdaptor.width(10.0),
                    ),
                    Text(
                      "搜索相关内容",
                      style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
                    )
                  ],
                ),
              ),
            )
          : _currentIndex == 2 ? Text("购物车") : Text("个人中心"),
      leading: _currentIndex == 0 || _currentIndex == 1
          ? IconButton(
              icon: Icon(
                Icons.center_focus_strong,
                color: Colors.white,
                size: ScreenAdaptor.fz(30.0),
              ),
              onPressed: null,
            )
          : null,
      actions: <Widget>[
        _currentIndex == 0 || _currentIndex == 1
            ? IconButton(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                  size: ScreenAdaptor.fz(30.0),
                ),
                onPressed: null,
              )
            : _currentIndex == 2
                ? JdProvider.connect<MCart>(
                    builder: (context, _, child) {
                      return IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _.clearCart();
                        },
                      );
                    },
                  )
                : Text("")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaptor.init(context);
    return Scaffold(
      appBar: _getAppBarWidget(context),
      body: PageView(
          controller: _pg,
          children: _pages,
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text("分页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("购物车")),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("个人"))
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pg.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
