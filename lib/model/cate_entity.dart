import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class CateEntity with JsonConvert<CateEntity> {
	List<CateResult> result;
}

class CateResult with JsonConvert<CateResult> {
	@JSONField(name: "_id")
	String sId;
	String title;
	String status;
	String pic;
	String pid;
	String sort;
}
