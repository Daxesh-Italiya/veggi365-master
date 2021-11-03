import 'package:flutter/material.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_fonts.dart';

import 'app_dimens.dart';

class AppTextStyle {
  const AppTextStyle._();

  //login
  static TextStyle get bigPageTitleStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize32,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.BOLD,
        height: 1.5625,
      );

  static TextStyle get secondaryText => _textStyle.copyWith(
      fontSize: AppDimens.fontSize12,
      //fontWeight: FontWeight.w600,
      color: AppColors.themeColor.secondaryTextColor);

  static TextStyle get pageTitleStyle => _textStyle.copyWith(
      fontSize: AppDimens.fontSize18,
      fontWeight: FontWeight.w600,
      color: AppColors.themeColor.buttonTextColor);

  static TextStyle get pageTitleLargeStyle => _textStyle.copyWith(
      fontSize: AppDimens.fontSize25,
      fontWeight: FontWeight.bold,
      color: AppColors.themeColor.buttonTextColor);

  static TextStyle get semiBoldStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get boldStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize22,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get regularStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize18,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get smallStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get listItemTextStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get buttonTextStyle => _textStyle.copyWith(
      fontSize: AppDimens.fontSize16,
      fontWeight: FontWeight.w500,
      letterSpacing: .3,
      wordSpacing: -.5,
      color: AppColors.themeColor.buttonTextColor);

  static TextStyle get normalPrimaryText => _textStyle.copyWith(
        fontSize: AppDimens.fontSize14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get normalSecondaryText => _textStyle.copyWith(
      fontSize: AppDimens.fontSize14,
      fontWeight: FontWeight.w500,
      color: AppColors.themeColor.secondaryTextColor);

  static TextStyle get bigEmojiTextStyle => _textStyle.copyWith(
        fontSize: AppDimens.fontSize28,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get smallRichText => _textStyle.copyWith(
      fontSize: AppDimens.fontSize12,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.MEDIUM,
      color: AppColors.themeColor.textMutedColor);

  static TextStyle get smallRichBoldText => smallRichText.copyWith(
        fontWeight: FontWeight.w500,
      );

  static TextStyle get smallRichSecondaryText => _textStyle.copyWith(
      fontSize: AppDimens.fontSize12,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.MEDIUM,
      color: AppColors.themeColor.secondaryTextColor);

  static TextStyle get smallRichSecondaryBoldText => smallRichText.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.themeColor.secondaryTextColor);

  static TextStyle get tabTextStyle => _textStyle.copyWith(
      fontSize: AppDimens.fontSize13,
      fontWeight: FontWeight.w700,
      color: AppColors.white);

  static TextStyle get tabUnselectedTextStyle => _textStyle.copyWith(
      fontSize: AppDimens.fontSize13,
      fontWeight: FontWeight.w700,
      color: AppColors.themeColor.secondaryTextColor);

  static TextStyle get _textStyle => TextStyle(
        color: AppColors.themeColor.textColor,
        fontSize: AppDimens.fontSize14,
      );
}
