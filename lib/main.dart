import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veggi/constants/app_theme.dart';
import 'package:veggi/core/helper/initializer.dart';
import 'Constants.dart';
import 'Screens/SplashScreen.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  //connectionStatus.initialize();

  Initializer.instance.init(() {
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(
      BoxConstraints(
        maxWidth: Get.width,
        maxHeight: Get.height,
      ),
      designSize: Get.size,
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VeggiApp',
      theme: AppTheme.theme,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
