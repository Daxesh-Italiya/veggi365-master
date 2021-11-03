import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/Input_Field_Simple.dart';
import 'package:veggi/Components/Round_MaterialButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/Screens/ResetPasswordScreen.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/services/fcm_service.dart';
import 'package:veggi/themes/app_strings.dart';
import 'package:veggi/ui/views/address/FirstPage.dart';
import '../List/HomeScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Constants.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';

class OtpScreen extends StatefulWidget {
  final String otpToken;
  final String tempToken;

  final bool isPasswordReset;

  OtpScreen(this.otpToken, this.tempToken,{this.isPasswordReset = false});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  FCMService fcmService = Get.find();

  bool codeTimedOut = false;
  Duration timeOut = const Duration(minutes: 1);
  int start = 60;
  Timer codeTimer;

  String otpToken, tempToken;

  bool visible = false;

  //String url = 'https://dharm.ga/api/user/auth';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    startTimer();

    otpToken = widget.otpToken;
    tempToken = widget.tempToken;
  }

  @override
  void dispose() {
    codeTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    start = 60;
    codeTimer?.cancel();
    codeTimer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (start == 0) {
            codeTimedOut = true;
            timer.cancel();
          } else {
            start = start - 1;
          }
        });
      },
    );
  }

  void resendOtp() async {
    var data = {
      'temptoken': tempToken,
    };

    try {
      var response =
          await http.post(Uri.parse(AppConstants.API_RESEND_OTP), body: data);
      SharedPreferences sp = await SharedPreferences.getInstance();

      var message = jsonDecode(response.body);
      print(message);
      print('response $message');
      print("response ${response.body}");
      print("Token -> ${message["token"]}");
      print("data --> ${json.encode(data)}");

      if (message["status"] == 'success') {
        setState(() {
          visible = false;
          otpToken = message["otptoken"];
          tempToken = message["temptoken"];
          startTimer();
          Utils.showToast("OTP is sent");
        });
      } else {
        showToast(
          message["msg"] ?? AppStrings.commonErrMsg,
        );
        setState(() {
          visible = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        visible = false;
      });
      showToast(
        AppStrings.commonErrMsg,
      );
    }
  }

  Future verifyOTP() async {
    setState(() {
      visible = true;
    });
    String otp = otpController.text;

    var data = {
      'otp': otp,
      'otptoken': otpToken,
    };

    try {
      var response =
          await http.post(Uri.parse(AppConstants.API_VERIFY_OTP), body: data);
      SharedPreferences sp = await SharedPreferences.getInstance();

      var message = jsonDecode(response.body);
      print(message);
      print('response $message');
      print("response ${response.body}");
      print("Token -> ${message["token"]}");
      print("data --> ${json.encode(data)}");

      if (message["status"] == 'success') {
        setState(() {
          visible = false;
          sp.setString(ACCESS_TOKEN, message["token"]);
          sp.setBool(IS_USER_LOG_IN, true);
          Storage.saveValue(AppConstants.TOKEN, message["token"]);
          //save token
          String token = sp.getString("fcmToken");
          if (token != null) {
            fcmService.saveToken(token);
          }
        });

        if(widget.isPasswordReset){
          Get.off(ResetPasswordScreen(tempToken));
        }else{
          Get.offAll(HomeScreen());
        }



        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showToast(
          message["msg"] ?? AppStrings.commonErrMsg,
        );
        // showDialogSuccess(context, message["status"]);
        setState(() {
          visible = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        visible = false;
      });
      showToast(
        AppStrings.commonErrMsg,
      );
    }
    // print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: visible,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 120,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Container(
                        height: 380,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withAlpha(90),
                                blurRadius: 15.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 35, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 10),
                                  SvgPicture.asset(
                                      'assets/icons/login_icon.svg',
                                      width: 30,
                                      height: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'Verify OTP',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              InputFieldSimple(
                                controller: otpController,
                                hintText: 'Enter OTP',
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Colors.black54),
                                type: TextInputType.number,
                              ),
                              RoundMaterialButton(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                color: kPrimaryColor,
                                circular: 10.0,
                                onPress: () async {
                                  verifyOTP();
                                },
                                textStyle: kButtonStyleWhiteBold,
                                buttonText: 'Verify',
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Container(
                                alignment: Alignment.center,
                                  padding:EdgeInsets.symmetric(vertical: 10),
                                  child:Text(
                                start == 0
                                    ? "00:00"
                                    : "${start} Sec",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                              ))),

                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          "If your code does not arrive in 1 minute, ",
                                      style: kButtonStyleBlackRegular,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: " Resend",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff69A03A)),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (codeTimedOut) {
                                                  await resendOtp();
                                                } else {
                                                  Utils.showToast(
                                                      "You can't resend otp yet!");
                                                }
                                              }),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
