import 'dart:convert';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:ionicons/ionicons.dart';
import 'package:veggi/Cab/CartScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/Write_review.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/List/CategoryProductList.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/Orders/CabTrackingScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/cab_order_response_entity.dart';
import 'package:veggi/core/models/order_product_response_entity.dart';
import 'package:veggi/core/models/order_response_entity.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/themes/app_assets.dart';
import 'package:veggi/themes/utility.dart';
import 'package:veggi/widgets/login_widget.dart';

import '../Constants.dart';
import 'OngoingDetailScreen.dart';
import 'package:http/http.dart' as http;
import 'package:json_helpers/json_helpers.dart';
import 'package:veggi/Cab/Model/Address.dart';

class MixOrder{

  bool isCabOrder;
  CabOrder cabOrder;
  Order order;

  MixOrder({this.isCabOrder, this.cabOrder, this.order});
}

class OrderScreen extends StatefulWidget {
  final bool showBack;

  OrderScreen({this.showBack = false});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading = true;

  List<Order> orders = [];

  List<CabOrder> cabOrders = [];

  List<MixOrder> mixedOrder = [];

  List<Address> addresses = [];

  List<String> orderStatus = [
    "Pending",
    "Accepted",
    "Ongoing",
    "Completed",
    "Cancelled",
    "Pending",
    "Pending"
  ];

  List<Color> statusColors = [
    Colors.orange,
    AppColors.themeColor.textColor,
    AppColors.themeColor.textColor,
    AppColors.themeColor.primaryColor,
    Colors.red,
    Colors.orange,
    Colors.orange
  ];



  CartService cartService = Get.find();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isLogin = true;

  @override
  void initState() {
    //Utility.statusBarColorWhiteBackGround();
    Utility.statusBarColorPrimaryBackGround();
    super.initState();

    cartService.firstTimeOpen.value = false;

    loadOrders();
    loadCabOrders();
    loadAddress();

    checkLogin();
  }

  void checkLogin()async{

    Utils.isLogin().then((value) {
      setState(() {
        isLogin = value;
      });
    });


  }

  loadAll() async {
    loadOrders();
    loadCabOrders();
  }

  loadOrders() async {
    setState(() {
      isLoading = true;
      orders.clear();
    });

    var responseData = await http.Client()
        .get(Uri.parse(getFullPath('order')), headers: await getHeader());

    String jsonString = responseData.body;

    var response = json.decode(jsonString);
    print("Response $response");

    for (var i in response) {
      orders.add(Order().fromJson(i));
      print("Data --> $i");
    }

    setState(() {
      isLoading = false;
    });
    //print("Address ${addresses[0].cityName}");
    // return products;
  }

  loadCabOrders() async {
    setState(() {
      isLoading = true;
    });

    var responseData = await http.Client()
        .get(Uri.parse(getFullPath('caborder')), headers: await getHeader());

    String jsonString = responseData.body;

    var response = json.decode(jsonString);
    print("Response $response");

    cabOrders.clear();

    for (var i in response) {
      cabOrders.add(CabOrder().fromJson(i));
      print("Data --> $i");
    }

    setState(() {
      isLoading = false;
    });
    //print("Address ${addresses[0].cityName}");
    // return products;
  }

  List<Order> onGoingOrderList() {
    return orders
        .where((order) => order.orderStatus != 3)
        .toList()
        .reversed
        .toList();
  }

  List<Order> onCompletedOrderList() {
    return orders
        .where((order) => order.orderStatus == 3)
        .toList()
        .reversed
        .toList();
  }


  List<MixOrder> mixedCompletedList() {
    List<MixOrder> _list = mixedOrderList();
    return _list
        .where((mixOrder) {
      if(mixOrder.isCabOrder){
        return mixOrder.cabOrder.cabOrderStatus == 3;
      }else{
        return mixOrder.order.orderStatus == 3;
      }
    })
        .toList().reversed.toList();
  }


