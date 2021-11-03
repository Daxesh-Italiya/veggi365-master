import 'package:flutter/material.dart';
import 'package:veggi/List/vegetable_list/Model/Comments.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';

class ProductDetails {
  int productId;
  int categoryId;
  String productName;
  String productAbout;
  String productStorageTip;
  String productFreshTill;
  String productTag;
  String productImg;
  String productCoverImg;
  int productStatus;
  int isDeleted;
  String createdAt;
  String updatedAt;
  int totalQuantity;
  String categoryName;
  List<Img> img;
  List<ProductPrice> price;
  List<Comments> comment;

  ProductDetails(
      {this.productId,
      this.categoryId,
      this.productName,
      this.productAbout,
      this.productStorageTip,
      this.productFreshTill,
      this.productTag,
      this.productImg,
      this.productCoverImg,
      this.productStatus,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.totalQuantity,
      this.categoryName,
      this.img,
      this.price,
      this.comment});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    productName = json['product_name'];
    productAbout = json['product_about'];
    productStorageTip = json['product_storage_tip'];
    productFreshTill = json['product_fresh_till'];
    productTag = json['product_tag'];
    productImg = json['product_img'];
    productCoverImg = json['product_img'];
    productStatus = json['product_status'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalQuantity = json['total_quantity'];
    categoryName = json['category_name'];
    if (json['img'] != null) {
      img = [];
      json['img'].forEach((v) {
        img.add(new Img.fromJson(v));
      });
    }
    if (json['price'] != null) {
      price = [];
      json['price'].forEach((v) {
        price.add(new ProductPrice.fromJson(v));
      });
    }
    if (json['comment'] != null) {
      comment = [];
      json['comment'].forEach((v) {
        comment.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['product_name'] = this.productName;
    data['product_about'] = this.productAbout;
    data['product_storage_tip'] = this.productStorageTip;
    data['product_fresh_till'] = this.productFreshTill;
    data['product_tag'] = this.productTag;
    data['product_img'] = this.productImg;
    data['product_cover_img'] = this.productCoverImg;
    data['product_status'] = this.productStatus;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_quantity'] = this.totalQuantity;
    data['category_name'] = this.categoryName;
    if (this.img != null) {
      data['img'] = this.img.map((v) => v.toJson()).toList();
    }
    if (this.price != null) {
      data['price'] = this.price.map((v) => v.toJson()).toList();
    }
    if (this.comment != null) {
      data['comment'] = this.comment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Img {
//   int productImageId;
//   int productId;
//   String productImagePath;
//   int isDeleted;
//   String createdAt;
//   String updatedAt;
//
//   Img(
//       {this.productImageId,
//         this.productId,
//         this.productImagePath,
//         this.isDeleted,
//         this.createdAt,
//         this.updatedAt});
//
//   Img.fromJson(Map<String, dynamic> json) {
//     productImageId = json['product_image_id'];
//     productId = json['product_id'];
//     productImagePath = json['product_image_path'];
//     isDeleted = json['is_deleted'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_image_id'] = this.productImageId;
//     data['product_id'] = this.productId;
//     data['product_image_path'] = this.productImagePath;
//     data['is_deleted'] = this.isDeleted;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class Price {
//   int productId;
//   int productPrice;
//   String priceUnitName;
//   int unitInGm;
//   int priceUnitId;
//   int discount;
//
//   Price(
//       {this.productId,
//         this.productPrice,
//         this.priceUnitName,
//         this.unitInGm,
//         this.priceUnitId,
//         this.discount});
//
//   Price.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id'];
//     productPrice = json['product_price'];
//     priceUnitName = json['price_unit_name'];
//     unitInGm = json['unit_in_gm'];
//     priceUnitId = json['price_unit_id'];
//     discount = json['discount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['product_price'] = this.productPrice;
//     data['price_unit_name'] = this.priceUnitName;
//     data['unit_in_gm'] = this.unitInGm;
//     data['price_unit_id'] = this.priceUnitId;
//     data['discount'] = this.discount;
//     return data;
//   }
// }
//
// class Comment {
//   int commentId;
//   String userName;
//   int productId;
//   String comment;
//   int isDeleted;
//   String createdAt;
//   String updatedAt;
//
//   Comment(
//       {this.commentId,
//         this.userName,
//         this.productId,
//         this.comment,
//         this.isDeleted,
//         this.createdAt,
//         this.updatedAt});
//
//   Comment.fromJson(Map<String, dynamic> json) {
//     commentId = json['comment_id'];
//     userName = json['user_name'];
//     productId = json['product_id'];
//     comment = json['comment'];
//     isDeleted = json['is_deleted'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['comment_id'] = this.commentId;
//     data['user_name'] = this.userName;
//     data['product_id'] = this.productId;
//     data['comment'] = this.comment;
//     data['is_deleted'] = this.isDeleted;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
