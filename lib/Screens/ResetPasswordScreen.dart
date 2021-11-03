import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/Components/Input_Field_Simple.dart';
import 'package:veggi/Components/Round_MaterialButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/services/fcm_service.dart';
import 'package:veggi/themes/app_strings.dart';
import 'package:veggi/ui/views/address/FirstPage.dart';

import '../Constants.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {


  final String tempToken;
  ResetPasswordScreen(this.tempToken);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  FCMService fcmService = Get.find();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void onSubmit()async {
    if (newPasswordController.text.isEmpty) {
      return showToast('Please Enter Your New Password');
    } else if (newPasswordController.text.length < 4) {
      return showToast('Password Must Contains 8 Characters');
    }else if (confirmPasswordController.text.isEmpty) {
      return showToast('Please Enter Your Confirm Password');
    }else if (newPasswordController.text != confirmPasswordController.text) {
      return showToast('Confirm Password not matched!');
    }


    var data = {
      'password': newPasswordController.text,
      "temptoken":widget.tempToken
    };

    try {
      var response =
      await http.post(Uri.parse(AppConstants.API_RESET_PASSWORD), body: data);

      var message = jsonDecode(response.body);
      print(message);
      print('response $message');
      print("response ${response.body}");
      print("Token -> ${message["token"]}");
      print("data --> ${json.encode(data)}");

      if (message["status"] == 'success') {

        SharedPreferences sp = await SharedPreferences.getInstance();

        sp.setString(ACCESS_TOKEN, message["token"]);
        sp.setBool(IS_USER_LOG_IN, true);

        Storage.saveValue(AppConstants.TOKEN, message["token"]);

        //save token
        String token = sp.getString("fcmToken");
        if(token != null){
          fcmService.saveToken(token);
        }

        Get.offAll(HomeScreen());

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
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  Image.asset(
                    'assets/icons/Group 61295.png',
                    height: 50,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Container(
                      height: 350,
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
                                  'Reset Password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            InputFieldSimple(
                              controller: newPasswordController,
                              hintText: 'New Password',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.black54),
                              type: TextInputType.text,
                            ),
                            SizedBox(height: 5),
                            InputFieldSimple(
                              controller: confirmPasswordController,
                              hintText: 'Confirm New Password',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.black54),
                              type: TextInputType.text,
                            ),
                            SizedBox(height: 40),
                            RoundMaterialButton(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              color: kPrimaryColor,
                              circular: 10.0,
                              onPress: () {
                                onSubmit();
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
        ),
      ),
    );
  }
}
