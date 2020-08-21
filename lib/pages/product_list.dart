/*
 * @author: lujie
 * @Date: 2020-07-28 15:23:52
 * @LastEditTime: 2020-08-03 13:53:13
 * @FilePath: \jdlj\lib\pages\product_list.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/model/list_entity.dart';
import 'package:jdlj/screen.dart';

class JdProductList extends StatefulWidget {
  final Map arg;
  JdProductList({Key key, this.arg}) : super(key: key);

  @override
  _JdProductListState createState() => _JdProductListState();
}

class _JdProductListState extends State<JdProductList> {
  List<ListResult> _le = [];

  int page = 1; // 当前页

  int pageSize = 10; //每页数量

  String _sort = ""; // price_1 price_-1

  List<Map<String, dynamic>> _filters = [
    {'id': 0, 'name': '综合'},
    {'id': 1, 'name': '销量', 'sort': 0},
    {
      'id': 2,
      'name': '价格',
      'sort': 0,
    },
    {
      'id': 3,
      'name': '筛选',
    },
  ];

  int _filterIndex = 0; //选择排序的index

  bool _isLoading = false; // 列表是否在请求接口

  bool _toEnd = false; // 是否到底了

  ScrollController _sc = new ScrollController();

  _getListData() async {
    if (_isLoading || _toEnd) return;
    _isLoading = true;
    switch (_filterIndex) {
      case 1:
        _sort = _filters[_filterIndex]["sort"] == 0
            ? 'salecount_1'
            : 'salecount_-1';
        break;
      case 2:
        _sort = _filters[_filterIndex]["sort"] == 0 ? 'price_1' : 'price_-1';
        break;
      default:
        _sort = "";
        break;
    }
    String url = "";
    if (widget.arg['id'] != null) {
      url =
          "/plist?cid=${widget.arg['id']}&page=$page&pageSize=$pageSize&sort=$_sort";
    } else if (widget.arg['keywords'] != null) {
      url =
          "/plist?page=$page&pageSize=$pageSize&sort=$_sort&search=${widget.arg['keywords']}";
    }
    var res = await JdAjax.get(url);
    ListEntity le = new ListEntity();
    le.fromJson(res.data);
    if (le.result.length < pageSize) {
      setState(() {
        _le.addAll(le.result);
        _toEnd = true;
      });
    } else {
      setState(() {
        _le.addAll(le.result);
        page += 1;
      });
    }
    _isLoading = false;
  }

  List<Widget> _getTabs() {
    List<Widget> list = [];
    for (int i = 0; i < _filters.length; i++) {
      list.add(Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            _isLoading = false;
            setState(() {
              _filterIndex = _filters[i]['id'];
              if (_filters[i]['sort'] != null) {
                _filters[i]['sort'] = _filters[i]['sort'] == 0 ? 1 : 0;
              }
              _toEnd = false;
              page = 1;
              _le = [];
            });
            _sc.jumpTo(0);
            _getListData();
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _filters[i]['name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _filterIndex == _filters[i]['id']
                          ? Colors.red
                          : Colors.black45,
                      fontSize: ScreenAdaptor.fz(20.0)),
                ),
                _filters[i]['sort'] != null && _filterIndex == _filters[i]['id']
                    ? Icon(
                        _filters[i]['sort'] == 0
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: _filterIndex == _filters[i]['id']
                            ? Colors.red
                            : Colors.black45,
                      )
                    : Text("")
              ],
            ),
            alignment: Alignment.center,
          ),
        ),
      ));
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListData();
    _sc.addListener(() {
      if (_sc.position.pixels > _sc.position.maxScrollExtent - 100) {
        setState(() {});
        _getListData();
      }
    });
  }

  Future<void> _refreshData() async {
    _isLoading = false;
    setState(() {
      _toEnd = false;
      page = 1;
      _le.clear();
    });
    await _getListData();
  }

  // 刻画列表
  Widget _getList() {
    if (_le.length == 0)
      return Container(
        alignment: Alignment.center,
        child: Text("暂无数据"),
      );
    return ListView.builder(
      controller: _sc,
      itemBuilder: (ctx, i) {
        String url = _le[i].pic.replaceAll(new RegExp(r'\\'), '/');
        if (i == _le.length - 1) {
          if (_toEnd) {
            return Column(
              children: <Widget>[
                _listItemWidget(url, _le[i]),
                Container(
                  width: double.infinity,
                  height: ScreenAdaptor.height(80.0),
                  alignment: Alignment.center,
                  child: Text("------我是有底线的------"),
                )
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                _listItemWidget(url, _le[i]),
                _loadingCircle()
              ],
            );
          }
        } else {
          return _listItemWidget(url, _le[i]);
        }
      },
      itemCount: _le.length,
    );
  }

  Widget _listItemWidget(String url, ListResult item) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/prodetail", arguments: {"id": item.sId});
      },
      child: Container(
        padding: EdgeInsets.all(ScreenAdaptor.width(10.0)),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
        child: Row(
          children: <Widget>[
            Image.network(
              "${JdConfig.domain}/$url",
              fit: BoxFit.cover,
              width: ScreenAdaptor.width(180.0),
              height: ScreenAdaptor.height(180.0),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: ScreenAdaptor.height(180.0),
                margin: EdgeInsets.only(left: ScreenAdaptor.width(30.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(fontSize: ScreenAdaptor.fz(22.0)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      "\$${item.oldPrice}",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: ScreenAdaptor.fz(18.0)),
                    ),
                    Text(
                      "\$${item.price}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenAdaptor.fz(20.0),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loadingCircle() {
    return Container(
      width: double.infinity,
      height: ScreenAdaptor.height(80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenAdaptor.width(30.0)),
            width: ScreenAdaptor.width(30.0),
            height: ScreenAdaptor.height(30.0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          Text("加载中...")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("商品列表"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: ScreenAdaptor.height(80.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0))),
              child: Row(
                children: _getTabs(),
              ),
            ),
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: _getList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
