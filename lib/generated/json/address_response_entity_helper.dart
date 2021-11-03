import 'package:veggi/core/models/address_response_entity.dart';

addressResponseEntityFromJson(AddressResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['address'] != null) {
		data.address = (json['address'] as List).map((v) => Address().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> addressResponseEntityToJson(AddressResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['address'] =  entity.address?.map((v) => v.toJson())?.toList();
	return data;
}

addressFromJson(Address data, Map<String, dynamic> json) {
	if (json['user_address_id'] != null) {
		data.userAddressId = json['user_address_id'] is String
				? double.tryParse(json['user_address_id'])
				: json['user_address_id'].toDouble();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? double.tryParse(json['user_id'])
				: json['user_id'].toDouble();
	}
	if (json['user_address_name'] != null) {
		data.userAddressName = json['user_address_name'].toString();
	}
	if (json['full_address'] != null) {
		data.fullAddress = json['full_address'].toString();
	}
	if (json['city_name'] != null) {
		data.cityName = json['city_name'].toString();
	}
	if (json['pincode'] != null) {
		data.pincode = json['pincode'] is String
				? double.tryParse(json['pincode'])
				: json['pincode'].toDouble();
	}
	if (json['user_address_default'] != null) {
		data.userAddressDefault = json['user_address_default'] is String
				? double.tryParse(json['user_address_default'])
				: json['user_address_default'].toDouble();
	}
	if (json['is_deleted'] != null) {
		data.isDeleted = json['is_deleted'] is String
				? double.tryParse(json['is_deleted'])
				: json['is_deleted'].toDouble();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> addressToJson(Address entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['user_address_id'] = entity.userAddressId;
	data['user_id'] = entity.userId;
	data['user_address_name'] = entity.userAddressName;
	data['full_address'] = entity.fullAddress;
	data['city_name'] = entity.cityName;
	data['pincode'] = entity.pincode;
	data['user_address_default'] = entity.userAddressDefault;
	data['is_deleted'] = entity.isDeleted;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}