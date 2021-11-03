import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class PinCodeEntity with JsonConvert<PinCodeEntity> {
	@JSONField(name: "cab_id")
	int cabId;
	@JSONField(name: "cab_pincode")
	int cabPincode;

	PinCodeEntity({this.cabId,this.cabPincode});

}
