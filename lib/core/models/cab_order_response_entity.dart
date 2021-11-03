import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class CabOrderResponseEntity with JsonConvert<CabOrderResponseEntity> {
	String status;
	String message;
	List<CabOrder> orders;
}

class CabOrder with JsonConvert<CabOrder> {
	@JSONField(name: "cab_order_id")
	int cabOrderId;
	@JSONField(name: "user_id")
	int userId;
	@JSONField(name: "user_address")
	String userAddress;
	@JSONField(name: "user_pincode")
	int userPincode;
	@JSONField(name: "cab_id")
	int cabId;
	@JSONField(name: "cab_order_status")
	int cabOrderStatus;
	@JSONField(name: "is_deleted")
	int isDeleted;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;

}
