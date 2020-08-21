import 'package:flutter/material.dart';
import 'package:jdlj/components/ajax.dart';
import 'package:jdlj/components/jd_toast.dart';
import 'package:jdlj/screen.dart';
import 'package:tobias/tobias.dart' as alipay;

class JdPay extends StatefulWidget {
  JdPay({Key key}) : super(key: key);

  @override
  _JdPayState createState() => _JdPayState();
}

class _JdPayState extends State<JdPay> {
  String _radioVal = "ali";

  String _payInfo = "";

  // Map _payResult;

  bool _hasInstallAli;

  _getPayInfo() async {
    var res = await JdAjax.get("http://agent.itying.com/alipay/");
    _payInfo = res.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPayInfo();

    _hasInstallAliPay();
  }

  _hasInstallAliPay() async {
    bool msg = await alipay.isAliPayInstalled();
    _hasInstallAli = msg;
  }

  callAlipay() async {
    if (!_hasInstallAli) {
      JdToast.showShortMsg("请先安装支付宝");
      return;
    }
    Map payResult;
    try {
      payResult = await alipay.aliPay(_payInfo);
      print("--->$payResult");
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (payResult["resultStatus"] == "6001") {
      JdToast.showShortMsg("支付未完成");
    } else if (payResult["resultStatus"] == "9000" &&
        payResult["result"] != null) {
      JdToast.showShortMsg("支付成功");
      Navigator.of(context)
          .pushReplacementNamed("/order", arguments: {"isPay": true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单支付"),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: ScreenAdaptor.width(20.0)),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
              padding:
                  EdgeInsets.symmetric(vertical: ScreenAdaptor.height(15.0)),
              child: RadioListTile(
                value: "ali",
                onChanged: (value) {
                  setState(() {
                    _radioVal = value;
                  });
                },
                title: Row(
                  children: <Widget>[
                    Image.network(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597905547494&di=733ee8918ff65058ac3dca2be33e1999&imgtype=0&src=http%3A%2F%2Fimages.liqucn.com%2Fimg%2Fh98%2Fh68%2Fimg_localize_5c99370f90e200b4e95c155ba5843364_560x350.jpg",
                      width: ScreenAdaptor.width(100.0),
                    ),
                    Text("支付宝支付")
                  ],
                ),
                groupValue: _radioVal,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)))),
              padding:
                  EdgeInsets.symmetric(vertical: ScreenAdaptor.height(15.0)),
              child: RadioListTile(
                value: "wx",
                onChanged: (value) {
                  setState(() {
                    _radioVal = value;
                  });
                },
                title: Row(
                  children: <Widget>[
                    Image.network(
                      "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=376802492,2339279792&fm=26&gp=0.jpg",
                      width: ScreenAdaptor.width(100.0),
                    ),
                    Text("微信支付")
                  ],
                ),
                groupValue: _radioVal,
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
                  "支付",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenAdaptor.fz(18.0),
                      letterSpacing: 4.0),
                ),
                onPressed: () {
                  callAlipay();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
