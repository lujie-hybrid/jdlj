/*
 * @author: lujie
 * @Date: 2020-07-24 11:19:28
 * @LastEditTime: 2020-08-25 16:14:10
 * @FilePath: \jdlj\lib\tabs\category.dart
 * @descripttion: [desc]
 * @editor: [your git name]
 */
import 'package:flutter/material.dart';
import 'package:jdlj/config/Config.dart';
import 'package:jdlj/screen.dart';
import 'package:jdlj/model/cate_entity.dart';
import 'package:jdlj/components/ajax.dart';

class JdCategory extends StatefulWidget {
  JdCategory({Key key}) : super(key: key);

  @override
  _JdCategoryState createState() => _JdCategoryState();
}

class _JdCategoryState extends State<JdCategory>
    with AutomaticKeepAliveClientMixin {
  int _currentNavIndex = 0;
  List<CateResult> _ce;
  List<CateResult> _rightCe;

  // 获取左侧数据
  _getLeftData() async {
    var res = await JdAjax.get("/pcate");
    CateEntity ce = new CateEntity();
    ce.fromJson(res.data);
    setState(() {
      _ce = ce.result;
    });
    _getRightData(_ce[0].sId);
  }

  //获取右侧数据
  _getRightData(pid) async {
    var res = await JdAjax.get("/pcate?pid=$pid");
    CateEntity ce = new CateEntity();
    ce.fromJson(res.data);
    setState(() {
      _rightCe = ce.result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLeftData();
  }

  // 获取左边的导航
  Widget _getLeftNav() {
    if (_ce == null || _ce.length == 0)
      return Container(
        width: ScreenAdaptor.screenWidth / 4,
        height: double.infinity,
      );
    return Container(
      width: ScreenAdaptor.screenWidth / 4,
      height: double.infinity,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () {
              setState(() {
                _currentNavIndex = index;
              });
              _getRightData(_ce[index].sId);
            },
            child: Container(
              alignment: Alignment.center,
              height: ScreenAdaptor.height(100.0),
              color: _currentNavIndex == index
                  ? Colors.white
                  : Color.fromRGBO(240, 246, 246, 0.9),
              child: Text("${_ce[index].title}"),
            ),
          );
        },
        itemCount: _ce.length,
      ),
    );
  }

  // 获取右边列表

  Widget _getRightList(w, h) {
    if (_rightCe == null || _rightCe.length == 0)
      return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: ScreenAdaptor.height(10.0),
              horizontal: ScreenAdaptor.height(10.0)),
          height: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              SizedBox(
                width: ScreenAdaptor.width(10.0),
              ),
              Text(
                "加载中...",
                style: TextStyle(fontSize: ScreenAdaptor.fz(20.0)),
              )
            ],
          ),
          alignment: Alignment.center,
        ),
      );
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: ScreenAdaptor.height(10.0),
            horizontal: ScreenAdaptor.height(10.0)),
        height: double.infinity,
        child: GridView.builder(
            itemCount: _rightCe.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: w / h * 0.9,
                crossAxisSpacing: ScreenAdaptor.height(10.0),
                mainAxisSpacing: ScreenAdaptor.height(10.0)),
            itemBuilder: (ctx, index) {
              String url =
                  _rightCe[index].pic.replaceAll(new RegExp(r'\\'), '/');
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/prolist",
                      arguments: {"id": _rightCe[index].sId});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1))),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          "${JdConfig.domain}/$url",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: ScreenAdaptor.height(30.0),
                        child: Text(_rightCe[index].title),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double w =
        (ScreenAdaptor.screenWidth * 3 / 4 - ScreenAdaptor.width(40.0)) / 3;
    double h = w + ScreenAdaptor.height(30.0);
    return Row(
      children: <Widget>[_getLeftNav(), _getRightList(w, h)],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
