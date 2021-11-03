import 'dart:convert';
import 'package:double_back_to_close/double_back_to_close.dart';
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
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/services/fcm_service.dart';
import 'package:veggi/themes/app_strings.dart';
import 'package:veggi/ui/views/address/FirstPage.dart';
import '../List/HomeScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../Constants.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _observer = true;

  FCMService fcmService = Get.find();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
  }

  bool visible = false;
  //String url = 'https://dharm.ga/api/user/auth';

  Future userLogin() async {
    setState(() {
      visible = true;
    });
    String phone = phoneController.text;
    String password = passController.text;

    var data = {
      'phone': phone,
      'password': password,
    };

    try {
      var response = await http.post(Uri.parse(AppConstants.API_USER_LOGIN), body: data);
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
          if(token != null){
            fcmService.saveToken(token);
          }


        });

        Get.offAll(HomeScreen());

        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showToast(
          message["status"] ?? AppStrings.commonErrMsg,
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
    return DoubleBack(
      message:"Press back again to close",
      child:Container(
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
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              InputFieldSimple(
                                controller: phoneController,
                                hintText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone_android,
                                    color: Colors.black54),
                                type: TextInputType.phone,
                              ),
                              passwordField(),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 15.0),
                                  child: forgotPass()),
                              RoundMaterialButton(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                color: kPrimaryColor,
                                circular: 10.0,
                                onPress: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());



                                  if (validate(
                                    phone: phoneController.text,
                                    password: passController.text,
                                  )) {
                                    userLogin();
                                  }
                                },
                                textStyle: kButtonStyleWhiteBold,
                                buttonText: 'Login',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or',
                              style: kButtonStyleBlackMedium,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*  Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: RoundRaisedButton(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 20,
                        color: kBlueColor,
                        textStyle: kButtonStyleWhiteBold,
                        buttonText: 'Connect with Facebook',
                        icon: 'ic_facebook.png',
                        circular: 8.0,
                        onPress: () {},
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: RoundRaisedButton(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 20,
                        color: kRedColor,
                        textStyle: kButtonStyleWhiteBold,
                        buttonText: 'Connect with Google',
                        icon: 'ic_google.png',
                        circular: 8.0,
                        onPress: () {},
                      ),
                    ),*/
                    SizedBox(
                      height: 20,
                    ),

                    InkWell(
                        onTap: ()=>Get.offAll(HomeScreen()),
                        child:Text(
                       'As Guest',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.themeColor.primaryColor),
                    )),

                    SizedBox(
                      height: 20,
                    ),
                    
                    signUp(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Row signUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: RichText(
            text: TextSpan(
              text: 'Don\'t have an account?',
              style: kButtonStyleBlackRegular,
              children: <TextSpan>[
                TextSpan(
                  text: ' Sign up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.themeColor.primaryColor),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Row forgotPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0),
          child: Text(
            'Forgot Password?',
            style: kInputTextStyleBlack,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen()));
          },
        ),
      ],
    );
  }

  Widget passwordField() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.9,
      height: 55,
      child: TextFormField(
        enabled: true,
        readOnly: false,
        obscureText: _observer,
        keyboardType: TextInputType.text,
        style: kInputTextStyleBlack,
        controller: passController,
        autofocus: false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.black54),
          isDense: true,
          labelText: 'Password',
          labelStyle: kInputTextStyleBlack,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffdfdfdf))),
        ),
      ),
    );
  }
}

bool validate({String phone, String password}) {
  if (phone.isEmpty && password.isEmpty) {
    showToast('Please Enter Your Credentials');
    return false;
  } else if (phone.isEmpty) {
    showToast('Please Enter Your Phone Number');
    return false;
  }else if (phone.length < 10) {
    showToast('Phone Number Must Contains 10 Numbers');
    return false;
  } /*else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    showToast('Please Enter Valid Email Address');
    return false;
  } */else if (password.isEmpty) {
    showToast('Please Enter Your Password');
    return false;
  } else if (password.length < 4) {
    showToast('Password Must Contains 8 Characters');
    return false;
  } else {
    return true;
  }
}
