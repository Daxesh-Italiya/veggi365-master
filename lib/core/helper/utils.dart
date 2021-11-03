
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/Screens/LoginScreen.dart';
import 'package:veggi/constants/app_colors.dart';

class Utils {
  const Utils._();

  static bool isTablet(){
    var size = Get.size;
    var diagonal = sqrt(
        (size.width * size.width) +
            (size.height * size.height)
    );
    var isTablet = diagonal > 1100.0;
    //var isTablet = diagonal > 900.0;
    return isTablet;
  }

  static Map<String, dynamic> cleanNull(Map<String, dynamic> map) {
    final Map<String, dynamic> tempMap = map;
    tempMap.removeWhere((String key, dynamic value) => value == null);
    return tempMap;
  }

  static void printMap(Map<String, dynamic> map,{String name = "printMap"}) {
    debugPrint('$name - ${json.encode(map)}');
  }

  static int currentTimeInSeconds({DateTime dateTime}) {
    var ms = (dateTime ?? new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  static String symbolNumber(int numberToFormat) {
    return numberToFormat == null
        ? "0"
        : NumberFormat.compact().format(numberToFormat);
  }

  static void loadingDialog() {
    Utils.closeDialog();

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void closeDialog() {
    if (Get.isDialogOpen) {
      Get.back();
    }
  }

  static void closeSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }

  static void showSnackbar(String message) {
    closeSnackbar();
    Get.rawSnackbar(message: message);
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: AppColors.white,
        backgroundColor: AppColors.black,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  static void showToastError(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: AppColors.white,
        backgroundColor: AppColors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  static void closeKeyboard() {
    final currentFocus = Get.focusScope;
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<void> logout()async{
    SharedPreferences sp =
        await SharedPreferences.getInstance();
    sp.remove(ACCESS_TOKEN);
    sp.remove(IS_USER_LOG_IN);

    Get.offAll(LoginScreen());
  }

  static Future<bool> isLogin() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(IS_USER_LOG_IN) != null;
  }

  static Future showDialog(BuildContext context, message,
      {buttonText = "Close",
        IconData icon = Icons.close,
        Color iconColor,
        Color buttonColor,
        Function() callback}) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
// padding: const EdgeInsets.all(30),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
// height: 260,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Icon(icon,
                          color: iconColor ?? AppColors.themeColor.primaryColor,
                          size: 80),
                      SizedBox(height: 20),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //color: kPrimaryColor,
                            color: AppColors.themeColor.textColor,
                            decoration: TextDecoration.none,
                            fontSize: 22),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: GestureDetector(
                          child: CustomButton(
                            height: 40,
                            text: buttonText,
                            color: buttonColor ??
                                AppColors.themeColor.primaryColor,
                          ),
                          onTap: () {
                            callback?.call();
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
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }



}