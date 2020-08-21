/*
 * @author: lujie
 * @Date: 2020-07-24 11:20:55
 * @LastEditTime: 2020-08-21 09:09:15
 * @FilePath: \jdlj\lib\tabs\cart.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/components/jdButton.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/detail_entity.dart';
import 'package:jdlj/provider/jd_provider.dart' show MCart, JdProvider, JdUser;
import 'package:jdlj/screen.dart';

class JdCart extends StatefulWidget {
  JdCart({Key key}) : super(key: key);

  @override
  _JdCartState createState() => _JdCartState();
}

class _JdCartState extends State<JdCart> with AutomaticKeepAliveClientMixin {
  bool _selectAll = false;

  List<DetailResult> list = [];

  Widget _getBottomWidget() {
    return Container(
      height: ScreenAdaptor.height(100.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
      padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              JdProvider.connect<MCart>(
                builder: (context, cartInner, child) {
                  _selectAll =
                      cartInner.cartList.every((element) => element.selected);
                  return Checkbox(
                    onChanged: (value) {
                      var allList = [];
                      allList = list.map((ele) {
                        ele.selected = value;
                        return ele;
                      }).toList();
                      setState(() {
                        _selectAll = value;
                        list = allList;
                      });
                      cartInner.computeAllPrice();
                    },
                    value: _selectAll,
                  );
                },
              ),
              Text("全选")
            ],
          ),
          JdProvider.connect<MCart>(
            builder: (context, value, child) {
              return Text(
                "\$${value.allPrice}",
                style: TextStyle(
                    color: Colors.red, fontSize: ScreenAdaptor.fz(24.0)),
              );
            },
          ),
          JdProvider.connect2<JdUser, MCart>(
            builder: (context, _, _m, child) {
              return JdButton(
                bgColor: Colors.red,
                buttonText: "结算",
                borderRadius: 0,
                style: TextStyle(color: Colors.white),
                onPress: () {
                  if (_.userinfo == null) {
                    JdToast.showShortMsg("您还没有登录，请先登录");
                    Navigator.of(context).pushNamed("/login");
                  } else {
                    _m.getSelectedCart();
                    _m.computeAllPrice();
                    if (_m.selectedList.length > 0) {
                      Navigator.of(context).pushNamed("/balance");
                    } else {
                      JdToast.showShortMsg("请先选择商品");
                    }
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _getCartList(List<DetailResult> list) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        String str = list[index].pic.replaceAll(new RegExp(r'\\'), '/');
        Widget result = Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: index != 9
                      ? BorderSide(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1))
                      : BorderSide.none)),
          padding: EdgeInsets.symmetric(
              horizontal: ScreenAdaptor.width(20.0),
              vertical: ScreenAdaptor.height(10.0)),
          child: Row(
            children: <Widget>[
              JdProvider.connect<MCart>(
                builder: (context, mcart, child) {
                  return Checkbox(
                    value: list[index].selected,
                    onChanged: (value) {
                      setState(() {
                        list[index].selected = value;
                        bool allSelect =
                            list.every((element) => element.selected);
                        _selectAll = allSelect;
                      });
                      mcart.computeAllPrice();
                    },
                  );
                },
              ),
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
                        list[index].title,
                        style: TextStyle(fontSize: ScreenAdaptor.fz(24.0)),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        list[index].selectedAttr,
                        style: TextStyle(fontSize: ScreenAdaptor.fz(18.0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "\$${list[index].price}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenAdaptor.fz(20.0)),
                          ),
                          Text("数量：${list[index].count}")
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
        if (index == list.length - 1) {
          return Column(
            children: <Widget>[
              result,
              SizedBox(
                height: ScreenAdaptor.height(100.0),
              )
            ],
          );
        } else {
          return result;
        }
      },
      itemCount: list.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    list = JdProvider.value<MCart>(context).cartList;
    if (list.length == 0)
      return Center(
        child: Text("购物车空空的"),
      );
    return Stack(
      children: <Widget>[
        _getCartList(list),
        Positioned(
          child: _getBottomWidget(),
          bottom: 0,
          width: ScreenAdaptor.screenWidth,
        )
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
