import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/constants/app_constants.dart';
import 'package:veggi/core/helper/storage.dart';

/*class LoggingInterceptor extends Interceptor {
  int _maxCharactersPerLine = 200;

  bool isTokenExpired(){
    if(Storage.hasData(AppConstants.TOKEN_TIMESTAMP)) {
      int timestamp = Storage.getValue(AppConstants.TOKEN_TIMESTAMP);
      DateTime expiryDate = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
      bool isExpired = expiryDate.compareTo(DateTime.now()) < 0;
      return isExpired;
    }else{
      return true;
    }
  }

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print("-->onRequest ${options.method} ${options.path}");
    print("Content type: ${options.contentType}");
    print("<--onRequest END");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {

    print(
        "<--onResponse ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
      (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response.data);
    }
    print("<--onResponse END");

    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print("<-- Error -->");
    print(err.error);
    print(err.message);
    //handler.next(err);
  }

}*/

class DioClient {
  // dio instance
  final Dio _dio;

  // injecting dio instance
  DioClient(this._dio) {
    _dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      //String token = await Storage.getValue<String>(AppConstants.TOKEN) ?? "";


          SharedPreferences sp = await SharedPreferences.getInstance();
          String token = sp.getString(ACCESS_TOKEN);


      if (token.isNotEmpty) {
        //check token is expired or not


        /*if(isTokenExpired()){
          print("token is expired");
          AuthController authController = AuthController.to;
          await authController.refreshToken();
          token = Storage.getValue(AppConstants.TOKEN) ?? "";
        }*/

        options.headers["Authorization"] = 'Bearer $token';
      }
      handler.next(options);
    }, onError: (DioError error, ErrorInterceptorHandler handler) async {
      if (error.response != null) {
        if (error.response.statusCode == 401 ||
            error.response.statusCode == 403) {
          //catch the 401 here
          _dio.interceptors.requestLock.lock();
          _dio.interceptors.responseLock.lock();
          RequestOptions requestOptions = error.requestOptions;

          //AuthController authController = AuthController.to;
          //await authController.refreshToken();

          final opts = new Options(method: requestOptions.method);

          String token = Storage.getValue(AppConstants.TOKEN) ?? "";

          _dio.options.headers["authorization"] = token;
          //_dio.options.headers["Accept"] = "*/*";
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          final response = await _dio.request(requestOptions.path,
              options: opts,
              cancelToken: requestOptions.cancelToken,
              onReceiveProgress: requestOptions.onReceiveProgress,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters);
          if (response != null) {
            handler.resolve(response);
          } else {
            return null;
          }
        } else {
          handler.next(error);
        }
      }
    }));
  }

  /*bool isTokenExpired(){
    if(Storage.hasData(AppConstants.TOKEN_TIMESTAMP)) {
      int timestamp = Storage.getValue(AppConstants.TOKEN_TIMESTAMP);
      //DateTime expiryDate = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
      DateTime expiryDate = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      bool isExpired = expiryDate.compareTo(DateTime.now()) < 0;
      return isExpired;
    }else{
      return true;
    }
  }*/

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      if (queryParameters == null) {
        queryParameters = {};
      }

      // String userId = Storage.getValue(AppConstants.USER_ID) ?? "";
      // if (userId.isNotEmpty) {
      //   queryParameters["user_id"] = userId;
      // }

      //add user_id
      // if (_box.hasData("user_id") && queryParameters != null) {
      //   print("my id ----> ${_box.read("user_id")}");
      //   queryParameters['user_id'] = _box.read("user_id");
      //   print("my id ----> done");
      // }

      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return json.decode(response.data);
      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    Map<String, dynamic> data = const {},
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {


      //add user_id

      // String userId = Storage.getValue(AppConstants.USER_ID) ?? "";
      //
      // if(userId.isNotEmpty){
      //   data["user_id"] = userId;
      // }

      //Utils.printMap(data,name: "post");

      final Response response = await _dio.post(
        uri,
        //data: new FormData.fromMap(data),
        data: json.encode(data),
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return json.decode(response.data);
    } catch (e) {
      print("DIO ERROR - ${e}");
      throw e;

    }
  }


  // Get:-----------------------------------------------------------------------
  Future<dynamic> patch(
      String uri, {
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onReceiveProgress,
      }) async {
    try {
      if (queryParameters == null) {
        queryParameters = {};
      }

      // String userId = Storage.getValue(AppConstants.USER_ID) ?? "";
      // if (userId.isNotEmpty) {
      //   queryParameters["user_id"] = userId;
      // }

      //add user_id
      // if (_box.hasData("user_id") && queryParameters != null) {
      //   print("my id ----> ${_box.read("user_id")}");
      //   queryParameters['user_id'] = _box.read("user_id");
      //   print("my id ----> done");
      // }

      final Response response = await _dio.patch(
        uri,
        //queryParameters: queryParameters,
        data: json.encode(queryParameters),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return json.decode(response.data);
      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }


}
