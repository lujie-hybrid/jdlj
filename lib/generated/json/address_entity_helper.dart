import 'package:jdlj/model/address_entity.dart';

addressEntityFromJson(AddressEntity data, Map<String, dynamic> json) {
	if (json['success'] != null) {
		data.success = json['success'];
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['result'] != null) {
		data.result = new List<AddressResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new AddressResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> addressEntityToJson(AddressEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['success'] = entity.success;
	data['message'] = entity.message;
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

addressResultFromJson(AddressResult data, Map<String, dynamic> json) {
	if (json['_id'] != null) {
		data.sId = json['_id']?.toString();
	}
	if (json['uid'] != null) {
		data.uid = json['uid']?.toString();
	}
	if (json['name'] != null) {
		data.name = json['name']?.toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone']?.toString();
	}
	if (json['address'] != null) {
		data.address = json['address']?.toString();
	}
	if (json['default_address'] != null) {
		data.defaultAddress = json['default_address']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['add_time'] != null) {
		data.addTime = json['add_time']?.toInt();
	}
	return data;
}

Map<String, dynamic> addressResultToJson(AddressResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['phone'] = entity.phone;
	data['address'] = entity.address;
	data['default_address'] = entity.defaultAddress;
	data['status'] = entity.status;
	data['add_time'] = entity.addTime;
	return data;
}