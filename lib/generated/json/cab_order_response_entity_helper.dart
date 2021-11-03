import 'package:veggi/core/models/cab_order_response_entity.dart';

cabOrderResponseEntityFromJson(CabOrderResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['orders'] != null) {
		data.orders = (json['orders'] as List).map((v) => CabOrder().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> cabOrderResponseEntityToJson(CabOrderResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['orders'] =  entity.orders?.map((v) => v.toJson())?.toList();
	return data;
}

cabOrderFromJson(CabOrder data, Map<String, dynamic> json) {
	if (json['cab_order_id'] != null) {
		data.cabOrderId = json['cab_order_id'] is String
				? int.tryParse(json['cab_order_id'])
				: json['cab_order_id'].toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? int.tryParse(json['user_id'])
				: json['user_id'].toInt();
	}
	if (json['user_address'] != null) {
		data.userAddress = json['user_address'].toString();
	}
	if (json['user_pincode'] != null) {
		data.userPincode = json['user_pincode'] is String
				? int.tryParse(json['user_pincode'])
				: json['user_pincode'].toInt();
	}
	if (json['cab_id'] != null) {
		data.cabId = json['cab_id'] is String
				? int.tryParse(json['cab_id'])
				: json['cab_id'].toInt();
	}
	if (json['cab_order_status'] != null) {
		data.cabOrderStatus = json['cab_order_status'] is String
				? int.tryParse(json['cab_order_status'])
				: json['cab_order_status'].toInt();
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

Map<String, dynamic> cabOrderToJson(CabOrder entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cab_order_id'] = entity.cabOrderId;
	data['user_id'] = entity.userId;
	data['user_address'] = entity.userAddress;
	data['user_pincode'] = entity.userPincode;
	data['cab_id'] = entity.cabId;
	data['cab_order_status'] = entity.cabOrderStatus;
	data['is_deleted'] = entity.isDeleted;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}