import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:veggi/Cab/CartScreen.dart';
import 'package:veggi/Cab/PaymentScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/List/CategoryProductList.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_components.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/notification/notification_screen.dart';
import 'package:veggi/themes/utility.dart';
import '../../Constants.dart';
import '../HomeScreen.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  //List<Category> category = List.empty(growable: true);
  TextEditingController searchTextController = TextEditingController();
  var isLoading = true;

  String search = "";
  CartService cartService = Get.find();

  bool filterIsAtoZ = true;
  int filterCategory = -1;

  @override
  void initState() {
    // TODO: implement initState
    Utility.statusBarColorPrimaryBackGround();
    super.initState();
    cartService.firstTimeOpen.value = false;
    fetchProducts();
  }

  Future<void> fetchProducts() async{
    setState(() {
      isLoading = true;
      searchTextController.text = "";
      search = "";
    });
    await cartService.fetchProducts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<Product> categoryProducts(int catId) {
    List<Product> _listContent = [];
    //String search = searchTextController.text;
    if (search.isEmpty) {
      _listContent.addAll(
          cartService.products.where((product) => product.categoryId == catId).toList() ??
              []);
    } else {
      _listContent.addAll(cartService.products
              .where((product) => (product.categoryId == catId &&
                  (product.productName.contains(search) ||
                      product.productAbout.contains(search) ||
                      product.productTag.contains(search))))
              .toList() ??
          []);
    }

    return _listContent;
  }



  ProductPrice productPrice(int productId) {
    int index = cartService.price.indexWhere((price) => price.productId == productId);

    if (index == -1) {
      return null;
    } else {
      return cartService.price[index];
    }
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
      drawer: Drawer(
        child: Column(children:[

          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: Get.statusBarHeight/2,right: 10),
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
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
            child: SvgPicture.asset("assets/icons/logo.svg",fit: BoxFit.contain,),
          ),

          Expanded(child:ListView.builder(
            shrinkWrap: true,
            itemCount: cartService.category.length + 1,
            itemBuilder: (context, index) {

              String text = "";

              if(index == 0){
                text = "All Categories";
              }else{
                text = "${cartService.category[index - 1].categoryName}";
              }

              return Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child:GestureDetector(
                onTap: () {

                  setState(() {
                    //filterCategory = index - 1;
                  });

                  if(index == 0){
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                    Get.to(
                        CategoryProductList(
                          selectedCategoryId:
                          cartService.category[index-1]
                              .categoryId,
                          catName: cartService.category[index-1]
                              .categoryName,
                          category: cartService.category,
                          price: cartService.price,
                          products: cartService.products,
                        ));

                  }



                },
                child: CustomButton(
                  height: 50,
                  text: text,
                  textColor: filterCategory == index - 1 ? Colors.white : Colors.black,
                  color: filterCategory == index - 1 ? AppColors.themeColor.primaryColor : Colors.transparent,
                ),
              ));

            }))]),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //SizedBox(),
                         IconButton(
                          onPressed: () {
                            _key.currentState.openDrawer();
                          },
                          icon: Icon(Ionicons.filter, color: Colors.white),
                        ),
                        Text('VEGGI365',
                            style: AppTextStyle.pageTitleLargeStyle),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationScreen(),
                              ),
                            ).then((value) {
                              Utility.statusBarColorPrimaryBackGround();
                            });
                          },
                          icon: Icon(Icons.notifications, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //filter


              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        return fetchProducts();
                      },
                      child: isLoading
                          ? AppComponents.cabLoading//Center(child: CircularProgressIndicator())
                          : CustomScrollView(
                        physics: BouncingScrollPhysics(),
                              slivers: [

                                SizedBox(height: 15,).sliverBox,

                                /*Container(
                                  margin: EdgeInsets.only(top: 20, right: 15, left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GFButton(
                                        color: AppColors.themeColor.primaryColor,
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "Filter",
                                            middleText: "You content goes here...",
                                            content: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              child: Container(),
                                            ),
                                            barrierDismissible: true,
                                            radius: 10.0,
                                            //confirm: confirmBtn(),
                                            //cancel: cancelBtn(),
                                          );
                                        },
                                        icon: Icon(
                                          Ionicons.filter,
                                          color: Colors.white,
                                        ),
                                        text:
                                        "${filterCategory == -1 ? "All Categories" : category[filterCategory].categoryName}",
                                      )
                                    ],
                                  ),
                                ).sliverBox,*/

                                SliverList(
                                    delegate:
                                        SliverChildListDelegate(List.generate(
                                          cartService.category.length,
                                  (index) {

                                            Category categoryItem = cartService.category[index];

                                    List<Product> catProducts =
                                        categoryProducts(
                                            categoryItem.categoryId);

                                    if (catProducts.isEmpty) {
                                      return SizedBox();
                                    }

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: Container(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    text: categoryItem
                                                        .categoryName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16,
                                                        color: Colors.black),

                                                    // children: [
                                                    //   TextSpan(
                                                    //     text: '(10% off)',
                                                    //     style: TextStyle(
                                                    //         fontWeight: FontWeight.bold,
                                                    //         fontSize: 14,
                                                    //         color: Color(0xff69A03A)),
                                                    //   ),
                                                    // ]
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          CategoryProductList(
                                                        selectedCategoryId:
                                                        categoryItem
                                                                .categoryId,
                                                        catName: categoryItem
                                                            .categoryName,
                                                        category: cartService.category,
                                                        price: cartService.price,
                                                        products: cartService.products,
                                                      ));
                                                      //Get.to(WriteAReview(product.productId));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: kPrimaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          'View All',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ))
                                              ])),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(
                                            'Vegetables mix fresh Pack  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Container(
                                          height: 190,
                                          child: ListView.builder(
                                              itemCount: catProducts.length >= 3
                                                  ? 3
                                                  : catProducts.length,
                                              // shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                Product product =
                                                    catProducts[index];

                                                ProductPrice price =
                                                    productPrice(
                                                        product.productId);

                                                // if(price == null){
                                                //   return Container(height: 20,width: 100,color: Colors.green,child:Text("index - $index, product - ${product.productName}") ,);
                                                // }

                                                return Container(
                                                    width: Get.width * 0.4,
                                                    child:MixFreshVegTile(
                                                    product, price));
                                              }),
                                        ),
                                      ],
                                    );
                                  },
                                ))),

                                SizedBox(height: 60,).sliverBox,

                              ],
                            ))),
            ],
          ),
          buildSearchBar(),
        ],
      ),
    ));
  }

  Row buildSearchBar() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 10, top: 65),
          height: 40,
          width: MediaQuery.of(context).size.width * 0.73,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.7))
              ]),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20, left: 10),
                child: Icon(
                  Icons.search,
                  size: 23,
                  color: Colors.black45,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: TextFormField(
                    // enabled: false,
                    controller: searchTextController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(top: 20),
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            ).then((value) {
              Utility.statusBarColorPrimaryBackGround();
            });
          },
          child: ObxValue(
                  (productList) => Badge(
                      position: BadgePosition.topEnd(end: -5),
                      badgeColor: Colors.red,
                      toAnimate: false,
                      padding: EdgeInsets.all(5),
                      shape: BadgeShape.circle,
                      showBadge: productList.isNotEmpty,
                      badgeContent: Text(
                        "${productList.length}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      child: Container(
                        //margin: EdgeInsets.only(top: 90, bottom: 22.5),
                        height: 40,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 23,
                          color: kPrimaryColor,
                        ),
                      )),
                  cartService.productList)
              .marginOnly(top: 90, bottom: 22.5),
        ),
      ],
    );
  }




}
