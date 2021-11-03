import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/List/CategoryProductList.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/Orders/CabOrderScreen.dart';
import 'package:veggi/Orders/OrderScreen.dart';
import 'package:veggi/Screens/LoginScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/cab_storage_entity.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/notification/notification_screen.dart';
import 'package:veggi/themes/utility.dart';
import '../Constants.dart';
import 'CartScreen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/core/models/pin_code_entity.dart';
import 'package:sliver_fab/sliver_fab.dart';

class SearchHeader extends SliverPersistentHeaderDelegate {
  final double minTopBarHeight = 100;
  final double maxTopBarHeight = 200;
  final String title;
  final IconData icon;
  final Widget search;

  SearchHeader({
    @required this.title,
    this.icon,
    this.search,
  });

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    var shrinkFactor = min(1, shrinkOffset / (maxExtent - minExtent));

    var topBar = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        height:
        max(maxTopBarHeight * (1 - shrinkFactor * 1.45), minTopBarHeight),
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 20,
            ),
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            )),
      ),
    );
    return Container(
      height: max(maxExtent - shrinkOffset, minExtent),
      child: Stack(
        fit: StackFit.loose,
        children: [
          if (shrinkFactor <= 0.5) topBar,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Container(
                alignment: Alignment.center,
                child: search,
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        color: Colors.green.withOpacity(0.23),
                      )
                    ]),
              ),
            ),
          ),
          if (shrinkFactor > 0.5) topBar,
        ],
      ),
    );
  }

  @override
  double get maxExtent => 230;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  final Widget searchBar;
  final Function onDrawer;
  final Function onNotification;

  CustomSliverDelegate({
    @required this.expandedHeight,
    @required this.onDrawer,
    @required this.onNotification,
    @required this.searchBar,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = (expandedHeight - shrinkOffset);
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2- (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;

    final cH = (expandedHeight * percent) + (expandedHeight/2);

    return Container(
      //color: expandedHeight + expandedHeight / 2 < kToolbarHeight ? Colors.transparent : AppColors.themeColor.primaryColor,
      height: cH > kToolbarHeight ? cH : Get.mediaQuery.padding.top + kToolbarHeight,
      //height: expandedHeight,
      color: Colors.black38,
      child: Stack(
        children: [
          SizedBox(
              height: appBarSize < kToolbarHeight ? Get.mediaQuery.padding.top + kToolbarHeight : appBarSize,
              child:AppBar(
              elevation: 0.0,

    //backgroundColor:Colors.yellow,
              //backgroundColor: AppColors.themeColor.primaryColor,
              leading:  IconButton(
                onPressed: () {onDrawer();
                },
                icon: Icon(Ionicons.filter, color: Colors.white),
              ),

              centerTitle: true,
              title:  Text('VEGGI365',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              actions: [
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
                    icon: Icon(Icons.notifications,
                        color: Colors.white))
              ],
          )),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0 * percent),
                child: searchBar,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => Get.mediaQuery.padding.top + kToolbarHeight;// kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CabScreen extends StatefulWidget {
  @override
  _CabScreenState createState() => _CabScreenState();
}

class _CabScreenState extends State<CabScreen> {
  List<PinCodeEntity> pincodes = [PinCodeEntity(cabId: 1, cabPincode: 382308)];

  List<CabStorageEntity> cabStorage = [];

  PinCodeEntity selectedPinCode = null;

  String setDate;
  DateTime selectedDate = DateTime.now();
  TextEditingController selectYourDate = TextEditingController();
  TextEditingController selectTime = TextEditingController();

  TextEditingController address = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();

  CartService cartService = Get.find();

  @override
  void initState() {
    Utility.statusBarColorPrimaryBackGround();
    super.initState();
    checkLogin();
    cartService.fetchProducts();
    //loadPincodes();
    loadStorage();
  }


  selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kPrimaryColor,
            accentColor: kPrimaryColor,
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      selectYourDate.text = DateFormat("dd-MM-yyyy").format(selectedDate);
      setState(() {});
    }
  }

  String _setTime, _setDate;
  String _hour, _minute, _time;

  bool isLogin = true;

  String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        selectTime.text = _time;
      });
  }
  void checkLogin()async{

    Utils.isLogin().then((value) {
      setState(() {
        isLogin = value;
      });
    });


  }

  loadPincodes() async {
    try {
      var responseData = await http.Client().get(
          Uri.parse(getFullPath('caborder/pincode')),
          headers: await getHeader());

      String jsonString = responseData.body;

      var response = json.decode(jsonString);
      print("Response $response");

      pincodes.clear();

      for (var i in response) {
        pincodes.add(PinCodeEntity().fromJson(i));
        print("Data --> $i");
      }

      setState(() {});
    } catch (e) {

    }
  }

  loadStorage() async {

    try {
      var responseData = await http.Client().get(
          Uri.parse(getFullPath('caborder/storage')),
          headers: await getHeader());

      String jsonString = responseData.body;

      var response = json.decode(jsonString);
      print("Response $response");

      cabStorage.clear();

      for (var i in response) {
        cabStorage.add(CabStorageEntity().fromJson(i));
        print("Data --> $i");
      }

      //cabStorage.add(CabStorageEntity(productId: 1,productName: "Test",productImg: "https://admin.veggi365.com/uploads/product_img-1630493126680.jpg",quantity: 500));

      setState(() {});
    }catch(e){

    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();


  Widget searchBar({double top = 80}){
    return Container(
        height: 50,
        //margin: EdgeInsets.only(top:top),
        //padding: EdgeInsets.symmetric(horizontal: 0),
        child:Row(
          children: [
            Expanded(child:Container(

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.7))
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
                        decoration: InputDecoration(
                            hintText: "Search",
                            contentPadding: EdgeInsets.only(top: 20),
                            hintStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(width: 15,),

            Container(
                width: 65,
                height: 50,
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
                child:InkWell(
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
                          (productList) =>
                          Badge(
                            position: BadgePosition.topEnd(end: -5),
                            badgeColor: Colors.red,
                            toAnimate: false,
                            padding: EdgeInsets.all(5),
                            shape: BadgeShape.circle,
                            showBadge: productList.isNotEmpty,
                            badgeContent: Text(
                              "${productList.length}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 23,
                              color: kPrimaryColor,
                            ),
                          ),
                      cartService.productList),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
        message:"Press back again to close",
        child:Scaffold(
      key: _key,
      drawerEnableOpenDragGesture: false,
      //backgroundColor: Colors.white60,
      drawer: Drawer(
        child: Obx(()=>Column(children: [
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
        ])),
      ),
      body: Container(child: SliverFab(
        //fit: StackFit.expand,
        topScalingEdge: 98,
          floatingWidget: Container(
    height: 50,
    width: Get.width,
    child:searchBar(top: 0)),
          floatingPosition: FloatingPosition(left: -15, top: -35,right: -15),
          expandedHeight: kToolbarHeight * 2,
        slivers: [


          /*GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: LatLng(22.3039, 70.8022), zoom: 7),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),*/

          SliverAppBar(
            leading:  IconButton(
      onPressed: () {
      _key.currentState.openDrawer();
      },
        icon: Icon(Ionicons.filter, color: Colors.white),
      ),
              pinned: true,
              //collapsedHeight: 56,
            expandedHeight: (kToolbarHeight + kToolbarHeight /2) -10,
              centerTitle: true,
              title:  Text('VEGGI365',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              actions: [
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
                    icon: Icon(Icons.notifications,
                        color: Colors.white))
              ],

              flexibleSpace: new FlexibleSpaceBar(
                  //title: new Text("SliverFab Example")
                /*title: new Text("SliverFab Example"),
                background: new Image.asset(
                  "img.jpg",
                  fit: BoxFit.cover,
                ),*/
              ),

            /*bottom: PreferredSize(
              preferredSize:  Size(MediaQuery.of(context).size.width, 40),
              child:searchBar(top: 10),

          )*/),


         /* ScalingHeader(
            backgroundColor: AppColors.themeColor.primaryColor,
            leading:  IconButton(
              onPressed: () {
                _key.currentState.openDrawer();
              },
              icon: Icon(Ionicons.filter, color: Colors.white),
            ),
            centerTitle: true,
            title:  Text('VEGGI365',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            actions: [
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
                  icon: Icon(Icons.notifications,
                      color: Colors.white))
            ],
            //flexibleSpaceHeight: 10,
            overlapContentHeight: 50,
            overlapContentBackgroundColor:AppColors.themeColor.primaryColor,
            overlapContent: searchBar(top: 0),
          ),*/

          /*SliverPersistentHeader(
            pinned: true,
            //floating: true,
            floating: true,
            delegate: CustomSliverDelegate(
              expandedHeight: 110,
              hideTitleWhenExpanded: false,
              onDrawer: (){
                _key.currentState.openDrawer();
              },
              onNotification: (){

              },
              searchBar: searchBar(top: 0)
            ),
          ),*/

         /* SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: SearchHeader(
              icon: Icons.terrain,
              title: 'Trees',
              search: ,
            ),
          ),*/


          // GFCarousel(
          //   aspectRatio: 16/9,
          //   //height: Get.width * 0.8,
          //   items: List.generate(3, (index) => Image.asset("assets/icons/slider.png",fit: BoxFit.fill,),),
          //   //enlargeMainPage: true,
          // ).sliverBox,

          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50,),
              child: Text(
                'For Door To Door Delivery',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    fontFamily: 'regular'),
                textAlign: TextAlign.center,
              )).sliverBox,

          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 5, bottom: 25),
              child: Text(
                'Click any category',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    fontFamily: 'regular'),
                textAlign: TextAlign.center,
              )).sliverBox,

          Container(child:Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Get.offAll(HomeScreen(currentMenu: 0));
                    },
                    child:Container(
                  height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.7))
                        ],
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: EdgeInsets.only(left: 15),
                  child: Image.asset("assets/icons/cat-1.png",fit: BoxFit.fill),
                )),
              ),

              SizedBox(width: 15,),

              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Get.offAll(HomeScreen(currentMenu: 0));
                    },
                    child:Container(
                  height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.7))
                        ],
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: EdgeInsets.only(right: 15),
                  child: Image.asset("assets/icons/cat-2.png",fit: BoxFit.fill,),
                )),
              )

            ],
          )).sliverBox,


          SizedBox(height: 15,).sliverBox,

          Container(child:Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Get.offAll(HomeScreen(currentMenu: 0));
                    },
                    child:Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.7))
                        ],
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: EdgeInsets.only(left: 15),
                      child: Image.asset("assets/icons/cat-3.png",fit: BoxFit.fill),
                    )),
              ),

              SizedBox(width: 15,),

              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Get.offAll(HomeScreen(currentMenu: 0));
                    },
                    child:Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.7))
                        ],
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: EdgeInsets.only(right: 15),
                      child: Image.asset("assets/icons/cat-4.png",fit: BoxFit.fill),
                    )),
              )

            ],
          )).sliverBox,


         /* Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                'Click on the below category',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'regular'),
              )).sliverBox,*/

          /* Expanded(child:Obx(()=>Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
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
                                  width: Get.width * 0.5,
                                  //height: 40,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //filterCategory = index - 1;
                                      });

                                      if (index == 0) {
                                        //Navigator.pop(context);
                                        Get.offAll(HomeScreen(currentMenu: 0,));
                                      } else {
                                        //Navigator.pop(context);
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
                            })))),*/

          /* Obx(()=>Container(
            alignment: Alignment.center,
            height: 50,
            child: ListView(
              //direction: Axis.horizontal,
                //runSpacing: 10,
                //spacing: 10,
              shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(cartService.category.length + 1, (index) {
                  String text = "";

                  if (index == 0) {
                    text = "All Categories";
                  } else {
                    text =
                    "${cartService.category[index - 1].categoryName}";
                  }

                  return GFButton(
                      onPressed: () {
                        if (index == 0) {
                          //Navigator.pop(context);
                          Get.offAll(HomeScreen(currentMenu: 0,));
                        } else {
                          //Navigator.pop(context);
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
                      text: text,
                      textColor: Colors.white,
                      color:
                      AppColors.themeColor.primaryColor

                  ).marginSymmetric(horizontal: 15,vertical: 10);


                }),
              ))).sliverBox,*/

          SizedBox(
            height: 25,
          ).sliverBox,
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 6)
              ],
            ),
            child: Image.asset(
              'assets/icons/cab.jpg',
              height: 170,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ).marginSymmetric(horizontal: 15).sliverBox,
          SizedBox(height: 10).sliverBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vegetable cab',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'regular'),
              ),
              SizedBox(),
              /*Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.orangeAccent, size: 17),
                            Icon(Icons.star,
                                color: Colors.orangeAccent, size: 17),
                            Icon(Icons.star,
                                color: Colors.orangeAccent, size: 17),
                            Icon(Icons.star,
                                color: Colors.orangeAccent, size: 17),
                            Icon(Icons.star,
                                color: Colors.orangeAccent, size: 17),
                          ],
                        ),*/
            ],
          ).marginSymmetric(horizontal: 15).sliverBox,
          SizedBox(height: 10).sliverBox,


          SizedBox(
            height: 5,
          ).sliverBox,
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.withOpacity(0.7))
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: address,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: "Address",
                  contentPadding: EdgeInsets.only(top: 20, left: 15),
                  hintStyle: TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none)),
            ),
          ).marginSymmetric(horizontal: 15).sliverBox,
          SizedBox(
            height: 10,
          ).sliverBox,
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.withOpacity(0.7))
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child:
            TextFormField(
                        controller: pinCode,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: "Pin Code",
                            contentPadding:
                            EdgeInsets.only(top: 20, left: 15),
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )

           /* FormField<PinCodeEntity>(
              builder: (FormFieldState<PinCodeEntity> pincode) {
                return InputDecorator(
                  decoration: InputDecoration(
                      hintText: "Address",
                      contentPadding:
                      EdgeInsets.only(top: 20, left: 15),
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none)),
                  isEmpty: PinCodeEntity == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PinCodeEntity>(
                      value: selectedPinCode,
                      isDense: true,
                      hint: Text("Pincode"),
                      onChanged: (PinCodeEntity newValue) {
                        setState(() {
                          selectedPinCode = newValue;
                        });
                      },
                      items: pincodes.map((PinCodeEntity value) {
                        return DropdownMenuItem<PinCodeEntity>(
                          value: value,
                          child: Text("${value.cabPincode}"),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),*/
          ).marginSymmetric(horizontal: 15).sliverBox,
          SizedBox(height: 20).sliverBox,
          GestureDetector(
            onTap: () {

              if(isLogin) {
                confirmOrder();
              }else{
                Get.offAll(LoginScreen());
              }
              //bookCab();
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CartScreen()));
            },
            child: Container(
              height: 50,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/Subtraction 1.png',
                        height: 20),
                    SizedBox(width: 10),
                    Text(
                      isLogin? 'Book Now':"Login & Book Cab",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ).marginSymmetric(horizontal: 15).sliverBox,
          SizedBox(
            height: 70,
          ).sliverBox
       ]
      ),
    )));
  }

  Container buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.25,
          ),
        ],
      ),
    );
  }

  confirmOrder() async {
    if (address.text.isEmpty) {
      Utils.showToast("Please enter address first");
      return;
    } else if (address.text.isEmpty) {
      Utils.showToast("Please enter pincode first");
      return;
    }else if (address.text.length != 6) {
      Utils.showToast("Please enter valid pincode");
      return;
    }

    Get.defaultDialog(
      title: "Confirm Cab Book",
      //middleText: "Are you sure that want to book a vegetable cab?",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure that want to book a vegetable cab?',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                //fontWeight: FontWeight.bold,
                fontFamily: 'regular'),
          ).marginSymmetric(horizontal: 15, vertical: 5),
          Container(
              height: 100,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: cabStorage.length,
                  itemBuilder: (context, index) {
                    CabStorageEntity entity = cabStorage[index];

                    return Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      width: Get.width / 4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5.0)
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      //margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: Get.width * 0.3,
                                      width: Get.width * 0.3,
                                      child: Stack(children: [
                                        Center(
                                            child: CachedNetworkImage(
                                              imageUrl: entity.productImg ?? "",
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Text("No Image"),
                                                  ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                  Image(
                                                    image: imageProvider,
                                                    fit: BoxFit.contain,
                                                  ),
                                            )),
                                        if (entity.quantity == 0)
                                          Center(
                                              child: GFButton(
                                                text: "Sold Out",
                                                type: GFButtonType.solid,
                                                fullWidthButton: true,
                                                shape: GFButtonShape.standard,
                                                color: Colors.red.withOpacity(
                                                    0.8),
                                                size: GFSize.MEDIUM,
                                                textColor: Colors.white,
                                                onPressed: () {},
                                              ))
                                      ])))),
                          SizedBox(height: 10),
                          Text(
                            entity.productName ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    );
                  })),
        ],
      ),
      barrierDismissible: true,
      radius: 10.0,
      confirm: GFButton(
        onPressed: () {
          bookCab();
          Get.back();
        },
        text: "Confirm",
        color: AppColors.themeColor.primaryColor,
      ),
      cancel: GFButton(
        onPressed: () {
          Get.back();
        },
        text: "Cancel",
        type: GFButtonType.outline,
        color: AppColors.themeColor.primaryColor,
      ),
    );
  }

  bookCab() async {
    /* if(selectYourDate.text.isEmpty){
    Utils.showToast("Please select date first");
    return;
    }else if(selectTime.text.isEmpty){
    Utils.showToast("Please enter time first");
    return;
    }else*/

    /*if(Storage.hasData("cab-book")){
      int timestamp = await Storage.getValue<int>("cab-book");

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

      DateTime before = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime now = DateTime.now();
      Duration timeDifference = now.difference(before);

      int minutes = timeDifference.inMinutes;

      if(minutes < 40){
        Utils.showToast("You can book a cab after ${40 - minutes} minutes");
        return;
      }
    }*/

    var data = {
      "user_address": address.text,
      "user_pincode": "${pinCode.text/*selectedPinCode.cabPincode*/}",
      //"date":selectYourDate.text,
      //"time":selectTime.text
    };

    var response = await http.Client().post(Uri.parse(URL_CAB_ORDER),
        headers: await getHeader(), body: json.encode(data));
    var message = jsonDecode(response.body);
    if (message["status"] == "success") {
      int timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      Storage.saveValue("cab-book", timestamp);

      Utils.showDialog(context, "Order successful",
          buttonText: "View Orders",
          icon: Icons.check_circle_outline,
          iconColor: AppColors.themeColor.primaryColor, callback: () {
            Navigator.pop(context);
            Get.offAll(HomeScreen(
              currentMenu: 3,
            ));
          });

      // showDialogSuccess(context, "Order successful", callback: () {
      //   Navigator.pop(context);
      //   Get.offAll(HomeScreen(currentMenu: 3,));
      //   //Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderScreen(showBack: true,)));
      //   //Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderScreen(showBack: true,)));
      // });
    } else {
      // showDialogSuccess(context, "Something went wrong", callback: () {
      //   Navigator.pop(context);
      // });
      Utils.showDialog(context, "Something went wrong", iconColor: Colors.red,
          callback: () {
            Navigator.pop(context);
          });
    }
    print("Response ${response.body}");
  }
}
