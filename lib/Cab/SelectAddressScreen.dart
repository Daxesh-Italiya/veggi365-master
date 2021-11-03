import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:veggi/Cab/Model/Address.dart';
import 'package:veggi/Cab/PaymentScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/Orders/OrderScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/order_payment_response_entity.dart';
//import 'package:veggi/core/models/address_response_entity.dart';
import 'package:veggi/core/services/api_service.dart';
import 'package:veggi/core/services/cart_service.dart';

import '../Constants.dart';
import 'AddNewAddress.dart';

class SelectAddressScreen extends StatefulWidget {
  SelectAddressScreen();

  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  int selectCard = 1;
  var isLoading = true;

  CartService cartService = Get.find();

  List<Address> addresses = [];
  List<CheckBox> isSelected = [];


  ApiService api = Get.find();
  //AddressResponseEntity addressResponseEntity = null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAddress();
    //loadAddressData();
  }



  void onSelect(int value) {
    setState(() {
      selectCard = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Select Address',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading ?Center(child: CircularProgressIndicator()):ListView.builder(
                      itemCount: addresses.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  groupValue: selectCard,
                                  value: index + 1,
                                  activeColor: selectCard == index + 1
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  onChanged: (value) => onSelect(value),
                                ),
                                Expanded(
                                  child:Text(
                                    addresses[index].fullAddress,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13),
                                  )
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {

                        Get.to(AddNewAddressScreen()).then((value) {
                          loadAddress();
                        });

                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewAddressScreen()));*/
                      },
                      child: Container(
                        child: Text(
                          '+ Add New Address',
                          style: kTextStyleDarkGreenMediumSmall,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {

                if(addresses.length == 0){
                  Utils.showToast("Please select address first!");
                  return;
                }
                Get.to(PaymentScreen(addresses[selectCard -1].userAddressId));
              },
              child: CustomButton(
                height: 50,
                text: 'Next',
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  insertOrder()async{
    setState(() {
      isLoading = true;
    });


    var data = {
      "total": cartService.finalAmount(),
      "user_address_id": addresses[selectCard -1].userAddressId,
      "item": cartService.productList
    };

    var response = await http.Client().post(Uri.parse(URL_INSERT_ORDER),headers: await getHeader()
        ,body:json.encode(data));
    var message = jsonDecode(response.body);

    OrderPaymentResponseEntity responseData = OrderPaymentResponseEntity().fromJson(message);

    if(responseData.status == "success"){
      cartService.clearCart();

      startPayment(responseData.payment);

     /* showDialogSuccess(context,"Order successful",callback: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderScreen(showBack: true,)));
      });*/

    }else{
      showDialogSuccess(context,"Something went wrong",callback: (){
        Navigator.pop(context);
      });
    }
    setState(() {
      isLoading = false;
    });
    print("Response ${response.body}");
  }

  startPayment(OrderPaymentResponsePayment payment) async {


  }

  Future<String> getAddress() async{
    var response = await http.Client().get(Uri.parse(getFullPath('useraddress')),headers: await getHeader());
    print(getFullPath('useraddress'));
    print(response.body);
    return response.body;
  }

  loadAddress() async{
    isLoading = true;
    String jsonString = await getAddress();

    var response = json.decode(jsonString);
    print("Response $response");

    addresses.clear();

    for(var i in response){
      addresses.add(Address.fromJson(i));
      isSelected.add(CheckBox(isSelected: false));
      print("Data --> $i");
    }

    setState(() {
      isLoading = false;
    });
    //print("Address ${addresses[0].cityName}");
    // return products;
  }
}

class BookingSuccess extends StatelessWidget {

  var message = "Successfull";
  var buttonText = "View Order";
  Function() callBack;

  BookingSuccess(this.message,{this.buttonText,this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              // height: 260,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.check_circle_outline_sharp,
                      color: kPrimaryColor, size: 100),
                  SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kPrimaryColor,
                        
                        decoration: TextDecoration.none,
                        fontSize: 22),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: GestureDetector(
                      child: CustomButton(
                        height: 40,
                        text: buttonText,
                        color: kPrimaryColor,
                      ),
                      onTap: (){
                        callBack?.call();
                      },
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

class CheckBox{
  var isSelected = false;

  CheckBox({this.isSelected = false});
}

Future showDialogSuccess(BuildContext context,message,{buttonText = "View Order",Function() callback}) async {
  await showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return BookingSuccess(message,buttonText: buttonText,callBack: ()=> callback?.call(),);
    },
    animationType: DialogTransitionType.fadeScale,
    curve: Curves.fastOutSlowIn,
    duration: Duration(seconds: 1),
  );
}