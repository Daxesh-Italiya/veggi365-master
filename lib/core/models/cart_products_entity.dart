import 'package:veggi/core/models/product_entity.dart';
import 'package:veggi/generated/json/base/json_convert_content.dart';

class CartProductsEntity with JsonConvert<CartProductsEntity> {
	List<ProductEntity> products;

	CartProductsEntity({this.products});
}
