import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/cab_order_response_entity.dart';
import 'package:veggi/core/models/order_product_response_entity.dart';
import 'package:veggi/core/models/order_response_entity.dart';

import 'package:timelines/timelines.dart';

import '../Constants.dart';
import 'OrderStatusScreen.dart';
import 'package:http/http.dart' as http;
import 'package:json_helpers/json_helpers.dart';

class OrderTrackingScreen extends StatefulWidget {

  final Order order;
  OrderTrackingScreen(this.order);

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {

  List<String> orderStatus = ["Pending","Accepted","Ongoing","Completed"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //widget.order.cabOrderStatus = 2;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Order Status',
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
    padding: EdgeInsets.all(15),
    child:Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                      Container(
                      alignment: Alignment.centerLeft,
                      child:Text(
                '#${widget.order.orderId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),

                        Text(
                          '${getFormattedDate(widget.order.createdAt)}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),


                    SizedBox(height: 5,),
                    Container(
                        alignment: Alignment.centerLeft,
                        child:Text(
                          '',
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          //overflow: TextOverflow.ellipsis,
                          //maxLines: 2,
                        )),
                  ])),


              SizedBox(height: 15),

              Expanded(child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FixedTimeline.tileBuilder(
                    theme: TimelineThemeData(
                      nodePosition: 0,
                      color: Color(0xff989898),
                      indicatorTheme: IndicatorThemeData(
                        position: 0,
                        size: 20.0,
                      ),
                      connectorTheme: ConnectorThemeData(
                        thickness: 2.5,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.after,
                      itemCount: orderStatus.length,
                      contentsBuilder: (_, index) {
                        //if (index == 2) return null;

                        return Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [



                              Text(
                                orderStatus[index],
                                style: TextStyle(
                                    color: widget.order.orderStatus >= index ? AppColors.themeColor.primaryColor : Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              //_InnerTimeline(messages: processes[index].messages),

                              Container(
                                height: Get.width * 0.2,
                              )

                            ],
                          ),
                        );
                      },
                      indicatorBuilder: (_, index) {

                        bool completed = false;

                        Widget icon = Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.0,
                        );

                        if(widget.order.orderStatus >= index){
                          completed =true;
                        }

                        /*if(index == 0){
                          icon = Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 12.0,
                          );
                        }else  if(index == 1){
                          icon = Icon(
                            Icons.de,
                            color: Colors.white,
                            size: 12.0,
                          );
                        }*/

                        if (completed) {
                          return DotIndicator(
                            color: AppColors.themeColor.primaryColor,
                            child: icon,
                          );
                        } else {
                          return OutlinedDotIndicator(
                            borderWidth: 2.5,
                          );
                        }
                      },
                      connectorBuilder: (_, index, ___) => SolidLineConnector(
                        color: null//index == 3 ? AppColors.themeColor.primaryColor : null,
                      ),
                    ),
                  ),
                )),
            ],
          )),
    );
  }



}


