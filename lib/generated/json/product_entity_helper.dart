import 'package:veggi/core/models/product_entity.dart';

productEntityFromJson(ProductEntity data, Map<String, dynamic> json) {
	if (json['product_id'] != null) {
		data.productId = json['product_id'] is String
				? int.tryParse(json['product_id'])
				: json['product_id'].toInt();
	}
	if (json['product_name'] != null) {
		data.productName = json['product_name'].toString();
	}
	if (json['product_cover_img'] != null) {
		data.productCoverImg = json['product_cover_img'].toString();
	}
	if (json['product_price'] != null) {
		data.productPrice = json['product_price'] is String
				? int.tryParse(json['product_price'])
				: json['product_price'].toInt();
	}
	if (json['price_unit_name'] != null) {
		data.productUnitName = json['price_unit_name'].toString();
	}
	if (json['unit_in_gm'] != null) {
		data.unitInGram = json['unit_in_gm'] is String
				? int.tryParse(json['unit_in_gm'])
				: json['unit_in_gm'].toInt();
	}
	if (json['price_unit_id'] != null) {
		data.priceUnitId = json['price_unit_id'] is String
				? int.tryParse(json['price_unit_id'])
				: json['price_unit_id'].toInt();
	}
	if (json['order_quantity'] != null) {
		data.cartQty = json['order_quantity'] is String
				? int.tryParse(json['order_quantity'])
				: json['order_quantity'].toInt();
	}
	return data;
}

Map<String, dynamic> productEntityToJson(ProductEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['product_id'] = entity.productId;
	data['product_name'] = entity.productName;
	data['product_cover_img'] = entity.productCoverImg;
	data['product_price'] = entity.productPrice;
	data['price_unit_name'] = entity.productUnitName;
	data['unit_in_gm'] = entity.unitInGram;
	data['price_unit_id'] = entity.priceUnitId;
	data['order_quantity'] = entity.cartQty;
	return data;
}