  List<MixOrder> mixedOngoingList() {
    List<MixOrder> _list = mixedOrderList();
    return _list
        .where((mixOrder) {
          if(mixOrder.isCabOrder){
            return mixOrder.cabOrder.cabOrderStatus != 3;
          }else{
            return mixOrder.order.orderStatus != 3;
          }
    })
        .toList().reversed.toList();
  }

  List<MixOrder> mixedOrderList() {
    List<MixOrder> _list = [];

    //add order
    _list.addAll(cabOrders.map((order) => MixOrder(isCabOrder: true,cabOrder: order)).toList());
    _list.addAll(orders.map((order) => MixOrder(isCabOrder: false,order: order)).toList());

    _list.sort((a,b) {
      if(a.isCabOrder){
        if(b.isCabOrder){
          return a.cabOrder.createdAt.compareTo(b.cabOrder.createdAt);
        }else{
          return a.cabOrder.createdAt.compareTo(b.order.createdAt);
        }
      }else{
        if(b.isCabOrder){
          return a.order.createdAt.compareTo(b.cabOrder.createdAt);
        }else{
          return a.order.createdAt.compareTo(b.order.createdAt);
        }
      }
    });

    return _list;

  }


  String userAddress(int addressId){
    int index = addresses.indexWhere((add) => add.userAddressId == addressId);
    if(index != -1){
      return addresses[index].userAddressName;
    }else{
      return "Address not found";
    }
  }


  loadAddress() async{
    var responseData = await http.Client().get(Uri.parse(getFullPath('useraddress')),headers: await getHeader());
    String jsonString = responseData.body;
    var response = json.decode(jsonString);
    print("Response $response");
    addresses.clear();
    for(var i in response){
      addresses.add(Address.fromJson(i));
    }
  }


