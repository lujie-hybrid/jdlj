import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jdButton.dart';
import 'package:jdlj/components/jd_event_bus.dart'
    show JdEventBus, EbOneAddressList;
import 'package:jdlj/components/storage.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/address_entity.dart';
import 'package:jdlj/model/detail_entity.dart';
import 'package:jdlj/provider/jd_provider.dart' show JdProvider, MCart;
import 'package:jdlj/screen.dart';
import 'package:jdlj/utils/sign.dart';

class JdBalance extends StatefulWidget {
  JdBalance({Key key}) : super(key: key);

  @override
  _JdBalanceState createState() => _JdBalanceState();
}

class _JdBalanceState extends State<JdBalance> {
  Map _user;

  AddressResult _ar;

  List<DetailResult> list = [];

  double _allPrice = 0;

  @override
  void initState() {
    super.initState();
    _getAddressList();
    JdEventBus.listen<EbOneAddressList>((ev) {
      _getAddressList();
    });
  }

  Widget _getAddressMsg() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenAdaptor.height(15.0)),
      child: ListTile(
        leading: Icon(
          Icons.add_location,
          color: Colors.grey,
          size: ScreenAdaptor.fz(36.0),
        ),
        title: _ar == null
            ? Text(
                "请添加收货地址",
                style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${_ar.name} ${_ar.phone}"),
                  Text(
                    _ar.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("/addresslist");
          },
        ),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
    );
  }

  Widget _getCartItem(DetailResult item) {
    String str = item.pic.replaceAll(new RegExp(r'\\'), '/');
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenAdaptor.width(20.0),
          vertical: ScreenAdaptor.height(10.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdaptor.width(150.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                "${JdConfig.domain}/$str",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: ScreenAdaptor.width(20.0),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: ScreenAdaptor.width(120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    item.title,
                    style: TextStyle(fontSize: ScreenAdaptor.fz(24.0)),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.selectedAttr,
                    style: TextStyle(fontSize: ScreenAdaptor.fz(18.0)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "\$${item.price}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdaptor.fz(20.0)),
                      ),
                      Text("数量：${item.count}")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getBottomWidget() {
    return Container(
      height: ScreenAdaptor.height(90.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
      padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          JdProvider.connect<MCart>(
            builder: (context, value, child) {
              return Text(
                "实付款：\$${value.allPrice}",
                style: TextStyle(
                    color: Colors.red, fontSize: ScreenAdaptor.fz(20.0)),
              );
            },
          ),
          JdProvider.connect<MCart>(
            builder: (context, _m, child) {
              return JdButton(
                bgColor: Colors.red,
                buttonText: "立即下单",
                borderRadius: 0,
                style: TextStyle(color: Colors.white),
                onPress: () {
                  _orderProduct(_m);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _getAddressList() async {
    String val = await JdStorage.getStorage("userInfo");
    _user = json.decode(val);
    Map m = {"uid": _user["_id"], "salt": _user["salt"]};
    String sign = JdSign.getSign(m);
    print(sign);
    var res =
        await JdAjax.get("/oneAddressList?uid=${_user['_id']}&sign=$sign");
    if (res.data["success"]) {
      AddressEntity ae = new AddressEntity();
      ae.fromJson(res.data);
      setState(() {
        _ar = ae.result != null && ae.result.length > 0 ? ae.result[0] : null;
      });
    }
  }

  void _orderProduct(MCart _m) async {
    Map m = {
      "uid": _user["_id"],
      "phone": _ar.phone,
      "address": _ar.address,
      "name": _ar.name,
      "products": json.encode(list),
      "all_price": _allPrice.toStringAsFixed(1),
      "salt": _user["salt"]
    };
    String sign = JdSign.getSign(m);
    var res = await JdAjax.post("/doOrder", {
      "uid": _user["_id"],
      "phone": _ar.phone,
      "address": _ar.address,
      "name": _ar.name,
      "products": json.encode(list),
      "all_price": _allPrice.toStringAsFixed(1),
      "sign": sign
    });
    print(res.data);
    if (res.data["success"]) {
      _m.deleteSelectCart();
      Navigator.of(context).pushNamed("/pay");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("结算"),
      ),
      body: Stack(
        children: <Widget>[
          JdProvider.connect<MCart>(
            builder: (context, _, child) {
              list = _.selectedList;
              _allPrice = _.allPrice;
              var result = list.map((ele) {
                return _getCartItem(ele);
              }).toList();
              return ListView(
                children: <Widget>[
                  _getAddressMsg(),
                  ...result,
                  SizedBox(
                    height: ScreenAdaptor.height(90.0),
                  )
                ],
              );
            },
          ),
          Positioned(
            child: _getBottomWidget(),
            bottom: 0,
            width: ScreenAdaptor.screenWidth,
          )
        ],
      ),
    );
  }
}
