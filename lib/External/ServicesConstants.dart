
//var BASE_URL = "https://dharm.ga/api/";
var BASE_URL = "https://admin.veggi365.com/api/";

var URL_PRODUCT            = getFullPath("product");
var URL_ADD_ADDRESS        = getFullPath("useraddress");
var URL_USER_DATA          = getFullPath("user");
var URL_INSERT_ORDER       = getFullPath("order");
var URL_CAB_ORDER       = getFullPath("caborder");
var URL_COMMENT      = getFullPath("comment");
var URL_CHANGE_PASSWORD          = getFullPath("user/changepass");

var URL_ORDER_PAYMENT_CHECK       = getFullPath("order/payment");

var URL_CABORDER_STORAGE       = getFullPath("caborder/storage");

getFullPath(endPoint){
  return BASE_URL + endPoint;
}