import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/PromoCodeDailog.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/Screens/LoginScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/controllers/cart_controller.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/product_entity.dart';
import '../Constants.dart';
import 'SelectAddressScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool isLogin = false;

  @override
  void initState() {
    //Utility.statusBarColorWhiteBackGround();
    super.initState();
    controller.cartService.reloadBasket();
    checkLogin();
  }

  void checkLogin()async{

    Utils.isLogin().then((value) {
      setState(() {
        isLogin = value;
      });
    });


  }


  Future showDialogReview(BuildContext context) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return PromoCodeDailog();
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  //var _counter = 1;
  CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Cart',
            style: AppTextStyle.pageTitleStyle,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor,
              size: 35,
            ),
          ),
        ),
        body: ObxValue(
            (productList) => Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!controller.cartService.productList.isEmpty) ...[
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: productList.length + 1,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {

                                if(index == productList.length){
                                  return Container(
                                      alignment: Alignment.centerRight,
                                      child:GFButton(
                                    onPressed: ()=>Get.offAll(HomeScreen(currentMenu: 0,)),
                                    text: "+ Add More",
                                    color: AppColors.themeColor.primaryColor,
                                    type: GFButtonType.transparent,
                                  ));
                                }else{
                                  return productItem(productList[index]);
                                }

                              },
                            ),
                          ),



                          /*GestureDetector(
                            onTap: () {
                              showDialogReview(context);
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Add More Item',
                                      style: kToPayStyle,
                                    ),
                                    Icon(Icons.navigate_next,
                                        color: kPrimaryColor, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),*/

                          controller.cartService.eligibleBasket() != null ?Container(
                  margin: EdgeInsets.only(top: 10),
                  //padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child:  GFListTile(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                    title: Text(controller.cartService.eligibleBasket().name,style: kToPayStyle1,),
                    avatar: Image.asset(controller.cartService.eligibleBasket().image,height: 30,width: 30,),
                    icon: Text("GET FREE"),
                  )):SizedBox(),
                          
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xffE0EBD6),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child:  Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Item Total',
                                        style: kToPayStyle1,
                                      ),
                                      Text(
                                        '₹ ${controller.cartService.totalAmount()}',
                                        style: kToPayStyle1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery Fee',
                                        style: kToPayStyle1,
                                      ),
                                      Text(
                                        'Free',
                                        style: kToPayStyle1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Texes & Charges',
                                        style: kToPayStyle1,
                                      ),
                                      Text(
                                        '₹ ${controller.cartService.tax}',
                                        style: kToPayStyle1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Item Discount',
                                        style: kToPayStyle,
                                      ),
                                      Text(
                                        '₹ ${controller.cartService.discount}',
                                        style: kToPayStyle,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Divider(
                                    height: 1,
                                    thickness: 2,
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To Pay',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '₹ ${controller.cartService.finalAmount()}',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              //select address


                              if(isLogin) {
                                if (controller.cartService.productList
                                    .isEmpty) {
                                  Utils.showToast("Add product in cart first!");
                                  return;
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectAddressScreen()));
                              }else{
                                Get.offAll(LoginScreen());
                              }

                            },
                            child: CustomButton(
                              height: 50,
                              text: isLogin? 'Check Out' : "Login & Checkout",
                              color: kPrimaryColor,
                            ),
                          ),
                          verticalSpace(10)
                        ] else ...[
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/icons/empty_cart.png",
                                    height: Get.width * 0.5,
                                    width: Get.width * 0.5,
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                    "Your Cart is Empty",
                                    style: AppTextStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //select address
                                      Get.offAll(HomeScreen(
                                        currentMenu: 0,
                                      ));
                                    },
                                    child: CustomButton(
                                      height: 50,
                                      text: 'Shop Now',
                                      color: kPrimaryColor,
                                    ).marginSymmetric(
                                        horizontal: Get.width * 0.2),
                                  ),
                                ]),
                          ))
                        ]
                      ],
                    ),
                  ),
                ),
            controller.cartService.productList));
  }

  Widget productItem(ProductEntity product) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
            ),
          ],
        ),
        child:
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: new DecorationImage(
                              image: new NetworkImage(
                                  '${product.productCoverImg}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.productName}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              '₹ ${product.productPrice} per/${product.productUnitName}',
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 23,
                              width: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: kPrimaryColor),
                              child: Center(
                                child: Text(
                                  '₹${product.productPrice * product.cartQty}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              /* if (_counter > 0) {
                                _counter--;
                              }*/

                              controller.cartService.removeProduct(
                                  product.productId,
                                  unitId: product.priceUnitId);
                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kPrimaryColor),
                            child: Center(
                              child: Icon(Icons.remove,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                        Text(
                          //' ${controller.cartService.totalKG(product.productId, product.priceUnitId)}',
                          '  ${product.cartQty}  ',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.cartService.addProduct(product.productId,
                                unitId: product.priceUnitId);
                            setState(() {});
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: kPrimaryColor),
                            child: Center(
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
      );
  }

/*  insertOrder() async {
    var response = await http.Client()
        .post(Uri.parse(URL_INSERT_ORDER), headers: await getHeader(), body: {
      "total": "${190 * _counter - 20}",
      "item": [
        {
          "product_id": "1",
          "product_price": "190",
          "price_unit_id": "2",
          "order_quantity": "$_counter"
        },
      ]
    });
    print("Response ${response.body}");
  }*/
}
