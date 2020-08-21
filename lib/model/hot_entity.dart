import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class HotEntity with JsonConvert<HotEntity> {
	List<HotResult> result;
}

class HotResult with JsonConvert<HotResult> {
	@JSONField(name: "_id")
	String sId;
	String title;
	String cid;
	int price;
	@JSONField(name: "old_price")
	String oldPrice;
	String pic;
	@JSONField(name: "s_pic")
	String sPic;
}
