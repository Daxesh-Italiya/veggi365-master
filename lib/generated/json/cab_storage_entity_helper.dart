import 'package:veggi/core/models/cab_storage_entity.dart';

cabStorageEntityFromJson(CabStorageEntity data, Map<String, dynamic> json) {
	if (json['product_id'] != null) {
		data.productId = json['product_id'] is String
				? int.tryParse(json['product_id'])
				: json['product_id'].toInt();
	}
	if (json['product_name'] != null) {
		data.productName = json['product_name'].toString();
	}
	if (json['quantity'] != null) {
		data.quantity = json['quantity'] is String
				? int.tryParse(json['quantity'])
				: json['quantity'].toInt();
	}
	if (json['product_img'] != null) {
		data.productImg = json['product_img'].toString();
	}
	return data;
}

Map<String, dynamic> cabStorageEntityToJson(CabStorageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['product_id'] = entity.productId;
	data['product_name'] = entity.productName;
	data['quantity'] = entity.quantity;
	data['product_img'] = entity.productImg;
	return data;
}