import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:veggi/constants/app_colors.dart';

class AppComponents {
  const AppComponents._();

  static Color get red => const Color(0xffF50041);

  /*static const bgGradient =
      LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.themeColor.backgroundColor,
      ]);*/

  static List<BoxDecoration> boxDecorations = [
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [const Color(0xfff98345), const Color(0xffc32dd4)],
        stops: [0.0, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [const Color(0xff4c9df2), const Color(0xffc02ed9)],
        stops: [0.0, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [const Color(0xff2bc2e1), const Color(0xff52bd29)],
        stops: [0.0, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [const Color(0xfffbbc5b), const Color(0xffe54a52)],
        stops: [0.0, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(0.0, -1.0),
        end: Alignment(0.0, 1.0),
        colors: [const Color(0xfff9637e), const Color(0xffc72fd9)],
        stops: [0.0, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      gradient: LinearGradient(
        begin: Alignment(-0.9, -0.97),
        end: Alignment(0.95, 1.0),
        colors: [
          const Color(0xfff2462f),
          const Color(0xfff8940b),
          const Color(0xfffae228),
          const Color(0xff31944c),
          const Color(0xff5c57ed),
          const Color(0xff242ced),
          const Color(0xff7b5ba5)
        ],
        stops: [0.0, 0.158, 0.32, 0.498, 0.655, 0.813, 1.0],
      ),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      color: const Color(0xff262626),
    ),
    BoxDecoration(
      //borderRadius: BorderRadius.circular(20.0),
      color: const Color(0xffc7c7c7),
    ),
  ];

  static List<Shadow> whiteTextShadow = [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Colors.grey.withOpacity(0.05),
    ),
  ];

  static BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          //                   <--- left side
          color: AppColors.themeColor.borderColor,
          width: 2.0,
        ),
      ),
    );
  }

  static BoxDecoration blueBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: AppColors.themeColor.primaryColor,
    );
  }

  static Widget get loading => Container(
        //color: Colors.black,
        child: Center(
          child: GFLoader(
            type: GFLoaderType.circle,
            loaderColorOne: AppColors.themeColor.primaryColor,
            loaderColorTwo: AppColors.themeColor.secondaryColor,
            loaderColorThree: AppColors.themeColor.primaryColor,
          ),
        ),
      );

  static BoxDecoration pinkBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: AppColors.themeColor.secondaryColor,
    );
  }

  static BoxDecoration blackBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.black,
    );
  }

  static Widget get cabLoading => Container(
        //color: Colors.black,
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

          Container(
          width: Get.width * 0.7,
              height: Get.width * 0.7,
              child: Image.asset(
                "assets/icons/loader.png",
                fit: BoxFit.contain,
              )),
              GFLoader(
                type: GFLoaderType.circle,
                loaderColorOne: AppColors.themeColor.primaryColor,
                loaderColorTwo: AppColors.themeColor.secondaryColor,
                loaderColorThree: AppColors.themeColor.primaryColor,
              ),
            ]),
          ),
      );
}
