import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/core/helper/utils.dart';

class LoginWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          //width: Get.width* 0.8,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
          height: Get.width* 0.8,
          child:
        SvgPicture.asset(
          'assets/icons/login.svg',

        )),

        GFButton(
          onPressed: ()=>Utils.logout(),
          text: "Login",
          color: AppColors.themeColor.primaryColor,
        )

      ],
    );
  }



}