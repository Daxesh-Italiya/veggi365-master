import 'package:veggi/core/models/pin_code_entity.dart';

pinCodeEntityFromJson(PinCodeEntity data, Map<String, dynamic> json) {
	if (json['cab_id'] != null) {
		data.cabId = json['cab_id'] is String
				? int.tryParse(json['cab_id'])
				: json['cab_id'].toInt();
	}
	if (json['cab_pincode'] != null) {
		data.cabPincode = json['cab_pincode'] is String
				? int.tryParse(json['cab_pincode'])
				: json['cab_pincode'].toInt();
	}
	return data;
}

Map<String, dynamic> pinCodeEntityToJson(PinCodeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['cab_id'] = entity.cabId;
	data['cab_pincode'] = entity.cabPincode;
	return data;
}