import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:veggi/Cab/CartScreen.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/List/vegetable_list/Model/Comments.dart';
import 'package:veggi/List/vegetable_list/Model/product_detail.dart';
import 'package:veggi/Screens/LoginScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_components.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/services/cart_service.dart';
import '../Constants.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

import 'vegetable_list/Model/Products.dart';

class ListDetailScreen extends StatefulWidget {
  Product products;
  ProductPrice price;

  ListDetailScreen({this.price, this.products});

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  // final List<String> imgList = [
  //   'https://www.jessicagavin.com/wp-content/uploads/2019/02/carrots-7-1200.jpg',
  //   'https://upload.wikimedia.org/wikipedia/commons/7/79/Caret_img.jpg',
  //   'https://www.jessicagavin.com/wp-content/uploads/2019/02/carrots-7-1200.jpg',
  //   'https://as2.ftcdn.net/v2/jpg/01/70/67/69/500_F_170676962_GrxfYzih6sF1ZyVpDMDxmEbTBiBmtqD0.jpg',
  // ];
  ProductPrice selectedPrice = null;
  ProductDetails productDetails;
  List<Comments> comments = [];
  List<ProductPrice> productPrices = [];
  var isLoading = true;

  CartService cartService = Get.find();

  bool showMoreComment = false;
  bool isCommentReadMore = true;

