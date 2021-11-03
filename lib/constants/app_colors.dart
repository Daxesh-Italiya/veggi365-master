import 'package:flutter/material.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';

class AppColors {
  const AppColors._();


  static const Color darkGreen = Color(0xFF077f7b);
  static const Color blue = Color(0xFF2672ca);
  static const Color red = Color(0xFFfd3951);
  static const Color yellow = Color(0xFFfd3951);

  static const Color white = Colors.white;
  static const Color black = Colors.black;


  static bool get isDarkMode => false;// Storage.getValue<bool>(AppConstants.IS_DARK_MODE) ?? false;

  static ThemeColor get themeColor =>isDarkMode ? lightThemeColor : lightThemeColor;

  // Theme mode to display unique properties not cover in theme data
  static ThemeColor get lightThemeColor => new ThemeColor(
    primaryColor: Color(0xff4AC85D),
    secondaryColor: Color(0xff212121),

    primaryIconColor: Color(0xffffffff),
    secondaryIconColor: Color(0xff4AC85D),

    gradient: [
      ...[Color(0xDDFF0080), Color(0xDDFF8C00)],
    ],

    backgroundColor: Color(0xFFFFFFFF),

    buttonColor:  Color(0xff4AC85D) ,
    buttonTextColor: Color(0xFFFFFFFF),

    secondaryButtonColor:  Color(0xff212121) ,
    secondaryButtonTextColor: Color(0xFFFFFFFF),

    textColor: Color(0xff212121) ,
    secondaryTextColor: Color(0xff818181),

    textMutedColor: Color(0xffbbbbbb),
    toggleButtonColor:  Color(0xFFFFFFFF),
    toggleBackgroundColor: Color(0xFFe7e7e8) ,

    borderColor: Color(0xffbbbbbb),

    shadow: [

      BoxShadow(
        color: Color(0xFFB2B2B2)
            .withOpacity(1), //Color(0x26abb4bd),
        offset: Offset(0, 4),
        blurRadius: 50,
      ),

      BoxShadow(
          color: Color(0xFFd8d7da),
          spreadRadius: 5,
          blurRadius: 10,
          offset: Offset(0, 5)),
    ],
    cardColor: Color(0xFFe7e7e8),
  );



}

// A class to manage specify colors and styles in the app not supported by theme data
class ThemeColor {

  Color primaryColor;
  Color secondaryColor;

  Color primaryIconColor;
  Color secondaryIconColor;

  List<Color> gradient;
  Color backgroundColor;
  Color toggleButtonColor;
  Color toggleBackgroundColor;
  Color textColor;
  Color textMutedColor;
  Color secondaryTextColor;
  Color buttonColor;
  Color buttonTextColor;
  Color secondaryButtonColor;
  Color secondaryButtonTextColor;
  Color cardColor;
  Color borderColor;
  List<BoxShadow> shadow;

  ThemeColor({
    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.primaryIconColor,
    @required this.secondaryIconColor,
    @required this.gradient,
    @required this.backgroundColor,
    @required this.toggleBackgroundColor,
    @required this.toggleButtonColor,
    @required this.textColor,
    @required this.textMutedColor,
    @required this.secondaryTextColor,
    @required this.shadow,
    @required this.cardColor,
    @required this.buttonColor,
    @required this.buttonTextColor,
    @required this.secondaryButtonColor,
    @required this.borderColor,
    @required this.secondaryButtonTextColor,
  });
}
