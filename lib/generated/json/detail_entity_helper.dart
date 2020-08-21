import 'package:jdlj/model/detail_entity.dart';

detailEntityFromJson(DetailEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new DetailResult().fromJson(json['result']);
	}
	return data;
}

Map<String, dynamic> detailEntityToJson(DetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] = entity.result.toJson();
	}
	return data;
}

detailResultFromJson(DetailResult data, Map<String, dynamic> json) {
	if (json['_id'] != null) {
		data.sId = json['_id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['cid'] != null) {
		data.cid = json['cid']?.toString();
	}
	if (json['price'] != null) {
		data.price = json['price']?.toString();
	}
	if (json['old_price'] != null) {
		data.oldPrice = json['old_price']?.toString();
	}
	if (json['is_best'] != null) {
		data.isBest = json['is_best']?.toString();
	}
	if (json['is_hot'] != null) {
		data.isHot = json['is_hot']?.toString();
	}
	if (json['is_new'] != null) {
		data.isNew = json['is_new']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['pic'] != null) {
		data.pic = json['pic']?.toString();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['cname'] != null) {
		data.cname = json['cname']?.toString();
	}
	if (json['attr'] != null) {
		data.attr = new List<DetailResultAttr>();
		(json['attr'] as List).forEach((v) {
			data.attr.add(new DetailResultAttr().fromJson(v));
		});
	}
	if (json['sub_title'] != null) {
		data.subTitle = json['sub_title']?.toString();
	}
	if (json['salecount'] != null) {
		data.salecount = json['salecount']?.toInt();
	}
	if (json['count'] != null) {
		data.count = json['count']?.toInt();
	}
	if (json['selected'] != null) {
		data.selected = json['selected'];
	}
	if (json['selectedAttr'] != null) {
		data.selectedAttr = json['selectedAttr']?.toString();
	}
	return data;
}

Map<String, dynamic> detailResultToJson(DetailResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['title'] = entity.title;
	data['cid'] = entity.cid;
	data['price'] = entity.price;
	data['old_price'] = entity.oldPrice;
	data['is_best'] = entity.isBest;
	data['is_hot'] = entity.isHot;
	data['is_new'] = entity.isNew;
	data['status'] = entity.status;
	data['pic'] = entity.pic;
	data['content'] = entity.content;
	data['cname'] = entity.cname;
	if (entity.attr != null) {
		data['attr'] =  entity.attr.map((v) => v.toJson()).toList();
	}
	data['sub_title'] = entity.subTitle;
	data['salecount'] = entity.salecount;
	data['count'] = entity.count;
	data['selected'] = entity.selected;
	data['selectedAttr'] = entity.selectedAttr;
	return data;
}

detailResultAttrFromJson(DetailResultAttr data, Map<String, dynamic> json) {
	if (json['cate'] != null) {
		data.cate = json['cate']?.toString();
	}
	if (json['list'] != null) {
		data.xList = json['list']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> detailResultAttrToJson(DetailResultAttr entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cate'] = entity.cate;
	data['list'] = entity.xList;
	return data;
}