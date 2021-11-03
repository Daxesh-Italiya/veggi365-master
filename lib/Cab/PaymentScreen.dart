import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/models/order_payment_response_entity.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Constants.dart';

class PaymentScreen extends StatefulWidget {
  final int addressId;

  PaymentScreen(this.addressId);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectPayment = 0;

  List<String> payments = ["COD", "UPI ( Coming soon )", "Net Banking( Coming soon )"];

  CartService cartService = Get.find();

  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    checkOrder(
        orderId: "1",
        razorpayOrderId: response.orderId,
        razorpayPaymentId: response.paymentId,
        razorpaySignature: response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    // showDialogSuccess(context, "Payment Fail", callback: () {
    //   Navigator.pop(context);
    // });
    Utils.showDialog(context, "Payment Fail",icon: Icons.warning_amber_outlined,iconColor: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void onSelect(int value) {
    setState(() {
      selectPayment = value;
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
          'Payment Method',
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
                    ListView.builder(
                      itemCount: payments.length,
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
                                if(payments[index]=="COD")
                                Radio(
                                groupValue: selectPayment,
                                  value: index,
                                  activeColor: selectPayment == index
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  onChanged: (value) => onSelect(value),
                                )
                                else
                                  Radio(
                                    groupValue: selectPayment,
                                    value: index,
                                    activeColor: selectPayment == index
                                        ? Colors.transparent
                                        : Colors.transparent,

                                  )
                                ,
                                Text(
                                  payments[index],
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ),
                              ],

                            ),

                          ),

                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //insertOrder();
                confirmOrder();
                // Utils.showDialog(context, "Payment Fail",icon: Icons.warning_amber_outlined,iconColor: Colors.red,callback: (){
                //   Get.back();
                // });
              },
              child: CustomButton(
                height: 50,
                text: 'Place Order',
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  confirmOrder() async {
    Get.defaultDialog(
      title: "Confirm Order",
      middleText: "Are you sure that want to place order?",
      barrierDismissible: true,
      radius: 10.0,
      confirm: GFButton(
        onPressed: () {
          insertOrder();
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

  insertOrder() async {
    var data = {
      "total": cartService.finalAmount(),
      "user_address_id": widget.addressId,
      "item": cartService.productList,
      "payment": selectPayment,
      "basket":"${cartService.eligibleBasket() != null ? cartService.eligibleBasket().id : 0}",
    };

    var response = await http.Client().post(Uri.parse(URL_INSERT_ORDER),
        headers: await getHeader(), body: json.encode(data));
    var message = jsonDecode(response.body);

    OrderPaymentResponseEntity responseData =
        OrderPaymentResponseEntity().fromJson(message);

    if (responseData.status == "success") {
      //cartService.clearCart();

      if (selectPayment == 0) {
        cartService.clearCart();


        Utils.showDialog(context, "Order successful",buttonText: "View Orders",icon: Icons.check_circle_outline,iconColor: AppColors.themeColor.primaryColor,callback: (){
          Navigator.pop(context);
          Get.offAll(HomeScreen(
            currentMenu: 3,
          ));
        });

       /* showDialogSuccess(context, "Order successful", callback: () {
          Navigator.pop(context);
          Get.offAll(HomeScreen(
            currentMenu: 3,
          ));
          //Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderScreen(showBack: true,)));
        });*/
      } else {
        startPayment(responseData.payment);
      }
    } else {
      // showDialogSuccess(context, "Something went wrong", callback: () {
      //   Navigator.pop(context);
      // });
      Utils.showDialog(context, "Something went wrong",icon: Icons.warning_amber_outlined,iconColor: Colors.yellow);
    }
    print("Response ${response.body}");
  }

  checkOrder(
      {String orderId,
      String razorpayPaymentId,
      String razorpayOrderId,
      String razorpaySignature}) async {
    var data = {
      "order_id": orderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_order_id": razorpayOrderId,
      "razorpay_signature": razorpaySignature
    };

    var response = await http.Client().post(Uri.parse(URL_ORDER_PAYMENT_CHECK),
        headers: await getHeader(), body: json.encode(data));
    var message = jsonDecode(response.body);
    //OrderPaymentResponseEntity responseData = OrderPaymentResponseEntity().fromJson(message);

    if (message["status"] == "success") {
      cartService.clearCart();

      Utils.showDialog(context, "Order successful",buttonText: "View Orders",icon: Icons.check_circle_outline,iconColor: AppColors.themeColor.primaryColor,callback: (){
        Navigator.pop(context);
        Get.offAll(HomeScreen(
          currentMenu: 3,
        ));
      });

      // showDialogSuccess(context, "Order successful", callback: () {
      //   Navigator.pop(context);
      //   Get.offAll(HomeScreen(
      //     currentMenu: 3,
      //   ));
      //   //Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderScreen(showBack: true,)));
      // });
    } else {
      Utils.showDialog(context, "Something went wrong",icon: Icons.warning_amber_outlined,iconColor: Colors.yellow);
      // Utils.showDialog(context, "Something went wrong",iconColor: Colors.red, callback: () {
      //   Navigator.pop(context);
      // });
    }
    print("Response ${response.body}");
  }

  startPayment(OrderPaymentResponsePayment payment) async {
    var options = {
      'key': 'rzp_test_mCQYP1VXS2KYbo',
      "order_id": payment.id,
      'amount': payment.amount,
      'name': 'Veggi365 Order',
      "currency": "INR",

      'description': 'Home to Home delivery order | book a cab order',
      //'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };

    _razorpay.open(options);
  }
}


class CheckBox {
  var isSelected = false;

  CheckBox({this.isSelected = false});
}

