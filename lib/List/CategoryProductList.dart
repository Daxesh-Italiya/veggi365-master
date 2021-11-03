import 'dart:convert';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/Cab/CartScreen.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/List/vegetable_list/Model/Products.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/themes/utility.dart';
import '../../Constants.dart';

class CategoryProductList extends StatefulWidget {

  final int selectedCategoryId;
  final String catName;

  final List<Product> products;
  final List<ProductPrice> price;
  final List<Category> category;


  CategoryProductList({this.selectedCategoryId,this.catName,this.category,this.products,this.price});

  @override
  _CategoryProductListState createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {
  List<Product> products = List.empty(growable: true);
  List<Product> catProducts = List.empty(growable: true);
  List<ProductPrice> price = List.empty(growable: true);
  List<Category> category = List.empty(growable: true);
  TextEditingController searchTextController = TextEditingController();
  var isLoading = true;

  String search = "";

  bool filterIsAtoZ = true;


  CartService cartService = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    Utility.statusBarColorPrimaryBackGround();
    super.initState();

    this.category = widget.category;
    this.products = widget.products;
    this.price = widget.price;

    refreshList();

    isLoading = false;



  }

  void refreshList(){
    catProducts = categoryProducts(widget.selectedCategoryId);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<Product> categoryProducts(int catId) {
    List<Product> _listContent = [];
    //String search = searchTextController.text;
    if (search.isEmpty) {
      _listContent.addAll(
          products.where((product) => product.categoryId == catId).toList() ??
              []);
    } else {
      _listContent.addAll(products
          .where((product) => (product.categoryId == catId &&
          (product.productName.contains(search) ||
              product.productAbout.contains(search) ||
              product.productTag.contains(search))))
          .toList() ??
          []);
    }


   _listContent.sort((a, b) {

      if(filterIsAtoZ){
        return a.productName.toLowerCase().compareTo(b.productName.toLowerCase());
      }else{
        return b.productName.toLowerCase().compareTo(a.productName.toLowerCase());
      }

    });

    return _listContent;
  }



  ProductPrice productPrice(int productId) {
    int index = price.indexWhere((price) => price.productId == productId);

    if (index == -1) {
      return null;
    } else {
      return price[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 35),
        ),
        title: Text('${widget.catName}',
            style: AppTextStyle.pageTitleStyle),

        actions: [

          GestureDetector(
          onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => CartScreen(),
    ),
    ).then((value) {
    Utility.statusBarColorPrimaryBackGround();
    });
    },
      child: ObxValue(
                  (productList) => Badge(
                  position: BadgePosition.topEnd(end: -5,top: 0),
                  badgeColor: Colors.red,
                  toAnimate: false,
                  padding: EdgeInsets.all(5),
                  shape: BadgeShape.circle,
                  showBadge: productList.isNotEmpty,
                  badgeContent: Text(
                    "${productList.length}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  child: Container(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 23,
                      color: Colors.white,
                    ),
                  )).marginOnly(top: 2,right: 15),
              cartService.productList))

        ],
      ),
      body: RefreshIndicator(

                      onRefresh: () {
                        return parseProduct();
                      },

                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          :  CustomScrollView(

                        physics: BouncingScrollPhysics(),

                        slivers: [
//                          Container(
//                            margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
//                            child: Row(
//                              children: [
//
////                                Container(child:Text("Sort By : ",style: AppTextStyle.regularStyle,)),
//
////                                Expanded(child:Container(
////                                    padding: EdgeInsets.symmetric(horizontal: 20),
////                                    child: GFButton(
////                                      text: "A to Z",
////                                      type:  filterIsAtoZ ? GFButtonType.solid : GFButtonType.outline,
////                                      shape: GFButtonShape.standard,
////                                      color: AppColors.themeColor.primaryColor,
////                                      textColor: filterIsAtoZ ? Colors.white : AppColors.themeColor.primaryColor,
////                                      onPressed: () {
////                                        setState(() {
////                                          filterIsAtoZ = true;
////                                          refreshList();
////                                        });
////                                      },
////                                    ))),
//
////                                Expanded(child:Container(
////                                    padding: EdgeInsets.symmetric(horizontal: 20),
////                                    child: GFButton(
////                                      text: "Z to A",
////                                      type:  !filterIsAtoZ ? GFButtonType.solid : GFButtonType.outline,
////                                      shape: GFButtonShape.standard,
////                                      color: AppColors.themeColor.primaryColor,
////                                      textColor: !filterIsAtoZ ? Colors.white :AppColors.themeColor.primaryColor,
////                                      onPressed: () {
////                                        setState(() {
////                                          filterIsAtoZ = false;
////                                          refreshList();
////                                        });
////                                      },
////                                    ))),
//                              ],
//                            ),
//                          ).sliverBox,

                          catProducts.length == 0 ? SliverFillRemaining(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[

                                Image.asset("assets/icons/loader.png",width: Get.width * 0.5,),

                                SizedBox(height: 25,),

                                Text("No Product Available",
                                style: AppTextStyle.boldStyle,
                                )]),
                            ),
                          ) :SliverGrid(
                          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                            mainAxisExtent: Get.width * 0.6
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  Product product =
                                  catProducts[index];

                                  ProductPrice price =
                                  productPrice(product.productId);


                                  return MixFreshVegTile(
                                      product, price,showAddToCart: true,);
                            },
                            childCount: catProducts.length,
                          ),
                        )

                      ],) ),
    );
  }

  Row buildSearchBar() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 10, top: 65),
          height: 40,
          width: MediaQuery.of(context).size.width * 0.73,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.7))
              ]),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20, left: 10),
                child: Icon(
                  Icons.search,
                  size: 23,
                  color: Colors.black45,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: TextFormField(
                    // enabled: false,
                    controller: searchTextController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(top: 20),
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            ).then((value) {
              Utility.statusBarColorPrimaryBackGround();
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 90, bottom: 22.5),
            height: 40,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 23,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getProduct() async {
    var response = await http.Client()
        .get(Uri.parse(URL_PRODUCT), headers: await getHeader());
    print(response.body);
    return response.body;
  }

  parseProduct() async {
    String jsonString = await getProduct();

    var response = json.decode(jsonString);
    print("Response $response");

    setState(() {
      isLoading = true;
      products.clear();
      price.clear();
      category.clear();
      searchTextController.text = "";
      search = "";
    });

    for (var i in response["product"]) {
      products.add(Product.fromJson(i));
      print("Data --> $i");
    }

    /*  img.clear();
    for (var i in response["img"]) {
      img.add(Img.fromJson(i));
    }*/



    for (var i in response["price"]) {
      price.add(ProductPrice.fromJson(i));
    }


    for (var i in response["category"]) {
      category.add(Category.fromJson(i));
    }
    setState(() {
      isLoading = false;
    });
    print("Product ${products[0].categoryId}");

    return true;
    // return products;
  }
}
