import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class UserResponseEntity with JsonConvert<UserResponseEntity> {
	@JSONField(name: "user_id")
	double userId;
	@JSONField(name: "user_name")
	String userName;
	@JSONField(name: "user_phone")
	double userPhone;
	@JSONField(name: "user_email")
	String userEmail;
	@JSONField(name: "user_password")
	String userPassword;
	@JSONField(name: "is_deleted")
	double isDeleted;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;
}
