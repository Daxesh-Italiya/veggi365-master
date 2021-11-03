import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class CabStorageEntity with JsonConvert<CabStorageEntity> {
	@JSONField(name: "product_id")
	int productId;
	@JSONField(name: "product_name")
	String productName;
	int quantity;
	@JSONField(name: "product_img")
	String productImg;

	CabStorageEntity({
      this.productId, this.productName, this.quantity, this.productImg});
}
