/*
 * @author: lujie
 * @Date: 2020-07-31 17:18:03
 * @LastEditTime: 2020-08-21 17:03:03
 * @FilePath: \jdlj\lib\pages\detail\prod_detail.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/components/jdButton.dart';
import 'package:jdlj/components/jd_counter.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/detail_entity.dart';
import 'package:jdlj/provider/jd_provider.dart';
import 'package:jdlj/screen.dart';

class JdProdInnerDetail extends StatefulWidget {
  final DetailResult dr;
  JdProdInnerDetail({Key key, this.dr}) : super(key: key);

  @override
  JdProdInnerDetailState createState() => JdProdInnerDetailState();
}

class JdProdInnerDetailState extends State<JdProdInnerDetail> {
  List<int> _selectIndexList = [];

  String _selectText;

  int _selectCount = 1;

  @override
  void initState() {
    super.initState();
  }

  String _getAttrString(List<DetailResultAttr> attr, {bool isInit = true}) {
    if (attr == null || attr.length == 0) return "";
    List msg = [];
    if (isInit) {
      attr.forEach((element) {
        msg.add(element.xList[0]);
      });
    } else {
      for (int i = 0; i < _selectIndexList.length; i++) {
        msg.add(attr[i].xList[_selectIndexList[i]]);
      }
    }
    return msg.join("，");
  }

  Widget _getSheetContent(
      List<DetailResultAttr> attr, setInnerState, bool noAttr) {
    if (_selectIndexList.length == 0) {
      _selectIndexList.length = attr.length;
      _selectIndexList.fillRange(0, attr.length, 0);
    }
    List<Widget> list = [];
    if (!noAttr) {
      list = List.generate(attr.length, (index) {
        List<Widget> xList = List.generate(attr[index].xList.length, (i) {
          var innerList = attr[index].xList;
          return Padding(
            padding: EdgeInsets.only(right: ScreenAdaptor.width(30.0)),
            child: InkWell(
              onTap: () {
                setInnerState(() {
                  _selectIndexList[index] = i;
                });
              },
              child: Chip(
                label: Text(
                  innerList[i],
                  style: TextStyle(
                      color: i == _selectIndexList[index]
                          ? Colors.white
                          : Colors.black),
                ),
                backgroundColor: i == _selectIndexList[index]
                    ? Colors.red
                    : Color.fromRGBO(0, 0, 0, 0.2),
                labelPadding:
                    EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(30.0)),
              ),
            ),
          );
        });
        return Row(
          children: <Widget>[
            SizedBox(
              width: ScreenAdaptor.width(100.0),
              child: Text(
                attr[index].cate,
                style: TextStyle(
                    fontSize: ScreenAdaptor.fz(22.0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: ScreenAdaptor.width(50.0),
            ),
            Expanded(
              flex: 1,
              child: Wrap(children: xList),
            )
          ],
        );
      });
    }

    return Container(
      width: ScreenAdaptor.screenWidth,
      height: ScreenAdaptor.height(500.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenAdaptor.screenWidth / 10,
                vertical: ScreenAdaptor.height(30.0)),
            child: ListView(
              children: <Widget>[
                ...list,
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenAdaptor.width(150.0),
                      child: Text(
                        "数量：",
                        style: TextStyle(
                            fontSize: ScreenAdaptor.fz(22.0),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    JdCounter(
                      initialValue: _selectCount,
                      decimalPlaces: 0,
                      minValue: 1,
                      maxValue: 100,
                      onChanged: (value) {
                        setInnerState(() {
                          _selectCount = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenAdaptor.height(80.0),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdaptor.screenWidth,
            height: ScreenAdaptor.height(80.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenAdaptor.screenWidth / 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  JdProvider.connect<MCart>(
                    builder: (context, _, child) {
                      return JdButton(
                        width: ScreenAdaptor.screenWidth / 3,
                        buttonText: "加入购物车",
                        bgColor: Colors.red,
                        style: TextStyle(color: Colors.white),
                        onPress: () {
                          _.addToCart(widget.dr, _selectCount,
                              _getAttrString(widget.dr.attr, isInit: false));
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                  JdButton(
                    width: ScreenAdaptor.screenWidth / 3,
                    buttonText: "立即购买",
                    bgColor: Colors.orange,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showModal(DetailResult _dr, {bool noAttr = false}) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (c, setInnerState) {
              return _getSheetContent(_dr.attr, setInnerState, noAttr);
            },
          );
        }).then((value) {
      setState(() {
        _selectText = _getAttrString(_dr.attr, isInit: false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dr == null) return Text("");
    String url = widget.dr.pic.replaceAll(new RegExp(r'\\'), '/');
    DetailResult _dr = widget.dr;
    if (_selectText == null) _selectText = _getAttrString(_dr.attr);
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            "${JdConfig.domain}/$url",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(ScreenAdaptor.width(20.0)),
          child: Column(
            children: <Widget>[
              Text(
                _dr.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: ScreenAdaptor.fz(26.0),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              _dr.subTitle != null
                  ? SizedBox(
                      height: ScreenAdaptor.height(10.0),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              _dr.subTitle != null
                  ? Text(
                      _dr.subTitle,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenAdaptor.fz(20.0),
                        color: Colors.black45,
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(
                height: ScreenAdaptor.height(20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("特价："),
                        Text("\$${_dr.price}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenAdaptor.fz(28.0),
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text("原价："),
                        Text("\$${_dr.oldPrice}",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ))
                      ],
                    ),
                  )
                ],
              ),
              _dr.attr == null || _dr.attr?.length == 0
                  ? SizedBox(
                      height: 0,
                    )
                  : InkWell(
                      child: Container(
                        height: ScreenAdaptor.height(70.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.black12))),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "已选：",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _selectText,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showModal(_dr);
                      },
                    ),
              Container(
                height: ScreenAdaptor.height(70.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black12))),
                child: Row(
                  children: <Widget>[
                    Text(
                      "厂商：",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_dr.cname}",
                    )
                  ],
                ),
              ),
              Container(
                height: ScreenAdaptor.height(70.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black12))),
                child: Row(
                  children: <Widget>[
                    Text(
                      "销量：",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${_dr.salecount}",
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
