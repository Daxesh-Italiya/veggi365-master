import 'package:veggi/core/models/cart_products_entity.dart';
import 'package:veggi/core/models/product_entity.dart';

cartProductsEntityFromJson(CartProductsEntity data, Map<String, dynamic> json) {
	if (json['products'] != null) {
		data.products = (json['products'] as List).map((v) => ProductEntity().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> cartProductsEntityToJson(CartProductsEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['products'] =  entity.products?.map((v) => v.toJson())?.toList();
	return data;
}