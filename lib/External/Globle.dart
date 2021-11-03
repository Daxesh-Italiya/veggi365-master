import 'package:shared_preferences/shared_preferences.dart';


Future<Map<String,String>> getHeader()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  final header = {
    "Content-Type":"application/json",
    'Authorization': 'Bearer ${sp.getString(ACCESS_TOKEN)}'
  };
  return header;
}

final IS_USER_LOG_IN = "IS_USER_LOG_IN";
final ACCESS_TOKEN = "ACCESS_TOKEN";
