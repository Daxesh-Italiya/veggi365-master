import 'package:veggi/core/models/order_product_response_entity.dart';

orderProductFromJson(OrderProduct data, Map<String, dynamic> json) {
	if (json['order_id'] != null) {
		data.orderId = json['order_id'] is String
				? int.tryParse(json['order_id'])
				: json['order_id'].toInt();
	}
	if (json['product_id'] != null) {
		data.productId = json['product_id'] is String
				? int.tryParse(json['product_id'])
				: json['product_id'].toInt();
	}
	if (json['product_name'] != null) {
		data.productName = json['product_name'].toString();
	}
	if (json['price_unit_name'] != null) {
		data.priceUnitName = json['price_unit_name'].toString();
	}
	if (json['price_unit_id'] != null) {
		data.priceUnitId = json['price_unit_id'] is String
				? int.tryParse(json['price_unit_id'])
				: json['price_unit_id'].toInt();
	}
	if (json['order_quantity'] != null) {
		data.orderQuantity = json['order_quantity'] is String
				? int.tryParse(json['order_quantity'])
				: json['order_quantity'].toInt();
	}
	if (json['product_price'] != null) {
		data.productPrice = json['product_price'] is String
				? int.tryParse(json['product_price'])
				: json['product_price'].toInt();
	}
	if (json['product_img'] != null) {
		data.productImg = json['product_img'].toString();
	}
	return data;
}

Map<String, dynamic> orderProductToJson(OrderProduct entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order_id'] = entity.orderId;
	data['product_id'] = entity.productId;
	data['product_name'] = entity.productName;
	data['price_unit_name'] = entity.priceUnitName;
	data['price_unit_id'] = entity.priceUnitId;
	data['order_quantity'] = entity.orderQuantity;
	data['product_price'] = entity.productPrice;
	data['product_img'] = entity.productImg;
	return data;
}