import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class SliderEntity with JsonConvert<SliderEntity> {
	List<SliderResult> result;
}

class SliderResult with JsonConvert<SliderResult> {
	@JSONField(name: "_id")
	String sId;
	String title;
	String status;
	String pic;
	String url;
}
