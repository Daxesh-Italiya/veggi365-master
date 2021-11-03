import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veggi/Constants.dart';

class Utility {
  /// to change the status bar color white
  static statusBarColorWhiteBackGround() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, //Android
        statusBarBrightness:
            Brightness.light, // Dark == white status bar -- for IOS.
      ),
    );
  }

  /// to change the status bar color primary pink
  static statusBarColorPrimaryBackGround() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: kPrimaryColor, //Android
        statusBarBrightness:
            Brightness.dark, // Dark == white status bar -- for IOS.
      ),
    );
  }
}
