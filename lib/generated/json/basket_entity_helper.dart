import 'package:veggi/core/models/basket_entity.dart';

basketEntityFromJson(BasketEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['image'] != null) {
		data.image = json['image'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'] is String
				? int.tryParse(json['price'])
				: json['price'].toInt();
	}
	if (json['claimed'] != null) {
		data.claimed = json['claimed'];
	}
	return data;
}

Map<String, dynamic> basketEntityToJson(BasketEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['image'] = entity.image;
	data['price'] = entity.price;
	data['claimed'] = entity.claimed;
	return data;
}