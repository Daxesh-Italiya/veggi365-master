class AppConstants {
  const AppConstants._();

  //static const String BASE_URL = 'https://dharm.ga/';
  static const String BASE_URL = 'https://admin.veggi365.com/';
  static const String API_URL = BASE_URL + "api/";

  //cache storage
  static const String IS_DARK_MODE = "isDarkMode";
  static const String TOKEN = "token";

  //API
  static const String API_USER = API_URL + "user";
  static const String API_USER_LOGIN = API_URL + "user/auth";
  static const String API_USER_ADDRESS = API_URL + "useraddress";
  static const String API_DEVICE_TOKEN = API_URL + "user/devicetoken";

  static const String API_PRODUCT = API_URL + "product";
  static const String API_PRODUCT_CATEGORY = API_URL + "product/category";
  static const String API_PRODUCT_IMG = API_URL + "product/img";
  static const String API_PRODUCT_PRICE = API_URL + "product/price";

  static const String API_ORDER = API_URL + "order";
  static const String API_CAB_ORDER = API_URL + "caborder";
  static const String API_COMMENT = API_URL + "comment";


  static const String API_VERIFY_OTP = API_URL + "user/verifyotp";
  static const String API_RESEND_OTP = API_URL + "user/resendotp";
  static const String API_FORGOT_PASSWORD = API_URL + "user/forgotpass";
  static const String API_RESET_PASSWORD = API_URL + "user/resetpass";

  static const String API_BASKET = API_URL + "order/basket";

}
