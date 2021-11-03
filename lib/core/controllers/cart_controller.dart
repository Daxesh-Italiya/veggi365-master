
import 'package:get/get.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/services/cart_service.dart';

class CartController extends GetxController{

  //RxList<Product> productList = <Product>[].obs;
  CartService cartService = Get.find();

  CartController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  loadCartProduct() async{

    if(Storage.hasData("cart")){
      String data = await Storage.getValue("cart");

    }

  }

}