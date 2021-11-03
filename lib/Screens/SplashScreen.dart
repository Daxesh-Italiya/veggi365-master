import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/ui/views/address/FirstPage.dart';
import '../Constants.dart';
import 'LoginScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkIfUserLogin();
  }

  checkIfUserLogin()async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Timer(
      Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      ),
    );

    /*if (sp.getBool(IS_USER_LOG_IN) != null){
      Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        ),
      );
    }else{
      Timer(
        Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        ),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
                child: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  height: 150,
                ),
            ),

//            Positioned(
//              top: 180,
//              left: 80,
//              child: SvgPicture.asset(
//              'assets/icons/loading.svg',
//              height: 40,
//            ),
//            )

          ],
        ),
      ),
    );
  }
}
