import 'package:veggi/core/models/order_response_entity.dart';

orderResponseEntityFromJson(OrderResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['orders'] != null) {
		data.orders = (json['orders'] as List).map((v) => Order().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> orderResponseEntityToJson(OrderResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['orders'] =  entity.orders?.map((v) => v.toJson())?.toList();
	return data;
}

orderFromJson(Order data, Map<String, dynamic> json) {
	if (json['order_id'] != null) {
		data.orderId = json['order_id'] is String
				? int.tryParse(json['order_id'])
				: json['order_id'].toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? int.tryParse(json['user_id'])
				: json['user_id'].toInt();
	}
	if (json['user_address_id'] != null) {
		data.userAddressId = json['user_address_id'] is String
				? int.tryParse(json['user_address_id'])
				: json['user_address_id'].toInt();
	}
	if (json['order_total'] != null) {
		data.orderTotal = json['order_total'] is String
				? int.tryParse(json['order_total'])
				: json['order_total'].toInt();
	}
	if (json['delivery_boy_id'] != null) {
		data.deliveryBoyId = json['delivery_boy_id'];
	}
	if (json['order_status'] != null) {
		data.orderStatus = json['order_status'] is String
				? int.tryParse(json['order_status'])
				: json['order_status'].toInt();
	}
	if (json['is_deleted'] != null) {
		data.isDeleted = json['is_deleted'] is String
				? int.tryParse(json['is_deleted'])
				: json['is_deleted'].toInt();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> orderToJson(Order entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order_id'] = entity.orderId;
	data['user_id'] = entity.userId;
	data['user_address_id'] = entity.userAddressId;
	data['order_total'] = entity.orderTotal;
	data['delivery_boy_id'] = entity.deliveryBoyId;
	data['order_status'] = entity.orderStatus;
	data['is_deleted'] = entity.isDeleted;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}