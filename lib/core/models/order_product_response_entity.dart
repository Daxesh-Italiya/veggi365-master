import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class OrderProduct with JsonConvert<OrderProduct> {
	@JSONField(name: "order_id")
	int orderId;
	@JSONField(name: "product_id")
	int productId;
	@JSONField(name: "product_name")
	String productName;
	@JSONField(name: "price_unit_name")
	String priceUnitName;
	@JSONField(name: "price_unit_id")
	int priceUnitId;
	@JSONField(name: "order_quantity")
	int orderQuantity;
	@JSONField(name: "product_price")
	int productPrice;
	@JSONField(name: "product_img")
	String productImg;
}
