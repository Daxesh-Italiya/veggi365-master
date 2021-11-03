import 'dart:convert';

import 'package:get/get.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/models/cart_products_entity.dart';
import 'package:veggi/core/models/product_entity.dart';
import 'package:json_helpers/json_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/core/models/basket_entity.dart';

class CartService extends GetxService {

  RxBool firstTimeOpen = true.obs;

  RxList<ProductEntity> productList = <ProductEntity>[].obs;

  RxList<Category> category = <Category>[].obs;
  RxList<Product> products = <Product>[].obs;
  RxList<ProductPrice> price = <ProductPrice>[].obs;

  double tax = 0;
  double discount = 0;

  RxList<BasketEntity> baskets =  <BasketEntity>[
   BasketEntity(id:1,name: "Basket",image: "assets/icons/b1.jpeg",basketPrice:49,price: 99,),
    BasketEntity(id:2,name: "Basket",image: "assets/icons/b3.jpeg",basketPrice:149,price: 299,),
    BasketEntity(id:3,name: "Chop Board",image: "assets/icons/b2.jpeg",basketPrice:225,price: 449,)
  ].obs;

  double totalAmount() {
    double total = 0;
    productList.forEach((product) {
      total = total + (product.productPrice * product.cartQty);
    });
    return total;
  }

  double finalAmount() {
    return totalAmount() + tax - discount;
  }

  String totalKG(int productId, int unitId) {
    int index = productIndex(productId, unitId);

    if (index != -1) {
      ProductEntity productEntity = productList[index];
      double totalKG =
          (productEntity.unitInGram * productEntity.cartQty) / 1000;
      return "$totalKG kg";
    } else {
      return "Kg";
    }
  }

  void clearCart() {
    productList.clear();
    Storage.removeValue("cart");
    //refreshCart();
  }

  Future<void> init() async {
    refreshCart();
  }

  Future<String> getProduct() async {
    var response = await http.Client()
        .get(Uri.parse(URL_PRODUCT), headers: await getHeader());
    print(response.body);
    return response.body;
  }

  void reloadBasket() async{
    var responseData =
        await http.get(Uri.parse(AppConstants.API_BASKET), headers: await getHeader());

    print(responseData);

    var response = json.decode(responseData.body);

    print(responseData);
    print('response $response');

    for (var i in response) {
      int b1 = i["b1"];
      int b2 = i["b2"];
      int b3 = i["b3"];
      print("Data --> b1 - $b1, b2 - $b2, b3 - $b3");

      baskets[0].claimed = b1 == 1;
      baskets[1].claimed = b2 == 1;
      baskets[2].claimed = b3 == 1;

    }

  }

  BasketEntity eligibleBasket(){
    double total = finalAmount();
    int basket = 0;

    if(total >= baskets[2].price && !baskets[0].claimed){
      basket = 3;
    }else  if(total >= baskets[1].price && !baskets[0].claimed){
      basket = 2;
    }else if(total >= baskets[0].price && !baskets[0].claimed){
      basket = 1;
    }

    if(basket == 0){
      return null;
    }else{
      return baskets[basket - 1];
    }


  }

  void fetchProducts() async {
    String jsonString = await getProduct();

    var response = json.decode(jsonString);
    print("Response $response");

    products.clear();
    for (var i in response["product"]) {
      products.add(Product.fromJson(i));
      print("Data --> $i");
    }

    /*  img.clear();
    for (var i in response["img"]) {
      img.add(Img.fromJson(i));
    }*/

    price.clear();
    for (var i in response["price"]) {
      price.add(ProductPrice.fromJson(i));
    }

    category.clear();
    for (var i in response["category"]) {
      category.add(Category.fromJson(i));
    }
    print("Product ${products[0].categoryId}");

    return;
    // return products;
  }

  // List<Category> filteredCategory() {
  //   if(filterCategory == -1){
  //     return cartService.category;
  //   }else{
  //     return [cartService.category[filterCategory]];
  //   }
  // }

  void refreshCart() async {
    if (Storage.hasData("cart")) {
      String data = await Storage.getValue("cart");

      print("save cart data - $data");

      data.jsonList((e) {
        //Utils.printMap(e);
        productList.add(ProductEntity().fromJson(e));
        //OrderProduct().fromJson(e);
      });

      // var jsonList = jsonDecode(data);
      // CartProductsEntity cartProductsEntity = CartProductsEntity().fromJson(jsonList);
      // productList.value = cartProductsEntity.products;
    }
  }

  int productIndex(int productId, int unitId) {
    int index = productList.indexWhere((product) =>
        (product.productId == productId && product.priceUnitId == unitId));
    return index;
  }

  bool productExist(int productId, int unitId) {
    return productIndex(productId, unitId) != -1;
  }

  addProduct(int productId,
      {String productName,
      int productPrice,
      int unitId,
      String unitName,
      String img,
      int unitInGram}) {
    int index = productIndex(productId, unitId);

    if (index != -1) {
      print("already exist - ${productId}");
      productList.value[index].cartQty++;
      productList.refresh();
    } else {
      ProductEntity productEntity = ProductEntity(
          productId: productId,
          productName: productName,
          productCoverImg: img,
          productPrice: productPrice,
          priceUnitId: unitId,
          productUnitName: unitName,
          unitInGram: unitInGram,
          cartQty: 1);

      productList.add(productEntity);
      productList.refresh();

      print("product - " + json.encode(productEntity.toJson()));
    }

    saveCart();
  }

  removeProduct(int productId, {int unitId = 0}) {
    if (productExist(productId, unitId)) {
      int index = productIndex(productId, unitId);
      ProductEntity productEntity = productList[index];
      if (productEntity.cartQty > 1) {
        productList[index].cartQty--;
      } else {
        productList.removeAt(index);
      }
    }

    saveCart();
  }

  saveCart() async {

    String productData  = json.encode(productList.value.map((e) => e.toJson()).toList());

    Storage.saveValue(
        "cart", productData);


    String data = await Storage.getValue("cart");
    print("save cart data - $data");
    //refreshCart();
  }

  buyNow(int productId,
      {String productName,
      int productPrice,
      int unitId,
      String unitName,
      String img,
      int unitInGram}) {
    productList.value = [
      ProductEntity(
          productId: productId,
          productName: productName,
          productCoverImg: img,
          productPrice: productPrice,
          priceUnitId: unitId,
          productUnitName: unitName,
          unitInGram: unitInGram,
          cartQty: 1)
    ];

    Get.to(SelectAddressScreen());
  }
}
