import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/CustomTextFied.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';

import '../Constants.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 30),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Change Password',
          style: AppTextStyle.pageTitleStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      CustomTextFieldShow(
                        height: 45,
                        controller: currentPassword,
                        hintText: 'Current Password',
                        type: TextInputType.text,
                        obscureText: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextFieldShow(
                        height: 45,
                        controller: newPassword,
                        hintText: 'New Password',
                        type: TextInputType.text,
                        obscureText: false,
                      ),
                      SizedBox(height: 10),
                      CustomTextFieldShow(
                        height: 45,
                        controller: confirmPassword,
                        hintText: 'Confirm Password',
                        type: TextInputType.text,
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: GestureDetector(
              onTap: () {
                changePassword();
              },
              child: CustomButton(
                height: 50,
                text: 'Change',
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changePassword() async{


    if(currentPassword.text.isEmpty){
      Utils.showToast("Enter your current password first!");
      return;
    }else  if(newPassword.text.isEmpty){
      Utils.showToast("Enter your new password first!");
      return;
    }else if(confirmPassword.text.isEmpty){
      Utils.showToast("Enter your confirm password first!");
      return;
    }else if(confirmPassword.text != newPassword.text){
      Utils.showToast("Entered confirm password not matched!");
      return;
    }

    var response = await http.Client().post(Uri.parse(URL_CHANGE_PASSWORD),
        headers: await getHeader(),
        body: json.encode({
          "old_password": currentPassword.text,
          "new_password": newPassword.text,
        }));

    var message = jsonDecode(response.body);
    print("message = "+response.body);
    if (message["status"] == "success") {
      Utils.showToast("password changed!");
      Get.back();
    } else {
      Utils.showToast(message["msg"]);
      //Utils.showToastError("Oops something went wrong");
    }
  }
}
