import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_input.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/validate.dart';

class RegisterFirst extends StatefulWidget {
  RegisterFirst({Key key}) : super(key: key);

  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends State<RegisterFirst> {
  String _phone = "";

  Future _sendCode() async {
    var res = await JdAjax.post("/sendCode", {"tel": _phone});
    res = res.data;
    if (res["success"]) {
      Navigator.of(context)
          .pushNamed("/registersecond", arguments: {"phone": _phone});
    } else {
      JdToast.showShortMsg(res["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第一步"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenAdaptor.height(30.0),
            ),
            JdInput(
              inputVal: _phone,
              placeholder: "请输入手机号",
              maxLength: 11,
              formatters: [WhitelistingTextInputFormatter(RegExp(r"[0-9]"))],
              onChanged: (value) {
                setState(() {
                  _phone = value;
                });
              },
            ),
            SizedBox(
              height: ScreenAdaptor.height(100.0),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "下一步",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdaptor.fz(18.0),
                      letterSpacing: 4.0),
                ),
                onPressed: () {
                  if (JdValidate.isPhoneLegal(_phone)) {
                    _sendCode();
                  } else {
                    JdToast.showShortMsg("手机号码格式不正确");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
