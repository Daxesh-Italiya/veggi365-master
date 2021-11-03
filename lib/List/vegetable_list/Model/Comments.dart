import 'package:timeago/timeago.dart' as timeago;
import 'package:veggi/core/helper/utils.dart';

class Comments {
  Comments({
    this.commentId,
    this.userName,
    this.productId,
    this.comment,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  int commentId;
  String userName;
  int productId;
  String comment;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        commentId: json["comment_id"],
        userName: json["user_name"],
        productId: json["product_id"],
        comment: json["comment"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "user_name": userName,
        "product_id": productId,
        "comment": comment,
        "is_deleted": isDeleted,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String getTimeText() {

    return timeago.format(
      this.createdAt,
      locale: 'en',
    );
  }
}
