import 'package:jdlj/model/cate_entity.dart';

cateEntityFromJson(CateEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new List<CateResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new CateResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> cateEntityToJson(CateEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

cateResultFromJson(CateResult data, Map<String, dynamic> json) {
	if (json['_id'] != null) {
		data.sId = json['_id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['pic'] != null) {
		data.pic = json['pic']?.toString();
	}
	if (json['pid'] != null) {
		data.pid = json['pid']?.toString();
	}
	if (json['sort'] != null) {
		data.sort = json['sort']?.toString();
	}
	return data;
}

Map<String, dynamic> cateResultToJson(CateResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['title'] = entity.title;
	data['status'] = entity.status;
	data['pic'] = entity.pic;
	data['pid'] = entity.pid;
	data['sort'] = entity.sort;
	return data;
}