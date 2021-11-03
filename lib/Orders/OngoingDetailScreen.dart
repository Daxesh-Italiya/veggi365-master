import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/Orders/OrderTrackingScreen.dart';
import 'package:veggi/Orders/WriteAReviewScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/order_product_response_entity.dart';
import 'package:veggi/core/models/order_response_entity.dart';

import '../Constants.dart';
import 'OrderStatusScreen.dart';
import 'package:http/http.dart' as http;
import 'package:json_helpers/json_helpers.dart';

class OngoingDetailScreen extends StatefulWidget {

  final Order order;
  final Function onCancel;

  OngoingDetailScreen(this.order,this.onCancel);

  @override
  _OngoingDetailScreenState createState() => _OngoingDetailScreenState();
}

class _OngoingDetailScreenState extends State<OngoingDetailScreen> {
  var _counter = 0;

  List<String> orderStatus = [
    "Pending",
    "Accepted",
    "Ongoing",
    "Completed",
    "Cancelled"
  ];

  bool isLoading = true;
  List<OrderProduct> products = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProduct();
  }

  String getFormattedDate(String date) {
    /// Convert into local date format.
    var localDate = DateTime.parse(date).toLocal();

    /// inputFormat - format getting from api or other func.
    /// e.g If 2021-05-27 9:34:12.781341 then format should be yyyy-MM-dd HH:mm
    /// If 27/05/2021 9:34:12.781341 then format should be dd/MM/yyyy HH:mm
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }



  Future<String> getOrders() async{
    var response = await http.Client().get(Uri.parse(getFullPath('order')+"/${widget.order.orderId}"),headers: await getHeader());
    print(getFullPath('order'));
    print(response.body);
    return response.body;
  }

  loadProduct() async{
    isLoading = true;


    final String jsonString = await getOrders();
    //Iterable l = json.decode(jsonString);

    //products = List<OrderProduct>.from(l.map((model)=> OrderProduct().fromJson(model)));
    //products= List< OrderProduct >.from(l.map((i) => OrderProduct().fromJson(i)));
   jsonString.jsonList((e) {
     Utils.printMap(e);
     products.add(OrderProduct().fromJson(e));
     //OrderProduct().fromJson(e);
    });

    //String test = json.encode(response);

    //response = json.decode(jsonString);

    // products = (json.decode(test) as List)
    //     .map((data) => OrderProduct().fromJson(data))
    //     .toList();

    //print("Response ${l.toString()}");
    // products.clear();
    //
    // for(var i in response){
    //   String test = json.encode(i);
    //   products.add(OrderProduct().fromJson(json.decode(test)));
    //   //print("Data --> $i");
    // }

    setState(() {
      isLoading = false;
    });
    //print("Address ${addresses[0].cityName}");
    // return products;
  }

  double totalAmount() {
    double total = 0;
    products.forEach((product) {
      total = total + (product.productPrice * product.orderQuantity);
    });
    return total;
  }

  double finalAmount() {
    return totalAmount() + 0 - 0;
  }

  confirmCancel() async{

    Get.defaultDialog(
      title: "Cancel Order",
      middleText: "Are you sure that want to cancel order?",

      barrierDismissible: true,
      radius: 10.0,
      confirm: GFButton(
        onPressed: (){
          cancelOrder();
          Get.back();
        },
        text: "Yes",
        color: AppColors.themeColor.primaryColor,
      ),
      cancel:  GFButton(
        onPressed: (){
          Get.back();
        },
        text: "No",
        type: GFButtonType.outline,
        color: AppColors.themeColor.primaryColor,
      ),
    );

  }


  void cancelOrder() async{

    //widget.order.orderStatus = 4;

    //Get.back();
    //return;

    var body = {
      "order_id":widget.order.orderId
    };
    var response = await http.Client().patch(Uri.parse(getFullPath('order/cancel')),body: json.encode(body),headers: await getHeader());

    var messsage = json.decode(response.body);
    if(messsage["status"] == "success"){
      Utils.showToast("Your order is cancelled!");
      widget.order.orderStatus = 4;
      widget.onCancel();
      Get.back();
    }else{
      Utils.showToast("Order cancel failed!");
    }
    //print(getFullPath('order'));
    //print(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          '${orderStatus[widget.order.orderStatus]}',
          style: AppTextStyle.pageTitleStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 35),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${widget.order.orderId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                '${getFormattedDate(widget.order.createdAt)}',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {

                    OrderProduct product = products[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(

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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 5, right: 10),
                              child: Container(
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: new DecorationImage(
                                              image: new NetworkImage(
                                                  product.productImg ?? ""),
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
                                              '${product.productName}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '₹ ${product.productPrice} per/${product.priceUnitName}',
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
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: kPrimaryColor),
                                              child: Center(
                                                child: Text(
                                                  '₹${product.productPrice * product.orderQuantity}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),


                                        Text(
                                          '',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: kPrimaryColor),
                                            child: Center(
                                              child: Icon(Icons.remove,
                                                  color: Colors.white,
                                                  size: 20),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '  ${product.orderQuantity}  ',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: kPrimaryColor),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 5,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                widget.order.orderStatus == 3 ? GestureDetector(
                                    onTap: () {
                                      Get.to(WriteAReview(product.productId));
                                    },
                                    child: Container(
                                      //height: 23,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          color: kPrimaryColor),
                                      child: Center(
                                        child: Text(
                                          'Write a Review',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    )):SizedBox()

                              ],
                            )

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xffE0EBD6),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Total',
                            style: kToPayStyle1,
                          ),
                          Text(
                            '₹${totalAmount()}',
                            style: kToPayStyle1,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Texes & Charges',
                            style: kToPayStyle1,
                          ),
                          Text(
                            '₹0',
                            style: kToPayStyle1,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Discount',
                            style: kToPayStyle,
                          ),
                          Text(
                            '₹0',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Pay',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            '₹${finalAmount()}',
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
              ),
              SizedBox(height: 20),
              (widget.order.orderStatus == 0) ? GestureDetector(
                onTap: () {
                  //cancelOrder();
                  confirmCancel();
                },
                child: Container(
                  child: Center(
                    child: Text(
                      'Cancel Order',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ):SizedBox(),
              SizedBox(height: 20),
              /*(widget.order.orderStatus == 3 || widget.order.orderStatus == 4) ? SizedBox() :*/GestureDetector(
                onTap: () {


                  Get.to(OrderTrackingScreen(widget.order));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => OrderStatusScreen()));
                },
                child: CustomButton(
                  height: 50,
                  text: 'Track Order',
                  color: kPrimaryColor,
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
