import 'package:jdlj/model/slider_entity.dart';

sliderEntityFromJson(SliderEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new List<SliderResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new SliderResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> sliderEntityToJson(SliderEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

sliderResultFromJson(SliderResult data, Map<String, dynamic> json) {
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
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	return data;
}

Map<String, dynamic> sliderResultToJson(SliderResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['title'] = entity.title;
	data['status'] = entity.status;
	data['pic'] = entity.pic;
	data['url'] = entity.url;
	return data;
}