  @override
  Widget build(BuildContext context) {
    return DoubleBack(
        message:"Press back again to close",
        onFirstBackPress: (c)=>Get.offAll(HomeScreen()),
        child:DefaultTabController(
      length: 2,
      child: Scaffold(
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

            ListView.builder(
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
                            Get.offAll(HomeScreen(currentMenu: 0,));
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
                          textColor: index == 0 ? Colors.white : Colors.black,
                          color: index == 0 ? AppColors.themeColor.primaryColor : Colors.transparent,
                        ),
                      ));

                })]),
        ),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Orders',
            style: AppTextStyle.pageTitleStyle,
          ),
          leading: IconButton(
            onPressed: () {
              _key.currentState.openDrawer();
            },
            icon: Icon(Ionicons.filter, color: Colors.white),
          ),
          /*leading: widget.showBack
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.navigate_before_outlined,
                    color: AppColors.themeColor.primaryIconColor,
                    size: 35,
                  ),
                )
              : SizedBox(),*/
          bottom: TabBar(
            onTap: (index) {},
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            indicatorWeight: 2,
            indicatorColor: AppColors.themeColor.primaryColor,

            labelColor: AppColors.themeColor.buttonTextColor,
            unselectedLabelColor:
                AppColors.themeColor.buttonTextColor.withOpacity(0.5),
            //labelStyle: AppTextStyle.tabTextStyle,
            //unselectedLabelStyle: AppTextStyle.tabUnselectedTextStyle,
            tabs: [
              Tab(
                text: "Ongoing",
              ),
              Tab(
                text: "Completed",
              ),
              /* Tab(
                  child: Text(
                'Completed',
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              )),*/
            ],
          ),
        ),
        body: isLogin ? TabBarView(
          children: [
            RefreshIndicator(
                onRefresh: () {
                  return loadAll();
                },
                child: mixedListWidget(mixedOngoingList())  /*SingleChildScrollView(child:Column(
                    children: [
                      OngoingScreen2(onGoingOrderList2()),
                      OngoingScreen(onGoingOrderList())
                    ]))*/

            ), //Tab 1
            RefreshIndicator(
                onRefresh: () {
                  return loadAll();
                },
                child: mixedListWidget(mixedCompletedList()) /*SingleChildScrollView(child:Column(
                    children: [

                      CompletedScreen2(onCompletedOrderList2()),
                      CompletedScreen(onCompletedOrderList())

                    ]))*/), //Tab 2
          ],
        ):LoginWidget(),
      ),
    ));
  }

  Widget mixedListWidget(List<MixOrder> list){
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {

        MixOrder mixOrder = list[index];
        if(mixOrder.isCabOrder){
          return cabOrderItem(mixOrder.cabOrder);
        }else{
          return orderItem(mixOrder.order);
        }

    },);
  }

  Widget orderItem(Order order){
    return GestureDetector(
        onTap: () {
          Get.to<int>(OngoingDetailScreen(order, () {
            setState(() {
              //widget.orders[index].orderStatus = 4;
            });
          }));
        },
        child: Container(
          margin: EdgeInsets.only(top: 15,left: 15,right: 15),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Id:#${order.orderId}',
                            style: kAppTextStyle,
                          ),
                          Text(
                            '${orderStatus[order.orderStatus]}',
                            style: TextStyle(
                                color: statusColors[order.orderStatus],
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: new DecorationImage(
                                image: new NetworkImage(
                                    'https://images.pexels.com/photos/2255935/pexels-photo-2255935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                'Door To Door Delivery',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15 ),
                              ),
                              Text(
                                //'asdadan a ahdkad hkjhad ahkakdhd  adkahdkadhk aydaasdh a daudaagdahd aadahj khasdas dadgag asdgashgdasy aghdhgasd hgasd adya',
                                '${userAddress(order.userAddressId)}',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          )),
                          Container(
                            height: 25,
                            width: 60,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor),
                            child: Center(
                              child: Text(
                                '₹${order.orderTotal}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if(order.orderStatus == 3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                reorders(order);
                                //Get.to(WriteAReview(product.productId));
                              },
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: kPrimaryColor),
                                child: Center(
                                  child: Text(
                                    'Reorders',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ))
                        ],
                      ),

                      SizedBox(height: 10,)

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void reorders(Order order) async {
    //Utils.showToast("Coming soon!");

    List<OrderProduct> products = [];

    var response = await http.Client().get(Uri.parse(getFullPath('order')+"/${order.orderId}"),headers: await getHeader());

    final String jsonString = response.body;

    cartService.clearCart();

    jsonString.jsonList((e) {
      Utils.printMap(e);
      //products.add(OrderProduct().fromJson(e));
      //OrderProduct().fromJson(e);

      OrderProduct orderProduct = OrderProduct().fromJson(e);

      cartService.addProduct(orderProduct.productId,
          productName: orderProduct.productName,
          unitId: orderProduct.priceUnitId,
          img: orderProduct.productImg,
          productPrice: orderProduct.productPrice,
          unitInGram: 500,
          unitName: orderProduct.priceUnitName);
    });

    // products.map((product) {
    //
    // });


    Get.to(CartScreen());

  }

  Widget cabOrderItem(CabOrder order){
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CabTrackingScreen(order)));
        },
        child: Container(
          margin: EdgeInsets.only(top: 15,left: 15,right: 15),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID:#${order.cabOrderId}',
                            style: kAppTextStyle,
                          ),
                          Text(
                            '${orderStatus[order.cabOrderStatus]}',
                            style: TextStyle(
                                color: statusColors[order.cabOrderStatus],
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            padding: EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                              color: AppColors.themeColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppAssets.cab),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cab ID ${order.cabId}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                  child: Text(
                                    '${order.userAddress} - ${order.userPincode}',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    //overflow: TextOverflow.ellipsis,
                                    //maxLines: 2,
                                  )),
                            ],
                          ),



                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

}


