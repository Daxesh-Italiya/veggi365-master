import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/Input_Field_Simple.dart';
import 'package:veggi/Components/Round_MaterialButton.dart';
import 'package:veggi/Components/Round_RaisedButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/Screens/OtpScreen.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/themes/app_strings.dart';
import 'package:veggi/ui/views/address/FirstPage.dart';

import '../Constants.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _observer = true;
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
  }

  bool visible = false;
  var response;
  var message;
  //String url = 'https://dharm.ga/api/user';

  Future userSignUp() async {

    String Name = name.text;
    String phonenumber = phoneNumber.text;
    String Email = email.text;
    String Password = password.text;

    if(Name.isEmpty){
      Utils.showToast("Please enter your Name first!");
      return;
    }else if(phonenumber.isEmpty){
      Utils.showToast("Please enter your Phone Number first!");
      return;
    }else if(Email.isEmpty){
      Utils.showToast("Please enter Email Id first!");
      return;
    }else if(!Email.isEmail){
      Utils.showToast("Please enter valid Email Id!");
      return;
    }else if(Password.isEmpty){
      Utils.showToast("Please enter valid Password");
      return;
    }else if(!isChecked){
      Utils.showToast("Accept our Terms and Conditions before sign up.");
      return;
    }

    setState(() {
      visible = true;
    });

    var data = {
      'user_name': Name,
      'user_phone': phonenumber,
      'user_email': Email,
      'user_password': Password,
    };

    try {
      http.Response response = await http.post(Uri.parse(AppConstants.API_USER), body: data);
      print('response');
      print(response);

      message = jsonDecode(response.body);
      print(message);

      if (message["status"] == 'success') {

        setState(() {
          visible = false;
        });

        String otpToken = message["otptoken"];
        String tempToken = message["temptoken"];

        Get.to(OtpScreen(otpToken,tempToken));

        //SharedPreferences sp = await SharedPreferences.getInstance();

        //userLogin();
        //goto otp screen

        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        showDialogSuccess(context, message["status"],buttonText: "Okay",callback: (){
          Navigator.pop(context);
        });
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


  Future userLogin() async {
    setState(() {
      visible = true;
    });
    String userEmail = email.text;
    String userPassword = password.text;

    var data = {
      'email': userEmail,
      'password': userPassword,
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
        });

        Get.offAll(FirstPage());
        
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
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 15.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/icons/add-user.png',
                                      width: 20, height: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'SignUp',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              InputFieldSimple(
                                controller: name,
                                hintText: 'Name',
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.black54),
                                type: TextInputType.text,
                              ),
                              InputFieldSimple(
                                controller: phoneNumber,
                                hintText: 'Phone Number',
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.black54),
                                type: TextInputType.phone,
                              ),
                              InputFieldSimple(
                                controller: email,
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black54,
                                ),
                                type: TextInputType.emailAddress,
                              ),
                              passwordField(),
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width - 40,
                                child: Row(children: <Widget>[
                                  ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)),
                                    child: SizedBox(
                                      width: Checkbox.width,
                                      height: Checkbox.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Theme(
                                          data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colors.transparent),
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (state) async {
                                              setState(
                                                  () => isChecked = !isChecked);
                                            },
                                            activeColor: Colors.black,
                                            checkColor: Colors.white,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      text: 'I agree the ',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black38),
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Terms & Conditions',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(height: 15),
                              RoundMaterialButton(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                color: kPrimaryColor,
                                circular: 10.0,
                                onPress: () {
                                  userSignUp();
                                },
                                textStyle: kButtonStyleWhiteBold,
                                buttonText: 'Signup',
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
                      height: 40,
                    ),
                    logIn(),
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

  Row logIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: RichText(
              text: TextSpan(
                text: 'Already have an account?',
                style: kButtonStyleBlackRegular,
                children: const <TextSpan>[
                  TextSpan(
                      text: ' Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff69A03A))),
                ],
              ),
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
            /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen()));*/
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
        controller: password,
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

  /* bool _isValidate({String email, String password}) {
    if (email.isEmpty) {
      method.showtoast('Enter your E-mail', context);
      return false;
    }
    if (password.isEmpty) {
      method.showtoast('Enter your password', context);
      return false;
    }
    return true;
  }*/
}
