import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_event_bus.dart'
    show JdEventBus, EbAddressList, EbOneAddressList;
import 'package:jdlj/components/storage.dart';
import 'package:jdlj/model/address_entity.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/sign.dart';

class JdAddressList extends StatefulWidget {
  JdAddressList({Key key}) : super(key: key);

  @override
  _JdAddressListState createState() => _JdAddressListState();
}

class _JdAddressListState extends State<JdAddressList> {
  String _radioGroupValue;

  Map _user;

  List<AddressResult> _list = [];

  @override
  void initState() {
    super.initState();
    _getAddressList();
    JdEventBus.listen<EbAddressList>((ev) {
      _getAddressList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    JdEventBus.fire(EbOneAddressList("返回刷新"));
  }

  Future _getAddressList() async {
    String val = await JdStorage.getStorage("userInfo");
    _user = json.decode(val);
    Map m = {"uid": _user["_id"], "salt": _user["salt"]};
    String sign = JdSign.getSign(m);
    print(sign);
    var res = await JdAjax.get("/addressList?uid=${_user['_id']}&sign=$sign");
    List<AddressResult> l = [];
    if (res.data["success"]) {
      print(res);
      AddressEntity ae = new AddressEntity();
      ae.fromJson(res.data);
      if (ae.result != null && ae.result.length > 0) {
        l = ae.result;
        setState(() {
          _list = l;
        });
        List<AddressResult> _arL =
            l.where((e) => e.defaultAddress == 1).toList();
        if (_arL.length > 0) {
          AddressResult item = _arL[0];
          _radioGroupValue = item.sId;
        } else {
          _changeDefaultAddress(l[0].sId);
        }
      }
    }
  }

  void _changeDefaultAddress(String id) async {
    Map m = {"uid": _user["_id"], "salt": _user["salt"], "id": id};
    String sign = JdSign.getSign(m);
    var res = await JdAjax.post(
        "/changeDefaultAddress", {"uid": _user["_id"], "id": id, "sign": sign});
    if (res.data["success"]) {
      _getAddressList();
    }
  }

  void _deleteAddress(String id) async {
    Map m = {"uid": _user["_id"], "salt": _user["salt"], "id": id};
    String sign = JdSign.getSign(m);
    var res = await JdAjax.post(
        "/deleteAddress", {"uid": _user["_id"], "id": id, "sign": sign});
    if (res.data["success"]) {
      Navigator.of(context).pop();
      _getAddressList();
    }
  }

  void _showModalDelete(String id) {
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            content: Text(
              "确定删除此地址么",
              style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("确认"),
                onPressed: () {
                  _deleteAddress(id);
                },
              ),
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _getBody() {
    return Stack(
      children: <Widget>[
        _list.length == 0
            ? Center(
                child: Text("暂无地址数据"),
              )
            : ListView.builder(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    onLongPress: () {
                      _showModalDelete(_list[i].sId);
                    },
                    leading: Radio(
                      groupValue: _radioGroupValue,
                      value: _list[i].sId,
                      onChanged: (value) {
                        _changeDefaultAddress(_list[i].sId);
                      },
                    ),
                    title: Text(_list[i].name),
                    subtitle: Text(_list[i].address),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/addressadd",
                            arguments: {"address": json.encode(_list[i])});
                      },
                    ),
                  );
                },
                padding: EdgeInsets.only(bottom: ScreenAdaptor.height(70.0)),
                itemCount: _list.length,
              ),
        Positioned(
          bottom: 0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/addressadd");
            },
            child: Container(
              height: ScreenAdaptor.height(70.0),
              width: ScreenAdaptor.screenWidth,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: ScreenAdaptor.width(10.0),
                  ),
                  Text(
                    "增加收货地址",
                    style: TextStyle(
                        color: Colors.white, fontSize: ScreenAdaptor.fz(22.0)),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收货地址列表"),
      ),
      body: _getBody(),
    );
  }
}
