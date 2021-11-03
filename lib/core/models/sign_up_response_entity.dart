import 'package:veggi/generated/json/base/json_convert_content.dart';

class SignUpResponseEntity with JsonConvert<SignUpResponseEntity> {
	String status;
	bool varification;
	String otptoken;
	String temptoken;
}
