import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_form_input.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/validate.dart';

class JdRegisterSecond extends StatefulWidget {
  final Map arg;
  JdRegisterSecond({Key key, this.arg}) : super(key: key);

  @override
  _JdRegisterSecondState createState() => _JdRegisterSecondState();
}

class _JdRegisterSecondState extends State<JdRegisterSecond> {
  bool _hasSend = true;

  int _times = 10;

  Timer _timer;

  String _code = "";

  _startCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _times--;
        if (_times == 0) {
          _hasSend = false;
          _times = 10;
          timer.cancel();
        }
      });
    });
  }

  Future _sendCode(Function successFn) async {
    var res = await JdAjax.post("/sendCode", {"tel": widget.arg["phone"]});
    print(res);
    res = res.data;
    if (res["success"]) {
      successFn();
    } else {
      JdToast.showShortMsg(res["message"]);
    }
  }

  Future _validateCode() async {
    print(_code);
    var res = await JdAjax.post(
        "/validateCode", {"tel": widget.arg["phone"], "code": _code});
    print(res.data);
    return res.data;
  }

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  GlobalKey<FormState> _form = new GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第二步"),
      ),
      body: ListView(
        padding: EdgeInsets.all(ScreenAdaptor.width(20.0)),
        children: <Widget>[
          Text(
            "请输入收到的验证码",
            style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
          ),
          Form(
            key: _form,
            child: Stack(
              children: <Widget>[
                JdFormInput(
                  maxLength: 4,
                  onSaved: (val) {
                    _code = val;
                  },
                  validator: (val) {
                    return JdValidate.isCodeLegal(val) ? null : "验证码必须是4位数字";
                  },
                ),
                Positioned(
                  right: ScreenAdaptor.width(20.0),
                  child: RaisedButton(
                    child: _hasSend
                        ? Text(
                            "$_times\s",
                            style: TextStyle(letterSpacing: 2.0),
                          )
                        : Text("重新发送"),
                    onPressed: _hasSend
                        ? null
                        : () {
                            _sendCode(() {
                              setState(() {
                                _hasSend = true;
                              });
                              _startCountDown();
                            });
                          },
                  ),
                )
              ],
            ),
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
                if (_form.currentState.validate()) {
                  _form.currentState.save();
                  _validateCode().then((res) {
                    if (res["success"]) {
                      Navigator.of(context).pushNamed("/registerover",
                          arguments: {
                            "phone": widget.arg["phone"],
                            "code": _code
                          });
                    } else {
                      JdToast.showShortMsg(res["message"]);
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
