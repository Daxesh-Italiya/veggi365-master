import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:ionicons/ionicons.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/List/CategoryProductList.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/themes/utility.dart';
import 'package:veggi/core/models/basket_entity.dart';

import '../Constants.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  CartService cartService = Get.find();

  @override
  void initState() {
    //Utility.statusBarColorWhiteBackGround();
    Utility.statusBarColorPrimaryBackGround();
    super.initState();
    cartService.firstTimeOpen.value = false;
    fetchProducts();
    cartService.reloadBasket();
  }

  void fetchProducts() async {
    setState(() {});
    await cartService.fetchProducts();
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
        message:"Press back again to close",
        onFirstBackPress: (c)=>Get.offAll(HomeScreen()),
        child:Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              _key.currentState.openDrawer();
            },
            icon: Icon(Ionicons.filter, color: Colors.white),
          ),
          title: Text(
            'Offers',
            style: AppTextStyle.pageTitleStyle,
          ),
        ),
        drawer: Drawer(
          child: Column(children: [
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: Get.statusBarHeight / 2, right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Ionicons.chevron_back,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
            Container(
              height: Get.width * 0.3,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: SvgPicture.asset(
                "assets/icons/logo.svg",
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartService.category.length + 1,
                    itemBuilder: (context, index) {
                      String text = "";

                      if (index == 0) {
                        text = "All Categories";
                      } else {
                        text =
                            "${cartService.category[index - 1].categoryName}";
                      }

                      return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                //filterCategory = index - 1;
                              });

                              if (index == 0) {
                                Navigator.pop(context);
                                Get.offAll(HomeScreen(currentMenu: 0,));
                              } else {
                                Navigator.pop(context);
                                Get.to(CategoryProductList(
                                  selectedCategoryId: cartService
                                      .category[index - 1].categoryId,
                                  catName: cartService
                                      .category[index - 1].categoryName,
                                  category: cartService.category,
                                  price: cartService.price,
                                  products: cartService.products,
                                ));
                              }
                            },
                            child: CustomButton(
                              height: 50,
                              text: text,
                              textColor:
                                  index == 0 ? Colors.white : Colors.black,
                              color: index == 0
                                  ? AppColors.themeColor.primaryColor
                                  : Colors.transparent,
                            ),
                          ));
                    }))
          ]),
        ),
        body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            BasketEntity basket = cartService.baskets[index];

            return Container(
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child:Text(
                          'Get free ${basket.name} worth ₹${basket.basketPrice} on order above ₹${basket.price}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          maxLines: 2,
                        )),
                       /* Text(
                          'on order above ₹${basket.price}',
                          style: kToPayStyle1,
                          // style: TextStyle(
                          //     color: Colors.black,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 15),
                          textAlign: TextAlign.center,
                        ),*/
                      ]),

                  Container(
                      child:
                          Text("${basket.claimed ? "Claimed" : "Available"}")),
                  AspectRatio(
                      aspectRatio: 4 / 3, child: Image.asset(basket.image)),
                ]));
          },
        ) /*Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialogOffers(context);
              },
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 3.0)
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flat 20% off',
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      Text(
                        'Code : Abc xyz',
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),*/
        ));
  }

  Future showDialogOffers(BuildContext context) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return OffersDailog();
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }
}

class OffersDailog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              // height: 400,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Flat 20% Off',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 22),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Code : Abc xyz',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Divider(height: 1, thickness: 2),
                  SizedBox(height: 10),
                  Text(
                    '. common, narrow usage, the term vegetable usually refers to the fresh edible portions of certain herbaceous plants—roots, stems, leaves, flowers, fruit, or seeds.',
                    style: TextStyle(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '. common, narrow usage, the term vegetable usually refers to the fresh edible portions of certain herbaceous plants—roots, stems, leaves, flowers, fruit, or seeds.',
                    style: TextStyle(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 45,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'BACK',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
