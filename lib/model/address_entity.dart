import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class AddressEntity with JsonConvert<AddressEntity> {
	bool success;
	String message;
	List<AddressResult> result;
}

class AddressResult with JsonConvert<AddressResult> {
	@JSONField(name: "_id")
	String sId;
	String uid;
	String name;
	String phone;
	String address;
	@JSONField(name: "default_address")
	int defaultAddress;
	int status;
	@JSONField(name: "add_time")
	int addTime;
}
