class Products {
  Products({
    this.product,
    this.img,
    this.price,
    this.category,
  });

  List<Product> product;
  List<Img> img;
  List<ProductPrice> price;
  List<Category> category;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    product: List<Product>.from(json["product"].map((x) => Product.fromJson(x))),
    img: List<Img>.from(json["img"].map((x) => Img.fromJson(x))),
    price: List<ProductPrice>.from(json["price"].map((x) => ProductPrice.fromJson(x))),
    category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product": List<dynamic>.from(product.map((x) => x.toJson())),
    "img": List<dynamic>.from(img.map((x) => x.toJson())),
    "price": List<dynamic>.from(price.map((x) => x.toJson())),
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.categoryId,
    this.categoryName,
  });

  int categoryId;
  String categoryName;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
  };
}

class Img {
  Img({
    this.productImageId,
    this.productId,
    this.productImagePath,
  });

  int productImageId;
  int productId;
  String productImagePath;

  factory Img.fromJson(Map<String, dynamic> json) => Img(
    productImageId: json["product_image_id"],
    productId: json["product_id"],
    productImagePath: json["product_image_path"],
  );

  Map<String, dynamic> toJson() => {
    "product_image_id": productImageId,
    "product_id": productId,
    "product_image_path": productImagePath,
  };
}

class ProductPrice {
  ProductPrice({
    this.productId,
    this.productPrice,
    this.priceUnitName,
    this.unitInGram,
    this.priceUnitId,
  });

  int productId;
  int productPrice;
  int unitInGram;
  String priceUnitName;
  int priceUnitId;

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
    productId: json["product_id"],
    productPrice: json["product_price"],
    priceUnitName: json["price_unit_name"],
    priceUnitId: json["price_unit_id"],
    unitInGram: json["unit_in_gm"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_price": productPrice,
    "price_unit_name": priceUnitName,
    "price_unit_id": priceUnitId,
    "unit_in_gm": unitInGram,
  };
}

class Product {
  Product({
    this.productId,
    this.categoryId,
    this.productName,
    this.productAbout,
    this.productStorageTip,
    this.productFreshTill,
    this.productTag,
    this.productImg,
    this.productCoverImg,
    this.productStatus,
    this.totalQuantity,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

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
  int totalQuantity;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json["product_id"],
    categoryId: json["category_id"],
    productName: json["product_name"],
    productAbout: json["product_about"],
    productStorageTip: json["product_storage_tip"],
    productFreshTill: json["product_fresh_till"],
    productTag: json["product_tag"],
    productImg: json["product_img"],
    productCoverImg: json["product_img"],
    productStatus: json["product_status"],
    totalQuantity: json["total_quantity"],
    isDeleted: json["is_deleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "category_id": categoryId,
    "product_name": productName,
    "product_about": productAbout,
    "product_storage_tip": productStorageTip,
    "product_fresh_till": productFreshTill,
    "product_tag": productTag,
    "product_img": productImg,
    "product_cover_img": productCoverImg,
    "product_status": productStatus,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
