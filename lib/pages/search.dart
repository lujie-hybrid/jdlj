/*
 * @author: lujie
 * @Date: 2020-07-30 10:49:07
 * @LastEditTime: 2020-07-30 16:54:20
 * @FilePath: \jdlj\lib\pages\search.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdlj/components/storage.dart';
import 'package:jdlj/screen.dart';

class JdSearch extends StatefulWidget {
  JdSearch({Key key}) : super(key: key);

  @override
  _JdSearchState createState() => _JdSearchState();
}

class _JdSearchState extends State<JdSearch> {
  TextEditingController _tec;

  List _historyList = [];
  int _historyListIndex = -1;

  @override
  void initState() {
    super.initState();
    _tec = new TextEditingController();
    _getSearchList();
  }

  void _getSearchList() {
    JdStorage.getStorage("searchList").then((String val) {
      setState(() {
        if (val.isEmpty) {
          _historyList = [];
        } else {
          _historyList = json.decode(val);
        }
      });
    });
  }

  void goToSearch(String value) {
    if (value.isEmpty) return;

    bool hasVal = _historyList.any((element) => element == value);
    if (!hasVal) {
      _historyList.add(value);
    }
    JdStorage.setStorage("searchList", json.encode(_historyList));
    Navigator.of(context)
        .pushReplacementNamed("/prolist", arguments: {"keywords": value});
  }

  Widget _getTitle() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(233, 233, 233, 0.9),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdaptor.width(30.0)))),
      width: ScreenAdaptor.screenWidth / 1.5,
      height: ScreenAdaptor.height(52.0),
      child: TextField(
        controller: _tec,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          goToSearch(value);
        },
        decoration: InputDecoration(
            suffixIcon: InkWell(
              child: Icon(
                Icons.clear,
                size: 20.0,
              ),
              onTap: () {
                _tec.clear();
              },
            ),
            hintText: "请输入要搜索的内容",
            hintStyle:
                TextStyle(color: Colors.grey, fontSize: ScreenAdaptor.fz(18.0)),
            contentPadding:
                EdgeInsets.fromLTRB(ScreenAdaptor.width(20.0), 0, 0, 0),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenAdaptor.width(30.0))))),
      ),
    );
  }

  Widget _getHotSearch() {
    const list = ["女装", "男装", "笔记本", "手机"];
    List<Widget> _children = list.map((item) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.all(ScreenAdaptor.width(20.0)),
          child: Text(item),
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.5),
              borderRadius: BorderRadius.circular(ScreenAdaptor.width(20.0))),
          padding: EdgeInsets.symmetric(
              vertical: ScreenAdaptor.height(10.0),
              horizontal: ScreenAdaptor.width(20.0)),
        ),
        onTap: () {
          goToSearch(item);
        },
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdaptor.width(20.0),
              ScreenAdaptor.width(20.0), ScreenAdaptor.width(20.0), 0),
          child: Text(
            "热门搜索",
            style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
          ),
        ),
        Wrap(
          children: _children,
        )
      ],
    );
  }

  _getHistoryList() {
    List<Widget> _children = [];
    for (int i = 0; i < _historyList.length; i++) {
      _children.add(ListTile(
        title: Text(_historyList[i]),
        onLongPress: () {
          setState(() {
            _historyListIndex = i;
          });
        },
        trailing: _historyListIndex == i
            ? IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black26,
                ),
                onPressed: () {
                  _historyList.removeAt(i);
                  JdStorage.setStorage("searchList", json.encode(_historyList))
                      .then((success) {
                    if (success) {
                      _getSearchList();
                      setState(() {
                        _historyListIndex = -1;
                      });
                    }
                  });
                },
              )
            : null,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdaptor.width(20.0),
              ScreenAdaptor.width(20.0), ScreenAdaptor.width(20.0), 0),
          child: Text(
            "历史记录",
            style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
          ),
        ),
        _historyList.length != 0
            ? Wrap(
                children: _children,
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(ScreenAdaptor.width(20.0),
                    ScreenAdaptor.width(20.0), ScreenAdaptor.width(20.0), 0),
                child: Text("暂无"),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _getTitle(),
        actions: <Widget>[
          InkWell(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "搜索",
                style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
              ),
              width: ScreenAdaptor.width(120.0),
            ),
            onTap: () {
              goToSearch(_tec.text);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _getHotSearch(),
          _getHistoryList(),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaptor.height(100.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenAdaptor.height(15.0),
                      horizontal: ScreenAdaptor.width(35.0)),
                  child: Text(
                    "清除历史记录",
                    style: TextStyle(fontSize: ScreenAdaptor.fz(18.0)),
                  ),
                  onPressed: () {
                    JdStorage.remove("searchList").then((success) {
                      if (success) {
                        _getSearchList();
                      }
                    });
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
