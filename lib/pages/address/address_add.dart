import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_city_picker.dart';
import 'package:jdlj/components/jd_event_bus.dart'
    show JdEventBus, EbAddressList;
import 'package:jdlj/components/jd_form_input.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, JdUser;
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/sign.dart';
import 'package:jdlj/utils/validate.dart';

class JdAddressAdd extends StatefulWidget {
  final Map arg;
  JdAddressAdd({Key key, this.arg}) : super(key: key);

  @override
  _JdAddressAddState createState() => _JdAddressAddState();
}

class _JdAddressAddState extends State<JdAddressAdd> {
  String _cityText = "省/市/区";
  String _username = "";
  String _tel = "";
  String _addressmore = "";
  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  Map _msg;
  String _id;

  void _addAddress(Map<String, dynamic> dt) async {
    var res = await JdAjax.post("/addAddress", dt);
    if (res.data["success"]) {
      JdEventBus.fire(EbAddressList("列表更新"));
      Navigator.of(context).pop();
    }
  }

  void _editAddress(Map<String, dynamic> dt) async {
    var res = await JdAjax.post("/editAddress", dt);
    print(res);
    if (res.data["success"]) {
      JdEventBus.fire(EbAddressList("列表更新"));
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.arg != null) {
      _msg = json.decode(widget.arg["address"]);
      print(_msg);
      _username = _msg["name"];
      _tel = _msg["phone"];
      _addressmore = _msg["address"];
      _id = _msg["_id"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.arg != null ? Text("修改收货地址") : Text("新增收货地址"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenAdaptor.width(20.0),
              vertical: ScreenAdaptor.height(15.0)),
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  JdFormInput(
                    initialValue: _username,
                    placeholder: "收件人姓名",
                    maxLength: 10,
                    onSaved: (val) {
                      _username = val;
                    },
                    validator: (val) {
                      return val.isNotEmpty && JdValidate.isNameLegal(val)
                          ? null
                          : "姓名必须是汉字";
                    },
                  ),
                  JdFormInput(
                    maxLength: 11,
                    initialValue: _tel,
                    placeholder: "收件人电话号码",
                    onSaved: (val) {
                      _tel = val;
                    },
                    validator: (val) {
                      return JdValidate.isPhoneLegal(val) ? null : "电话号码格式不正确";
                    },
                  ),
                  InkWell(
                    onTap: () {
                      JdCityPicker.showCities(context).then((value) {
                        print(value);
                        setState(() {
                          _cityText =
                              "${value.provinceName}/${value.cityName}/${value.areaName}";
                        });
                      });
                    },
                    child: Container(
                      height: ScreenAdaptor.height(80.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add_location,
                            color: Colors.grey,
                            size: ScreenAdaptor.fz(32.0),
                          ),
                          SizedBox(
                            width: ScreenAdaptor.width(6.0),
                          ),
                          Text(
                            _cityText,
                            style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(0, 0, 0, 0.1)))),
                    ),
                  ),
                  JdFormInput(
                    initialValue: _addressmore,
                    placeholder: "详细地址",
                    isArea: true,
                    maxLength: 50,
                    validator: (val) {
                      return val.isNotEmpty ? null : "信息不能为空";
                    },
                    onSaved: (val) {
                      _addressmore = val;
                    },
                  ),
                  SizedBox(
                    height: ScreenAdaptor.height(80.0),
                  ),
                  JdProvider.connect<JdUser>(
                    builder: (context, _, child) {
                      return FractionallySizedBox(
                        widthFactor: 0.8,
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text(
                            "确认",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdaptor.fz(18.0),
                                letterSpacing: 4.0),
                          ),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              if (_cityText == "省/市/区") {
                                JdToast.showShortMsg("请选择省/市/区");
                                return;
                              }
                              print(_.userinfo);
                              if (widget.arg != null) {
                                Map m = {
                                  "uid": _.userinfo["_id"],
                                  "name": _username,
                                  "phone": _tel,
                                  "id": _id,
                                  "address": "$_cityText$_addressmore",
                                  "salt": _.userinfo["salt"]
                                };
                                String sign = JdSign.getSign(m);
                                _editAddress({
                                  "uid": _.userinfo["_id"],
                                  "name": _username,
                                  "phone": _tel,
                                  "id": _id,
                                  "address": "$_cityText$_addressmore",
                                  "sign": sign
                                });
                              } else {
                                Map m = {
                                  "uid": _.userinfo["_id"],
                                  "name": _username,
                                  "phone": _tel,
                                  "address": "$_cityText$_addressmore",
                                  "salt": _.userinfo["salt"]
                                };
                                String sign = JdSign.getSign(m);
                                _addAddress({
                                  "uid": _.userinfo["_id"],
                                  "name": _username,
                                  "phone": _tel,
                                  "address": "$_cityText$_addressmore",
                                  "sign": sign
                                });
                              }
                            }
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