  List<String> imageList = [
    // "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    // "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    // "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    // "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    // "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    // "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  int page = 0;

  bool isLogin = true;

  @override
  void initState() {
    // selectedPrice = widget.price;
    fetchProductData();
    checkLogin();
    super.initState();
  }

  void checkLogin()async{

    Utils.isLogin().then((value) {
      setState(() {
        isLogin = value;
      });
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? AppComponents.cabLoading //Center(child: CircularProgressIndicator())
            : CustomScrollView(slivers: [
                /*SliverPersistentHeader(
                  pinned: true,
                  delegate: FlexibleHeaderDelegate(
                    statusBarHeight: MediaQuery.of(context).padding.top,
                    expandedHeight: 240,
                    backgroundColor: AppColors.themeColor.primaryColor,
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.navigate_before_outlined,
                            color: AppColors.themeColor.primaryIconColor,
                            size: 35),
                      ),
                    ),
                    background: MutableBackground(
                      //expandedColor: Colors.white,
                      collapsedWidget: AppComponents.loading,
                      expandedWidget: Container(
                          child: Image.network(
                          widget.products.productCoverImg,
                          fit: BoxFit.contain)),
                      //collapsedColor: AppColors.themeColor.primaryColor,
                    ),
                  ),
                ),*/

                SliverAppBar(
                    expandedHeight: 240.0,
                    floating: false,
                    backgroundColor: Colors.black.withOpacity(0.5),
                    pinned: true,
                    title: Text(
                      '${widget.products.productName}',
                      style: AppTextStyle.pageTitleStyle,
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        child: Icon(Icons.navigate_before_outlined,
                            color: AppColors.themeColor.primaryIconColor,
                            size: 35),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                          color: Colors.white,
                          //margin: EdgeInsets.only(top:Get.statusBarHeight),
                          child: CachedNetworkImage(
                            imageUrl: productDetails.productCoverImg,
                            errorWidget: (context, url, error) => Container(
                              alignment: Alignment.center,
                              child: Text("No Image Found"),
                            ),
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: GFLoader(),
                            ),
                            imageBuilder: (context, imageProvider) => Image(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            )
                                .marginOnly(top: Get.statusBarHeight)
                                .paddingAll(10),
                          )),

                      /*background: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: GFCarousel(
                              //activeIndicator: AppColors.themeColor.primaryColor,

                              //pagination: true,
                              //initialPage: page,
                              items: imageList.map(
                                    (url) {
                                  return Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          //width: 1000.0
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onPageChanged: (index) {
                                setState(() {
                                  page = index;
                                });
                              },
                            ).marginOnly(
                                top: Get
                                    .statusBarHeight), */ /*Image.network(
                              widget.products.productCoverImg,
                              fit: BoxFit.contain,
                            ).marginOnly(
                                top: Get
                                    .statusBarHeight)*/ /*)*/
                    )),

                /*  Container(
                  height: Get.width,
                  child: Image.network(
                      widget.products.productCoverImg,
                      fit: BoxFit.contain),
                ).sliverBox,*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  //"Potato",
                                  widget.products.productName
                                      .trim()
                                      .capitalizeFirst,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                  )),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Icon(Icons.sticky_note_2_outlined,
                                      size: 15, color: productDetails.totalQuantity >0 ? kPrimaryColor : Colors.red),

                                  SizedBox(width: 3),

                                  Text(
                                    productDetails.totalQuantity >0 ? "In Stock." : "Out Of Stock.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color:  productDetails.totalQuantity > 0 ? kPrimaryColor : Colors.red),
                                  ),

                                ],
                              )
                            ])),
                    Text(
                      selectedPrice == null
                          ? "No Price"
                          : '₹${selectedPrice.productPrice}',
                      style: TextStyle(
                          color: Colors.black,
                          // ,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          fontSize: 17),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 15).sliverBox,
                SizedBox(height: 10).sliverBox,
                if (productPrices.isNotEmpty)
                  Container(
                    height: 70,
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        ProductPrice price = productPrices[index];
                        return buildPriceWidget(
                          data: price,
                          isSelected:
                              selectedPrice.priceUnitId == price.priceUnitId,
                        );
                      },
                      separatorBuilder: (_, __) => horizontalSpace(15),
                      itemCount: productPrices.length,
                    ),
                  ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 15).sliverBox,
                buildDeliveryDataWidgets()
                    .paddingSymmetric(horizontal: 0)
                    .sliverBox,
                SizedBox(height: 15).sliverBox,
                GestureDetector(
                  onTap: () {

                    if(productDetails.totalQuantity == 0){
                      Utils.showToast("Product is out of stock!");
                      return;
                    }else if (selectedPrice == null) {
                      Utils.showToast("You can't buy this product!");
                      return;
                    }

                    //add to cart
                    cartService.addProduct(selectedPrice.productId,
                        productName: productDetails.productName,
                        unitId: selectedPrice.priceUnitId,
                        img: productDetails.productCoverImg,
                        productPrice: selectedPrice.productPrice,
                        unitInGram: selectedPrice.unitInGram,
                        unitName: selectedPrice.priceUnitName);

                    Get.to(CartScreen());

                    /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CartScreen()));*/
                  },
                  child: CustomButton(
                    height: 50,
                    text: 'Add Cart',
                    color: Color(0xff4AC85D),
                  ),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                GestureDetector(
                  onTap: () {

                    if(isLogin) {
                      if (productDetails.totalQuantity == 0) {
                        Utils.showToast("Product is out of stock!");
                        return;
                      } else if (selectedPrice == null) {
                        Utils.showToast("You can't buy this product!");
                        return;
                      }

                      cartService.buyNow(selectedPrice.productId,
                          productName: productDetails.productName,
                          unitId: selectedPrice.priceUnitId,
                          img: productDetails.productCoverImg,
                          productPrice: selectedPrice.productPrice,
                          unitInGram: selectedPrice.unitInGram,
                          unitName: selectedPrice.priceUnitName);
                    }else{
                      Get.offAll(LoginScreen());
                    }
                  },
                  child: CustomButton(
                    height: 50,
                    text: isLogin ?'Buy Now':"Login To Buy",
                    color: Color(0xff299B3A),
                  ),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 15).sliverBox,
                Divider(
                  height: 1,
                  thickness: 2,
                  color: Colors.black26,
                ).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  'Fresh Till',
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  widget.products.productFreshTill,
                  style: TextStyle(
                      height: 1.5, color: Colors.black38, fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  'About Product',
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  widget.products.productAbout,
                  style: TextStyle(
                      height: 1.5, color: Colors.black38, fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  'Preservative Tips',
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Text(
                  widget.products.productStorageTip,
                  style: TextStyle(
                      height: 1.5, color: Colors.black38, fontSize: 14),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 10).sliverBox,
                Divider(
                  height: 1,
                  thickness: 2,
                  color: Colors.black26,
                ).sliverBox,
                SizedBox(height: 25).sliverBox,
                Text(
                  'Comments',
                  style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ).paddingSymmetric(horizontal: 10).sliverBox,
                SizedBox(height: 20).sliverBox,
                SliverList(
                        delegate: SliverChildListDelegate(List.generate(
                            (isCommentReadMore && !showMoreComment)
                                ? 3
                                : comments.length,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0)
                                    ],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: new DecorationImage(
                                              image: AssetImage(
                                                  "assets/icons/profile_pic.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comments[index].userName,
                                              style: TextStyle(
                                                  //color: Colors.black,
                                                color: AppColors.themeColor.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              comments[index].getTimeText(),
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      comments[index].comment,
                                      style: TextStyle(
                                          height: 1.2,
                                          color: Colors.black87,
                                          fontSize: 14),
                                    ),
                                  ],
                                ))))),
                isCommentReadMore
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            showMoreComment = showMoreComment ? false : true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              showMoreComment ? 'Show Less' : "Show More",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ).sliverBox
                    : SizedBox().sliverBox
              ]));
  }

  Row buildDeliveryDataWidgets() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              // width: 90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5.0)
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Icon(Icons.timer, color: kPrimaryColor, size: 35),
                  SizedBox(height: 5),
                  Text(
                    '40 min',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Delivery time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5.0)
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Icon(Ionicons.cash, color: kPrimaryColor, size: 35),
                  SizedBox(height: 5),
                  Text(
                    'Cash',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'on Delivery',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5.0)
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Icon(Icons.payment, color: kPrimaryColor, size: 35),
                  SizedBox(height: 5),
                  Text(
                    'Online Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 10),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget buildPriceWidget({
    @required ProductPrice data,
    bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        print("Called");
        setState(() {
          selectedPrice = data;
        });
      },
      child: Stack(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(5)),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  '₹ ${data.productPrice}',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ),
          Container(
            height: 35,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? kPrimaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                data.priceUnitName,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getProduct() async {
    // var response = await http.Client()
    //     .get(Uri.parse(getFullPath('comment/${widget.products.productId}')));
    // print(getFullPath('comment/${widget.products.productId}'));
    // print(response.body);
    // return response.body;
    var response = await http.Client().get(
      Uri.parse(getFullPath('product/${widget.products.productId}')),
      headers: await getHeader(),
    );
    print(getFullPath('product/${widget.products.productId}'));
    print(response.body);
    return response.body;
  }

  Future fetchProductData() async {
    String jsonString = await getProduct();

    var response = json.decode(jsonString);
    print("Response $response");
    productDetails = ProductDetails.fromJson(response[0]);
    comments.clear();
    productPrices.clear();
    comments.addAll(productDetails.comment);

    if (comments.length > 3) {
      setState(() {
        isCommentReadMore = true;
      });
    } else {
      setState(() {
        isCommentReadMore = false;
      });
    }

    imageList.clear();

    // imageList.add(productDetails.productImg);
    // imageList
    //     .addAll(productDetails.img.map((img) => img.productImagePath).toList());

    productPrices.addAll(productDetails.price);
    if (productPrices.isNotEmpty) selectedPrice = productPrices.first;

    setState(() {
      isLoading = false;
    });
    //print("Product ${comments[0].userName}");
    // return products;
  }
}
