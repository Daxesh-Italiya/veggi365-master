import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class OrderResponseEntity with JsonConvert<OrderResponseEntity> {
	String status;
	String message;
	List<Order> orders;
}

class Order with JsonConvert<Order> {
	@JSONField(name: "order_id")
	int orderId;
	@JSONField(name: "user_id")
	int userId;
	@JSONField(name: "user_address_id")
	int userAddressId;
	@JSONField(name: "order_total")
	int orderTotal;
	@JSONField(name: "delivery_boy_id")
	dynamic deliveryBoyId;
	@JSONField(name: "order_status")
	int orderStatus;
	@JSONField(name: "is_deleted")
	int isDeleted;
	@JSONField(name: "created_at")
	String createdAt;
	@JSONField(name: "updated_at")
	String updatedAt;

}
