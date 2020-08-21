import 'package:jdlj/model/order_entity.dart';

orderEntityFromJson(OrderEntity data, Map<String, dynamic> json) {
	if (json['success'] != null) {
		data.success = json['success'];
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['result'] != null) {
		data.result = new List<OrderResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new OrderResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> orderEntityToJson(OrderEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['success'] = entity.success;
	data['message'] = entity.message;
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

orderResultFromJson(OrderResult data, Map<String, dynamic> json) {
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
	if (json['all_price'] != null) {
		data.allPrice = json['all_price']?.toString();
	}
	if (json['pay_status'] != null) {
		data.payStatus = json['pay_status']?.toInt();
	}
	if (json['order_status'] != null) {
		data.orderStatus = json['order_status']?.toInt();
	}
	if (json['order_item'] != null) {
		data.orderItem = new List<OrderResultOrderItem>();
		(json['order_item'] as List).forEach((v) {
			data.orderItem.add(new OrderResultOrderItem().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> orderResultToJson(OrderResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['phone'] = entity.phone;
	data['address'] = entity.address;
	data['all_price'] = entity.allPrice;
	data['pay_status'] = entity.payStatus;
	data['order_status'] = entity.orderStatus;
	if (entity.orderItem != null) {
		data['order_item'] =  entity.orderItem.map((v) => v.toJson()).toList();
	}
	return data;
}

orderResultOrderItemFromJson(OrderResultOrderItem data, Map<String, dynamic> json) {
	if (json['_id'] != null) {
		data.sId = json['_id']?.toString();
	}
	if (json['order_id'] != null) {
		data.orderId = json['order_id']?.toString();
	}
	if (json['product_title'] != null) {
		data.productTitle = json['product_title']?.toString();
	}
	if (json['product_id'] != null) {
		data.productId = json['product_id']?.toString();
	}
	if (json['product_price'] != null) {
		data.productPrice = json['product_price']?.toString();
	}
	if (json['product_img'] != null) {
		data.productImg = json['product_img']?.toString();
	}
	if (json['product_count'] != null) {
		data.productCount = json['product_count']?.toInt();
	}
	if (json['selected_attr'] != null) {
		data.selectedAttr = json['selected_attr']?.toString();
	}
	if (json['add_time'] != null) {
		data.addTime = json['add_time']?.toInt();
	}
	return data;
}

Map<String, dynamic> orderResultOrderItemToJson(OrderResultOrderItem entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['_id'] = entity.sId;
	data['order_id'] = entity.orderId;
	data['product_title'] = entity.productTitle;
	data['product_id'] = entity.productId;
	data['product_price'] = entity.productPrice;
	data['product_img'] = entity.productImg;
	data['product_count'] = entity.productCount;
	data['selected_attr'] = entity.selectedAttr;
	data['add_time'] = entity.addTime;
	return data;
}