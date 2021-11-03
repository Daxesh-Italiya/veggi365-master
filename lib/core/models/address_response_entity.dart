import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';


class AddressResponseEntity with JsonConvert<AddressResponseEntity> {

	String status;
	String message;
	List<Address> address;
	AddressResponseEntity({this.address = const []});
}


class Address with JsonConvert<Address> {
	@JSONField(name: "user_address_id")
	double userAddressId;
	@JSONField(name: "user_id")
	double userId;
	@JSONField(name: "user_address_name")
	String userAddressName;
	@JSONField(name: "full_address")
	String fullAddress;
	@JSONField(name: "city_name")
	String cityName;
	double pincode;
	@JSONField(name: "user_address_default")
	double userAddressDefault;
	@JSONField(name: "is_deleted")
	double isDeleted;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;
}
