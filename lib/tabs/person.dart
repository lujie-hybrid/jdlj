/*
 * @author: lujie
 * @Date: 2020-07-24 11:21:32
 * @LastEditTime: 2020-08-21 14:44:17
 * @FilePath: \jdlj\lib\tabs\person.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdlj/components/Jd_image_picker.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, JdUser, MCart;
import 'package:jdlj/screen.dart';

class JdPerson extends StatefulWidget {
  JdPerson({Key key}) : super(key: key);

  @override
  _JdPersonState createState() => _JdPersonState();
}

class _JdPersonState extends State<JdPerson>
    with AutomaticKeepAliveClientMixin {
  ByteData _bd;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        Container(
          height: ScreenAdaptor.height(300.0),
          padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(50.0)),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/loginbg.jpg"), fit: BoxFit.cover)),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  JdImagePicker.selectImages().then((value) async {
                    if (value != null && value.length > 0) {
                      ByteData bd = await value[0].getByteData();
                      print(value);
                      setState(() {
                        _bd = bd;
                      });
                    }
                  });
                },
                child: _bd == null
                    ? CircleAvatar(
                        backgroundColor: Colors.white30,
                        radius: ScreenAdaptor.width(50.0),
                        child: Icon(
                          Icons.person_outline,
                          size: ScreenAdaptor.width(60.0),
                          color: Colors.white,
                        ))
                    : ClipOval(
                        child: Image.memory(
                          _bd.buffer.asUint8List(),
                          fit: BoxFit.cover,
                          width: ScreenAdaptor.width(100.0),
                          height: ScreenAdaptor.width(100.0),
                        ),
                      ),
              ),
              SizedBox(
                width: ScreenAdaptor.width(50.0),
              ),
              JdProvider.connect<JdUser>(
                builder: (context, user, child) {
                  return user.userinfo != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "用户名：${user.userinfo['username']}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "唯一标识：${user.userinfo['_id']}",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/login");
                          },
                          child: Text(
                            "登录/注册",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdaptor.fz(22.0)),
                          ),
                        );
                },
              )
            ],
          ),
        ),
        JdProvider.connect<JdUser>(
          builder: (context, _, child) {
            return ListTile(
              title: Text("全部订单"),
              leading: Icon(
                Icons.assignment,
                color: Colors.red,
              ),
              onTap: () {
                if (_.userinfo == null) {
                  JdToast.showShortMsg("请先登录");
                } else {
                  Navigator.of(context).pushNamed("/order");
                }
              },
            );
          },
        ),
        Divider(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          height: 1.0,
        ),
        ListTile(
          title: Text("待付款"),
          leading: Icon(
            Icons.subtitles,
            color: Colors.green,
          ),
        ),
        Divider(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          height: 1.0,
        ),
        ListTile(
          title: Text("待收货"),
          leading: Icon(
            Icons.add_shopping_cart,
            color: Colors.orange,
          ),
        ),
        SizedBox(
          height: ScreenAdaptor.height(10.0),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.06),
          ),
        ),
        ListTile(
          title: Text("我的收藏"),
          leading: Icon(
            Icons.favorite,
            color: Colors.green,
          ),
        ),
        Divider(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          height: 1.0,
        ),
        ListTile(
          title: Text("在线客服"),
          leading: Icon(
            Icons.people,
            color: Colors.grey,
          ),
        ),
        Divider(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          height: 1.0,
        ),
        SizedBox(
          height: ScreenAdaptor.height(100.0),
        ),
        JdProvider.connect2<JdUser, MCart>(
          builder: (context, user, cart, child) {
            return user.userinfo == null
                ? SizedBox(
                    height: 0,
                  )
                : FractionallySizedBox(
                    widthFactor: 0.6,
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenAdaptor.fz(18.0),
                            letterSpacing: 4.0),
                      ),
                      onPressed: () {
                        user.removeUserInfo();
                        cart.clearCart();
                      },
                    ),
                  );
          },
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
