import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veggi/core/controllers/cart_controller.dart';
import 'package:veggi/core/services/api_service.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/core/services/fcm_service.dart';

class Initializer {
  static final Initializer instance = Initializer._internal();
  factory Initializer() => instance;
  Initializer._internal();

  void init(VoidCallback runApp) async {

    // ErrorWidget.builder = (errorDetails) {
    //   print(errorDetails.exception.toString());
    //
    // };

    printInfo(info: 'runZonedGuarded: started');
    //runZonedGuarded(() async {

      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();
      
      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details);
        printInfo(info: details.stack.toString());
      };

      await _initServices();
      runApp();
    // }, (error, stack) {
    //   printInfo(info: 'runZonedGuarded Error: ${stack.toString()}');
    // });
  }

  Future<void> _initServices() async {
    try {

      await GetStorage.init();

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await Get.put<ApiService>(ApiService())..init();
      await Get.put<CartService>(CartService())..init();
      await Get.put<FCMService>(FCMService())..init();
      Get.putAsync<CartController>(() async => CartController());

    } catch (err) {

      printInfo(info: '_initServices error: $err');
      rethrow;

    }

  }

}
