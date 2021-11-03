class User {
  User({
    this.userId,
    this.userName,
    this.userPhone,
    this.userEmail,
    // this.userPassword,
    // this.isDeleted,
    // this.createdAt,
    // this.updatedAt,
  });

  int userId;
  String userName;
  int userPhone;
  String userEmail;
  // String userPassword;
  // int isDeleted;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    userName: json["user_name"],
    userPhone: json["user_phone"],
    userEmail: json["user_email"],
    // userPassword: json["user_password"],
    // isDeleted: json["is_deleted"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_phone": userPhone,
    "user_email": userEmail,
    // "user_password": userPassword,
    // "is_deleted": isDeleted,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
  };
}
