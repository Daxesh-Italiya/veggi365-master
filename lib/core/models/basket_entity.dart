import 'package:veggi/generated/json/base/json_convert_content.dart';

class BasketEntity with JsonConvert<BasketEntity> {
	int id;
	String name;
	String image;
	int price;
	int basketPrice;
	bool claimed;

	BasketEntity({this.id,this.name, this.image, this.price,this.basketPrice, this.claimed = false});
}
