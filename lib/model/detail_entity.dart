import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class DetailEntity with JsonConvert<DetailEntity> {
  DetailResult result;
}

class DetailResult with JsonConvert<DetailResult> {
  @JSONField(name: "_id")
  String sId;
  String title;
  String cid;
  String price;
  @JSONField(name: "old_price")
  String oldPrice;
  @JSONField(name: "is_best")
  String isBest;
  @JSONField(name: "is_hot")
  String isHot;
  @JSONField(name: "is_new")
  String isNew;
  String status;
  String pic;
  String content;
  String cname;
  List<DetailResultAttr> attr;
  @JSONField(name: "sub_title")
  String subTitle;
  int salecount;
  int count;
  bool selected;
  String selectedAttr;
}

class DetailResultAttr with JsonConvert<DetailResultAttr> {
  String cate;
  @JSONField(name: "list")
  List<String> xList;
}
