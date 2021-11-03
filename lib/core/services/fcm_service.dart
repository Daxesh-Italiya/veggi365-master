import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:pp_local_notifications/local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/constants/app_constants.dart';

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

class DefaultCacheManager extends CacheManager {
  static const key = 'libCachedImageData';

  static DefaultCacheManager _instance;

  factory DefaultCacheManager() {
    _instance ??= DefaultCacheManager._();
    return _instance;
  }

  DefaultCacheManager._() : super(Config(key));
}

class FCMService extends GetxService {
  SharedPreferences sp;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Stream<String> _tokenStream;
  RxString fcmToken = "".obs;

  final ReceivePort backgroundMessageport = ReceivePort();
  String backgroundMessageIsolateName = 'fcm_background_msg_isolate';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init() async {
    sp = await SharedPreferences.getInstance();

    if (sp.getBool(IS_USER_LOG_IN) != null) {
      saveToken(sp.getString("fcmToken"));
    }

    await initLocalNotification();
    await initFCM();
  }

  void saveToken(String token) async {
    if (token != null) {
      if(token.isNotEmpty) {
        var data = {'token': token};
        try {
          var response = await http.post(Uri.parse(AppConstants.API_USER_LOGIN),
              headers: await getHeader(), body: data);

          var message = jsonDecode(response.body);

          if (message["status"] == "success") {
            print("save token success");
          } else {
            print("save token failed");
          }
        } on Exception catch (e) {}
      }
    }
  }

  void requestIosPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void initLocalNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    String initialRoute = "/";
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails.payload;
      initialRoute = "/profile";
    }

    selectNotificationSubject.stream.listen((String payload) async {
      if (payload.isNotEmpty) {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(payload));
        //navigateToPage(data);
      }
    });

    //android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    //ios
    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void setToken(String token) async {
    print('FCM Token: $token');
    fcmToken.value = token;
    if (token != null) {
      addDevice(token);
    }
  }

  void initFCM() async {
    if (!_initialized) {
      // For iOS request permission first.
      if (Platform.isIOS) {
        FirebaseMessaging.instance.requestPermission();
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //debugPrint('onMessage: ${message.data}');
        print('onMessage');
        print(message);
        print(message.messageId);
        if (message.data == null) {
          print('data is null');
        } else {
          _showNotification(
              message.notification.title, message.notification.body);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //print("onMessageOpenedApp: ${message.data}");

        print('onMessageOpenedApp');
        print(message.notification);
        print(message.data);
        if (message.data == null) {
          print('data is null');
        } else {
          Map<String, dynamic> data =
              new Map<String, dynamic>.from(message.data);

          //navigateToPage(data);
        }
      });

      _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      _tokenStream.listen(setToken);

      _initialized = true;

      //find token
      findToken();
      _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);

      //sub to topic
      fcmSubscribe();

      IsolateNameServer.registerPortWithName(
        backgroundMessageport.sendPort,
        backgroundMessageIsolateName,
      );

      backgroundMessageport.listen(backgroundMessagePortHandler);
    }
  }

  Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print('onBackgroundMessage');
    print(message);

    if (message.data == null) {
      print('data is null');
    } else {
      final port =
          IsolateNameServer.lookupPortByName(backgroundMessageIsolateName);
      port.send(message);
    }
    return Future<void>.value();
  }

  void backgroundMessagePortHandler(message) {
    //final dynamic data = message['data'];
    print(message.data);
    _showNotification(message.notification.title, message.notification.body);
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    fcmToken.value = token;
    addDevice(token);
  }

  Future<void> _showNotification(String title, String body) async {
    // Create your notification, providing the channel info

    var notificationStyle = DefaultStyleInformation(true, true);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'veggi365', 'veggi365_channel', 'veggi365 notification',
        styleInformation: notificationStyle);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  void fcmSubscribe() {
    _firebaseMessaging.subscribeToTopic('veggi365');
  }

  void fcmUnSubscribe() {
    _firebaseMessaging.unsubscribeFromTopic('veggi365');
  }

  void findToken() async {


    try {
      String token;

      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken();
      } else if (Platform.isIOS) {
        token = await FirebaseMessaging.instance.getAPNSToken();
      }

      if (token.isNotEmpty) {
        addDevice(token);
      }
    }catch(e){
      print("get token fails");
    }
  }

  void addDevice(String token) async {
    if (token != null) {
      print("FirebaseMessaging token: $token");
      sp.setString("fcmToken",token);
      saveToken(token);
      //set token
      //String deviceID = await Utils.deviceId();
      //await api.addDevice(token, GetPlatform.isAndroid ? 1 : 2, deviceID);
    } else {
      print("FirebaseMessaging token is null");
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
  }
}
