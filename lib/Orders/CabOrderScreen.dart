import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:veggi/Components/Write_review.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/Orders/CabTrackingScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/models/cab_order_response_entity.dart';
import 'package:veggi/core/models/order_response_entity.dart';
import 'package:veggi/themes/app_assets.dart';
import 'package:veggi/themes/utility.dart';

import '../Constants.dart';
import 'OngoingDetailScreen.dart';
import 'package:http/http.dart' as http;

class CabOrderScreen extends StatefulWidget {

  final bool showBack;
  CabOrderScreen({this.showBack = false});

  @override
  _CabOrderScreenState createState() => _CabOrderScreenState();
}

class _CabOrderScreenState extends State<CabOrderScreen> {

  var isLoading = true;
  List<CabOrder> orders = [];

  @override
  void initState() {
    Utility.statusBarColorPrimaryBackGround();
    super.initState();
    loadOrders();
  }

  Future<String> getOrders() async{
    var response = await http.Client().get(Uri.parse(getFullPath('caborder')),headers: await getHeader());
    print(getFullPath('order'));
    print(response.body);
    return response.body;
  }

  loadOrders() async{

    setState(() {
      isLoading = true;
    });

    String jsonString = await getOrders();

    var response = json.decode(jsonString);
    print("Response $response");

    orders.clear();

    for(var i in response){

      orders.add(CabOrder().fromJson(i));
      print("Data --> $i");

    }

    setState(() {
      isLoading = false;
    });
    //print("Address ${addresses[0].cityName}");
    // return products;
  }

  List<CabOrder> onGoingOrderList(){
    return orders.where((order) => order.cabOrderStatus != 3).toList();
  }

  List<CabOrder> onCompletedOrderList(){
    return orders.where((order) => order.cabOrderStatus == 3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Cab Orders',
            style: AppTextStyle.pageTitleStyle,
          ),
          leading: widget.showBack ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor,
              size: 35,
            ),
          ):SizedBox(),
          bottom: TabBar(
            onTap: (index) {},
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            indicatorWeight: 2,
            indicatorColor: AppColors.themeColor.primaryColor,

            labelColor: AppColors.themeColor.buttonTextColor,
            unselectedLabelColor: AppColors.themeColor.buttonTextColor.withOpacity(0.5),
            //labelStyle: AppTextStyle.tabTextStyle,
            //unselectedLabelStyle: AppTextStyle.tabUnselectedTextStyle,
            tabs: [
              Tab(text: "Ongoing",),
              Tab(text: "Completed",),
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
        body: TabBarView(
          children: [
            RefreshIndicator(
            onRefresh: () {
      return loadOrders();
      },
        child: OngoingScreen(onGoingOrderList())), //Tab 1
      RefreshIndicator(
        onRefresh: () {
          return loadOrders();
        },
        child: CompletedScreen(onCompletedOrderList())), //Tab 2
          ],
        ),
      ),
    );
  }
}




class OngoingScreen extends StatefulWidget {

  final List<CabOrder> orders;

  OngoingScreen(this.orders);

  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {


  List<String> orderStatus = ["Pending","Accepted","Ongoing","Completed","Cancelled"];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.orders.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          CabOrder order = widget.orders[index];

          return Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CabTrackingScreen(order)));
              },
              child: Container(
                height: 100,
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
                                      color: kPrimaryColor,
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
                                    SizedBox(height: 5,),
                                    Container(child:Text(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}

class CompletedScreen extends StatefulWidget {

  final List<CabOrder> orders;

  CompletedScreen(this.orders);

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {


  List<String> orderStatus = ["Pending","Accepted","Ongoing","Completed","Cancelled"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.orders.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          CabOrder order = widget.orders[index];

          return Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CabTrackingScreen(order)));
              },
              child: Container(
                height: 100,
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
                                      color: kPrimaryColor,
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
                                    SizedBox(height: 5,),
                                    Container(child:Text(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
