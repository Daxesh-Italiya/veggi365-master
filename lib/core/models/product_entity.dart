import 'package:veggi/generated/json/base/json_convert_content.dart';
import 'package:veggi/generated/json/base/json_field.dart';

class ProductEntity with JsonConvert<ProductEntity> {
  @JSONField(name: "product_id")
  int productId;

  @JSONField(name: "product_name")
  String productName;

  @JSONField(name: "product_cover_img")
  String productCoverImg;

  @JSONField(name: "product_price")
  int productPrice;

  @JSONField(name: "price_unit_name")
  String productUnitName;

  @JSONField(name: "unit_in_gm")
  int unitInGram;

  @JSONField(name: "price_unit_id")
  int priceUnitId;

  @JSONField(name: "order_quantity")
  int cartQty;

  ProductEntity(
      {this.productId,
      this.productName,
      this.productCoverImg,
      this.productPrice,
      this.productUnitName,
      this.unitInGram,
      this.priceUnitId,
      this.cartQty = 1});
}
