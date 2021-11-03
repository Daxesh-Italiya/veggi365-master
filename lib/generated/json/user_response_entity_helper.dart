import 'package:veggi/core/models/user_response_entity.dart';

userResponseEntityFromJson(UserResponseEntity data, Map<String, dynamic> json) {
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? double.tryParse(json['user_id'])
				: json['user_id'].toDouble();
	}
	if (json['user_name'] != null) {
		data.userName = json['user_name'].toString();
	}
	if (json['user_phone'] != null) {
		data.userPhone = json['user_phone'] is String
				? double.tryParse(json['user_phone'])
				: json['user_phone'].toDouble();
	}
	if (json['user_email'] != null) {
		data.userEmail = json['user_email'].toString();
	}
	if (json['user_password'] != null) {
		data.userPassword = json['user_password'].toString();
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

Map<String, dynamic> userResponseEntityToJson(UserResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['user_id'] = entity.userId;
	data['user_name'] = entity.userName;
	data['user_phone'] = entity.userPhone;
	data['user_email'] = entity.userEmail;
	data['user_password'] = entity.userPassword;
	data['is_deleted'] = entity.isDeleted;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}