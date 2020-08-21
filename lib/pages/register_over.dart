import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_form_input.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, JdUser;
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/validate.dart';

class JdRegisterOver extends StatefulWidget {
  final Map arg;
  JdRegisterOver({Key key, this.arg}) : super(key: key);

  @override
  _JdJdRegisterOverState createState() => _JdJdRegisterOverState();
}

class _JdJdRegisterOverState extends State<JdRegisterOver> {
  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  String _pwd = "";

  Future _register() async {
    var res = await JdAjax.post("/register", {
      "tel": widget.arg["phone"],
      "code": widget.arg["code"],
      "password": _pwd
    });
    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第三步"),
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdaptor.width(20.0)),
        children: <Widget>[
          Text(
            "请设置登录密码",
            style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
          ),
          Form(
            key: _form,
            child: JdFormInput(
              isPassword: true,
              maxLength: 10,
              onSaved: (val) {
                _pwd = val;
              },
              validator: (val) {
                return JdValidate.isPwdLegal(val)
                    ? null
                    : " 密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)";
              },
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
                    "注册",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenAdaptor.fz(18.0),
                        letterSpacing: 4.0),
                  ),
                  onPressed: () {
                    if (_form.currentState.validate()) {
                      _form.currentState.save();
                      _register().then((res) {
                        print(res);
                        if (res["success"]) {
                          user.setUserInfo(res["userinfo"][0]);
                          Navigator.of(context).pushReplacementNamed("/",
                              arguments: {"current": 3});
                        }
                      });
                    }
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
