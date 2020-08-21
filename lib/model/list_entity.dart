import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class ListEntity with JsonConvert<ListEntity> {
  List<ListResult> result;
}

class ListResult with JsonConvert<ListResult> {
  @JSONField(name: "_id")
  String sId;
  String title;
  String cid;
  String price;
  @JSONField(name: "old_price")
  String oldPrice;
  String pic;
  @JSONField(name: "s_pic")
  String sPic;
}
