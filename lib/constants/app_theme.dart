import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_dimens.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/extensions.dart';
class AppTheme {
  const AppTheme._();

  static ThemeData get theme {
    final inputBorder = 4.outlineInputBorder(
      borderSide: 1.borderSide(color: AppColors.white, width: 2),
    );

    final focusedInputBorder = 4.outlineInputBorder(
      borderSide: 1.borderSide(color: AppColors.white, width: 2),
    );

    final hintStyle = AppTextStyle.semiBoldStyle.copyWith(
      color: AppColors.themeColor.textMutedColor,
      fontSize: AppDimens.fontSize14,
    );

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.themeColor.backgroundColor,
      primaryColor: AppColors.themeColor.primaryColor,
      accentColor: AppColors.themeColor.primaryColor,
      buttonColor:AppColors.themeColor.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        //color: AppColors.themeColor.textColor,
        brightness: Brightness.dark,
        backgroundColor: AppColors.themeColor.primaryColor,
      ),
      // buttonTheme: ButtonThemeData(
      //   buttonColor: AppColors.themeColor.primaryColor,
      //   height: 45.h,
      //   textTheme: ButtonTextTheme.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: 23.borderRadius,
      //   ),
      // ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
            (_) => EdgeInsets.zero,
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white.withOpacity(.14);
              }

              return null;
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (_) => AppTextStyle.buttonTextStyle,
          ),
          shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: 10.borderRadius,
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors.themeColor.primaryColor;
              }
              return null;
            },
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
            (_) => EdgeInsets.zero,
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white.withOpacity(.14);
              }

              return null;
            },
          ),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (_) => AppTextStyle.buttonTextStyle,
          ),
          shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: 10.borderRadius,
            ),
          ),
        ),
      ),
      floatingActionButtonTheme:  FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor:AppColors.themeColor.primaryColor,
      ),
      textTheme: TextTheme(

      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 3,
        ),
        prefixStyle: AppTextStyle.regularStyle.copyWith(
          fontSize: AppDimens.fontSize14,
          color: AppColors.black,
        ),
        fillColor: AppColors.white,
        hintStyle: hintStyle,
        labelStyle: hintStyle,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: focusedInputBorder,
        border: inputBorder,
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: 10.borderRadius,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: 20.borderRadius,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23.r),
            topRight: Radius.circular(23.r),
          ),
        ),
      ),
    );
  }
}
