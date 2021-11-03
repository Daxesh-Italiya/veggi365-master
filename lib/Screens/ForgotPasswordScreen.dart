import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veggi/Components/Input_Field_Simple.dart';
import 'package:veggi/Components/Round_MaterialButton.dart';
import 'package:veggi/Screens/OtpScreen.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/themes/app_strings.dart';

import '../Constants.dart';
import 'ResetPasswordScreen.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneController = TextEditingController();


  void onReset() async{
    if (phoneController.text.isEmpty) {
      return showToast('Please Enter Your Phone Number');
    }else if (phoneController.text.length < 10) {
      return showToast('Phone Number Must Contains 10 Numbers');
    }

    var data = {
      'phone': phoneController.text,
    };

    try {
      var response =
          await http.post(Uri.parse(AppConstants.API_FORGOT_PASSWORD), body: data);

      var message = jsonDecode(response.body);
      print(message);
      print('response $message');
      print("response ${response.body}");
      print("Token -> ${message["token"]}");
      print("data --> ${json.encode(data)}");

      if (message["status"] == 'success') {


          String otpToken = message["otptoken"];
          String tempToken = message["temptoken"];

          Get.to(OtpScreen(otpToken,tempToken,isPasswordReset:true));

      } else {
        showToast(
          message["msg"] ?? AppStrings.commonErrMsg,
        );

      }
    } on Exception catch (e) {

      showToast(
        AppStrings.commonErrMsg,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 40.0,
                  ),
                  Image.asset(
                    'assets/icons/Group 61295.png',
                    height: 50,
                  ),

                  Flexible(
                      flex: 2,
                      child: SizedBox()),


                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 15.0)
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/icons/forgot.png',
                                    width: 20, height: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            InputFieldSimple(
                              controller: phoneController,
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone_android,
                                  color: Colors.black54),
                              type: TextInputType.phone,
                            ),
                            SizedBox(height: 50),
                          /*  Center(
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),*/
                            SizedBox(height: 30),
                            RoundMaterialButton(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              color: kPrimaryColor,
                              circular: 10.0,
                              onPress: () {

                                onReset();
                              /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordScreen()));*/


                              },
                              textStyle: kButtonStyleWhiteBold,
                              buttonText: 'Submit',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
