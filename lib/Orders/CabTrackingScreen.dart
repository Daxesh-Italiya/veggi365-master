import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
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

class CabTrackingScreen extends StatefulWidget {

  final CabOrder order;

  CabTrackingScreen(this.order);

  @override
  _CabTrackingScreenState createState() => _CabTrackingScreenState();

}

class _CabTrackingScreenState extends State<CabTrackingScreen> {

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

  confirmCancel() async{

    Get.defaultDialog(
      title: "Cancel Cab",
      middleText: "Are you sure that want to cancel cab?",

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
      "order_id":widget.order.cabOrderId,
      "cab_order_status":5
    };
    var response = await http.Client().patch(Uri.parse(getFullPath('caborder/cancel')),body: json.encode(body),headers: await getHeader());

    var messsage = json.decode(response.body);
    if(messsage["status"] == "success"){
      Utils.showToast("Your cab is cancelled!");
      widget.order.cabOrderStatus = 5;
      //widget.onCancel();
      Get.back();
    }else{
      Utils.showToast("Cab cancel failed!");
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
          'Cab Order Status',
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
                '#${widget.order.cabOrderId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),

                        SizedBox(height: 2,),
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
                          '${widget.order.userAddress} - ${widget.order.userPincode}',
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
                                    color: widget.order.cabOrderStatus >= index ? AppColors.themeColor.primaryColor : Colors.black26,
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

                        if(widget.order.cabOrderStatus >= index){
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

              (widget.order.cabOrderStatus == 0) ? Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 20),
                  child: GestureDetector(
                onTap: () {
                  //cancelOrder();
                  confirmCancel();
                },
                child: Container(
                  child: Center(
                    child: Text(
                      'Cancel Cab',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              )):SizedBox(),

            ],
          )),
    );
  }



}


