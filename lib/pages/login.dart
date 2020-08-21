import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_input.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, JdUser;
import 'package:jdlj/screen.dart';

class JdLogin extends StatefulWidget {
  JdLogin({Key key}) : super(key: key);

  @override
  _JdLoginState createState() => _JdLoginState();
}

class _JdLoginState extends State<JdLogin> {
  String _username = "";
  String _pwd = "";

  Future _toLogin() async {
    var res = await JdAjax.post(
        "/doLogin", {"username": _username, "password": _pwd});
    return res.data;
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: ScreenAdaptor.height(50.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/jd.jpg",
                fit: BoxFit.cover,
                width: ScreenAdaptor.width(150.0),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdaptor.height(40.0)),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
            child: Column(
              children: <Widget>[
                JdInput(
                  placeholder: "手机号",
                  maxLength: 11,
                  inputVal: _username,
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
                SizedBox(
                  height: ScreenAdaptor.height(20.0),
                ),
                JdInput(
                  isPassword: true,
                  placeholder: "请输入密码",
                  inputVal: _pwd,
                  maxLength: 10,
                  onChanged: (value) {
                    setState(() {
                      _pwd = value;
                    });
                  },
                ),
                SizedBox(
                  height: ScreenAdaptor.height(100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "忘记密码",
                        style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/registerfirst");
                        },
                        child: Text(
                          "新用户注册",
                          style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenAdaptor.height(100.0),
                ),
                JdProvider.connect<JdUser>(
                  builder: (context, user, child) {
                    return FractionallySizedBox(
                      widthFactor: 0.8,
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text(
                          "登录",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenAdaptor.fz(18.0),
                              letterSpacing: 4.0),
                        ),
                        onPressed: () {
                          _toLogin().then((res) {
                            if (res["success"]) {
                              // JdUserInfo.setUserInfo(json.encode(res["userinfo"]));
                              user.setUserInfo(res["userinfo"][0]);
                              Navigator.of(context).pop();
                            } else {
                              JdToast.showShortMsg(res["message"]);
                            }
                          });
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
