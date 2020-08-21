import 'package:jdlj/generated/json/base/json_convert_content.dart';
import 'package:jdlj/generated/json/base/json_filed.dart';

class OrderEntity with JsonConvert<OrderEntity> {
	bool success;
	String message;
	List<OrderResult> result;
}

class OrderResult with JsonConvert<OrderResult> {
	@JSONField(name: "_id")
	String sId;
	String uid;
	String name;
	String phone;
	String address;
	@JSONField(name: "all_price")
	String allPrice;
	@JSONField(name: "pay_status")
	int payStatus;
	@JSONField(name: "order_status")
	int orderStatus;
	@JSONField(name: "order_item")
	List<OrderResultOrderItem> orderItem;
}

class OrderResultOrderItem with JsonConvert<OrderResultOrderItem> {
	@JSONField(name: "_id")
	String sId;
	@JSONField(name: "order_id")
	String orderId;
	@JSONField(name: "product_title")
	String productTitle;
	@JSONField(name: "product_id")
	String productId;
	@JSONField(name: "product_price")
	String productPrice;
	@JSONField(name: "product_img")
	String productImg;
	@JSONField(name: "product_count")
	int productCount;
	@JSONField(name: "selected_attr")
	String selectedAttr;
	@JSONField(name: "add_time")
	int addTime;
}
