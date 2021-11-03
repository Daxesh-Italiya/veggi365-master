import 'package:veggi/core/models/sign_up_response_entity.dart';

signUpResponseEntityFromJson(SignUpResponseEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status'].toString();
	}
	if (json['varification'] != null) {
		data.varification = json['varification'];
	}
	if (json['otptoken'] != null) {
		data.otptoken = json['otptoken'].toString();
	}
	if (json['temptoken'] != null) {
		data.temptoken = json['temptoken'].toString();
	}
	return data;
}

Map<String, dynamic> signUpResponseEntityToJson(SignUpResponseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['varification'] = entity.varification;
	data['otptoken'] = entity.otptoken;
	data['temptoken'] = entity.temptoken;
	return data;
}