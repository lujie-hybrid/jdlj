import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/storage.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/order_entity.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/sign.dart';

class JdOrder extends StatefulWidget {
  final Map arg;
  JdOrder({Key key, this.arg}) : super(key: key);

  @override
  _JdOrderState createState() => _JdOrderState();
}

class _JdOrderState extends State<JdOrder> {
  Map _user;

  List<OrderResult> _orList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListData();
  }

  void _getListData() async {
    String val = await JdStorage.getStorage("userInfo");
    _user = json.decode(val);
    Map m = {"uid": _user["_id"], "salt": _user["salt"]};
    String sign = JdSign.getSign(m);
    var res = await JdAjax.get("/orderList?uid=${_user['_id']}&sign=$sign");
    if (res.data["success"]) {
      OrderEntity oe = new OrderEntity();
      oe.fromJson(res.data);
      setState(() {
        _orList = oe.result;
      });
    }
  }

  Widget _getList() {
    if (_orList.length == 0)
      return Center(
        child: Text("暂无订单"),
      );
    return ListView.builder(
      itemBuilder: (ctx, i) {
        OrderResult or = _orList[i];
        List<Widget> cont = [];
        if (or.orderItem != null && or.orderItem.length > 0) {
          cont = or.orderItem.map((ele) {
            String url = ele.productImg.replaceAll(new RegExp(r'\\'), '/');
            return Container(
              height: ScreenAdaptor.height(160.0),
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
              child: Row(
                children: <Widget>[
                  Image.network(
                    "${JdConfig.domain}/$url",
                    height: ScreenAdaptor.height(100.0),
                  ),
                  SizedBox(
                    width: ScreenAdaptor.width(10.0),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        ele.productTitle,
                        maxLines: 2,
                        style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "价格：${ele.productPrice}",
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        "数量：${ele.productCount}",
                        style: TextStyle(color: Colors.black45),
                      )
                    ],
                  )
                ],
              ),
            );
          }).toList();
        }

        return Card(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1.0))),
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(16.0)),
                alignment: Alignment.centerLeft,
                child: Text("订单编号：${_orList[i].sId}"),
                height: ScreenAdaptor.height(80.0),
              ),
              ...cont,
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(24.0)),
                height: ScreenAdaptor.height(80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "合计：${_orList[i].allPrice}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenAdaptor.fz(20.0),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: _orList.length,
      padding: EdgeInsets.all(ScreenAdaptor.width(20.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.arg != null && widget.arg["isPay"]) {
              Navigator.of(context)..pop()..pop();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text("我的订单"),
      ),
      body: _getList(),
    );
  }
}
