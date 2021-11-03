class Address {
  Address({
    this.userAddressId,
    this.userId,
    this.userAddressName,
    this.fullAddress,
    this.cityName,
    this.pincode,
    this.userAddressDefault,
  });

  int userAddressId;
  int userId;
  String userAddressName;
  String fullAddress;
  String cityName;
  int pincode;
  int userAddressDefault;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    userAddressId: json["user_address_id"],
    userId: json["user_id"],
    userAddressName: json["user_address_name"],
    fullAddress: json["full_address"],
    cityName: json["city_name"],
    pincode: json["pincode"],
    userAddressDefault: json["user_address_default"],
  );

  Map<String, dynamic> toJson() => {
    "user_address_id": userAddressId,
    "user_id": userId,
    "user_address_name": userAddressName,
    "full_address": fullAddress,
    "city_name": cityName,
    "pincode": pincode,
    "user_address_default": userAddressDefault,
  };
}
