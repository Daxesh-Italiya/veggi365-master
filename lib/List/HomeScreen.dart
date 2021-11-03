import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:veggi/Cab/CartScreen.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';
import 'package:veggi/List/vegetable_list/VegetableList.dart';
import 'package:veggi/Orders/OrderScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_components.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/themes/app_assets.dart';
import 'package:veggi/themes/utility.dart';
import '../Constants.dart';
import '../Offers/OffersScreen.dart';
import '../Cab/CabScreen.dart';
import '../MyAccount/MyAccountScreen.dart';
import 'ListDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  final int currentMenu;

  HomeScreen({this.currentMenu = 2});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.currentMenu;
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      buildBottomIconItem(AppAssets.list_active, AppAssets.list, 'List'),
      buildBottomIconItem(AppAssets.offers_active, AppAssets.offers, 'Offers'),
      // buildBottomIconItem(AppAssets.cab, AppAssets.cab, 'Cab'),
      BottomNavigationBarItem(
        label: '',
        icon: SizedBox(),
        activeIcon: SizedBox(),
      ),
      buildBottomIconItem(AppAssets.order_active, AppAssets.orders, 'Orders'),
      buildBottomIconItem(
          AppAssets.account_active, AppAssets.account, 'My Account'),
      // BottomNavigationBarItem(
      //   icon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       // 'assets/icons/Icon awesome-clipboard-list.png',
      //       AppAssets.list,
      //       height: 23,
      //     ),
      //   ),
      //   label: 'List',
      //   activeIcon: Padding(
      //     padding: EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       // 'assets/icons/Icon awesome-clipboard-list-1.png',
      //       AppAssets.list_active,
      //       height: 23,
      //     ),
      //   ),
      // ),
      // BottomNavigationBarItem(
      //   icon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child:
      //         Icon(Icons.local_offer_outlined, size: 23, color: Colors.black45),
      //   ),
      //   label: 'Offers',
      //   activeIcon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child:
      //         Icon(Icons.local_offer_outlined, size: 23, color: kPrimaryColor),
      //   ),
      // ),
      // BottomNavigationBarItem(
      //   icon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Icon(Icons.car_rental, size: 23, color: Colors.black45),
      //   ),
      //   label: 'Cab',
      //   activeIcon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Icon(Icons.car_rental, size: 23, color: kPrimaryColor),
      //   ),
      // ),
      // BottomNavigationBarItem(
      //   icon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       'assets/icons/Icon awesome-clipboard-list.png',
      //       height: 23,
      //     ),
      //   ),
      //   label: 'Orders',
      //   activeIcon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       'assets/icons/Icon awesome-clipboard-list-1.png',
      //       height: 23,
      //     ),
      //   ),
      // ),
      // BottomNavigationBarItem(
      //   icon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       'assets/icons/user (12).png',
      //       height: 23,
      //     ),
      //   ),
      //   label: 'My Account',
      //   activeIcon: Padding(
      //     padding: const EdgeInsets.only(bottom: 7),
      //     child: Image.asset(
      //       'assets/icons/user (-1.png',
      //       height: 23,
      //     ),
      //   ),
      // ),
    ];
  }

  Container buildCabIcon() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.cab,
            color: Colors.white,
            height: 12,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Cab',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem buildBottomIconItem(
    String activeIcon,
    String icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Image.asset(
          icon,
          height: 23,
        ),
      ),
      label: label,
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Image.asset(
          activeIcon,
          height: 23,
        ),
      ),
    );
  }

  PageController pageController = PageController(
    initialPage: 2,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        _onItemTapped(index);
      },
      children: <Widget>[
        ListScreen(),
        OfferScreen(),
        CabScreen(),
        OrderScreen(),
        MyAccountScreen(),
      ],
    );
  }

  List<Widget> pagelist = <Widget>[
    ListScreen(),
    OfferScreen(),
    CabScreen(),
    OrderScreen(),
    MyAccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0 || index == 2) {
      //Utility.statusBarColorPrimaryBackGround();
    } else {
      //Utility.statusBarColorWhiteBackGround();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  FloatingActionButton(
        isExtended: true,
        backgroundColor: kPrimaryColor,
        onPressed: (){
          _onItemTapped(2);
        },
        child: Container(child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.cab,
                color: Colors.white,
                height: 12,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Cab',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

        ),),
      ),*/
      backgroundColor: Colors.black.withOpacity(0.1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
          height: 65,
          decoration: BoxDecoration(
            //color: Colors.white,
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(10),
            //     topRight: Radius.circular(10),
            //     bottomLeft: Radius.circular(10),
            //     bottomRight: Radius.circular(10)
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          //color: Colors.black12,
          child: Stack(children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white,
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.20,
                              //maxWidth: MediaQuery.of(context).size.width / 5.5
                              minHeight: 45),
                          icon: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  _selectedIndex == 0
                                      ? AppAssets.list_active
                                      : AppAssets.list,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "List",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedIndex == 0
                                        ? kPrimaryColor
                                        : Colors.black54),
                              )
                            ],
                          ),
                          color: Colors.white,
                          onPressed: () {
                            _onItemTapped(0);
                          },
                        ),
                        IconButton(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.20,
                              //maxWidth: MediaQuery.of(context).size.width / 5.5
                              minHeight: 45),
                          icon: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  _selectedIndex == 1
                                      ? AppAssets.offers_active
                                      : AppAssets.offers,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Offer",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedIndex == 1
                                        ? kPrimaryColor
                                        : Colors.black54),
                              )
                            ],
                          ),
                          color: Colors.white,
                          onPressed: () {
                            _onItemTapped(1);
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        IconButton(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.20,
                              //maxWidth: MediaQuery.of(context).size.width / 5.5
                              minHeight: 45),
                          icon: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  _selectedIndex == 3
                                      ? AppAssets.order_active
                                      : AppAssets.orders,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Order",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedIndex == 3
                                        ? kPrimaryColor
                                        : Colors.black54),
                              )
                            ],
                          ),
                          color: Colors.white,
                          onPressed: () {
                            _onItemTapped(3);
                          },
                        ),
                        IconButton(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.20,
                              //maxWidth: MediaQuery.of(context).size.width / 5.5
                              minHeight: 45),
                          icon: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  _selectedIndex == 4
                                      ? AppAssets.account_active
                                      : AppAssets.account,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "My Account",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedIndex == 4
                                        ? kPrimaryColor
                                        : Colors.black54),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              )
                            ],
                          ),
                          color: Colors.white,
                          onPressed: () {
                            _onItemTapped(4);
                          },
                        ),
                      ],
                    ))),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: 65,
                  width: 65,
                  child: FittedBox(
                      child: FloatingActionButton(
                    isExtended: true,
                    backgroundColor: kPrimaryColor,
                    onPressed: () {
                      _onItemTapped(2);
                    },
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.cab,
                            color: Colors.white,
                            height: 12,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Cab',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
            )
          ])),

      /* BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: buildBottomNavBarItems(),
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black54,
          selectedItemColor: kPrimaryColor,
          selectedLabelStyle: TextStyle(
            fontSize: 10,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
              fontSize: 10,
              color: Color(0xff284777),
              fontWeight: FontWeight.bold),
          onTap: _onItemTapped,
        ),*/
      body: pagelist[_selectedIndex],
    );
  }
}

/* Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.77,
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
                    ),
                    SizedBox(width: 5),
                    Container(
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
                    ),
                  ],
                ),
              ),
            ),*/
/*Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: Container(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 6,
                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 200,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    height: 170,
                                    width: 125,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),*/

class MixFreshVegTile extends StatefulWidget {

  Product products;
  ProductPrice price;
  final bool showAddToCart;

  MixFreshVegTile(this.products, this.price, {this.showAddToCart = false});

  @override
  _MixFreshVegTileState createState() => _MixFreshVegTileState();

}

class _MixFreshVegTileState extends State<MixFreshVegTile> {

  CartService cartService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListDetailScreen(
                        price: widget.price,
                        products: widget.products,
                      )));
        },
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)],
              borderRadius: BorderRadius.circular(5)),
          //margin: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child:
                      /*CachedNetworkImage(
              imageUrl:widget.products.productCoverImg,
              placeholder: (context, url) =>  AppComponents.loading,
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ) ,
            )*/
                      Container(
                          alignment: Alignment.center,
                          child: Container(
                              height: Get.width * 0.3,
                              width: Get.width * 0.3,
                              child: Stack(children: [
                                Center(
                                    child:CachedNetworkImage(
                                  imageUrl: widget.products.productCoverImg,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    alignment: Alignment.center,
                                    child: Text("No Image"),
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Image(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                )),
                                if (widget.products.totalQuantity == 0)
                                  Center(
                                      child: GFButton(
                                    text: "Sold Out",
                                    type: GFButtonType.solid,
                                    fullWidthButton: true,
                                    shape: GFButtonShape.standard,
                                    color: Colors.red.withOpacity(0.8),
                                    size: GFSize.MEDIUM,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ))
                              ])

                              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: new DecorationImage(
                  image: new NetworkImage(widget.products.productCoverImg),
                  fit: BoxFit.contain,
                ),
              ),*/
                              ))),
              /* Row(
            children: [
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
            ],
          ),*/

              SizedBox(height: 10),

              Text(
                widget.products.productName ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 5),

              Text(
                '${widget.price != null ? "₹ ${widget.price.productPrice.toString()} per ${widget.price.priceUnitName.toString()}" : "No Price"}',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),

              if (widget.showAddToCart)
                Container(
                  alignment: Alignment.center,
                  child: GFButton(
                    text: "Add To Cart",
                    type: GFButtonType.outline,
                    shape: GFButtonShape.standard,
                    color: AppColors.themeColor.primaryColor,
                    size: GFSize.SMALL,
                    textColor: AppColors.themeColor.primaryColor,
                    onPressed: () {
                      if (widget.products.totalQuantity == 0) {
                        Utils.showToast("Product is out of stock!");
                        return;
                      } else if (widget.price == null) {
                        Utils.showToast("You can't buy this product!");
                        return;
                      }

                      //add to cart
                      cartService.addProduct(widget.price.productId,
                          productName: widget.products.productName,
                          unitId: widget.price.priceUnitId,
                          img: widget.products.productCoverImg,
                          productPrice: widget.price.productPrice,
                          unitInGram: widget.price.unitInGram,
                          unitName: widget.price.priceUnitName);

                      Get.to(CartScreen());
                    },
                  ),
                )
            ],
          ),
        ));
  }

}

class ListTile extends StatefulWidget {
  @override
  _ListTileState createState() => _ListTileState();
}

class _ListTileState extends State<ListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: new DecorationImage(
                image: new NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpJpqG5HuIhxB2PcgNffqE3UrjJl6nDPpzuw&usqp=CAU'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Multi Vegetables',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
                fontFamily: 'regular'),
          ),
          SizedBox(height: 5),
          Text(
            '\$370 per/kg',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


class ListTile1 extends StatefulWidget {
  @override
  _ListTile1State createState() => _ListTile1State();
}


class _ListTile1State extends State<ListTile1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: new DecorationImage(
                image: new NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFvm1soHbG_bN1FkvEjPdqGLu5lzLvB2IaAw&usqp=CAU'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
              Icon(Icons.star, color: Colors.orangeAccent, size: 17),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Multi Vegetables',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
                fontFamily: 'regular'),
          ),
          SizedBox(height: 5),
          Text(
            '\$370 per/kg',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
