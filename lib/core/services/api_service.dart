import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';
import 'package:veggi/core/models/address_response_entity.dart';
import 'package:veggi/core/network/dio_client.dart';

abstract class BaseServices {

}

class ApiService extends GetxService implements BaseServices {
  Dio _dio = new Dio(BaseOptions(
    //connectTimeout: 5,
    //receiveTimeout: 20
  ));

  DioClient client;
  static ApiService to = Get.find();

  Future<void> init() async {

    _dio.interceptors.add(PrettyDioLogger());
    client = new DioClient(_dio);

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString(ACCESS_TOKEN);
    Storage.saveValue(AppConstants.TOKEN, token);

  }


  Future<AddressResponseEntity> address() async {

    // Map<String, dynamic> response =
    // await client.get(AppConstants.API_USER_ADDRESS,queryParameters:{
    // });

    List<dynamic> response = await client.get(AppConstants.API_USER_ADDRESS,queryParameters:{});

    //List<AddressEntity> addressList = List<AddressEntity>.from(response);
    return AddressResponseEntity().fromJson(json.decode("{\"address\":${json.encode(response)}"));
  }


  Future<AddressResponseEntity> orders() async {
    // Map<String, dynamic> response =
    // await client.get(AppConstants.API_USER_ADDRESS,queryParameters:{
    // });

    List<dynamic> response = await client.get(AppConstants.API_USER_ADDRESS,queryParameters:{});

    //List<AddressEntity> addressList = List<AddressEntity>.from(response);
    return AddressResponseEntity().fromJson(json.decode("{\"address\":${json.encode(response)}"));
  }



}