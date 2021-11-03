import 'dart:convert';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggi/Cab/AddNewAddress.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/List/CategoryProductList.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/MyAccount/Model/User.dart';
import 'package:veggi/Screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';
import 'package:veggi/core/services/cart_service.dart';
import 'package:veggi/themes/utility.dart';
import 'package:veggi/widgets/login_widget.dart';

import '../Constants.dart';
import 'ChangePassword.dart';
import 'MyInformationScreen.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  User user = null;
  var isLoading = true;

  CartService cartService = Get.find();

  bool isLogin = true;

  @override
  void initState() {
    //Utility.statusBarColorWhiteBackGround();
    Utility.statusBarColorPrimaryBackGround();
    super.initState();
    cartService.firstTimeOpen.value = false;
    getUser();
    checkLogin();
  }

  void checkLogin()async{

    Utils.isLogin().then((value) {
      setState(() {
        isLogin = value;
      });
    });


  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
        message:"Press back again to close",
        onFirstBackPress: (c)=>Get.offAll(HomeScreen()),
        child:Scaffold(
      key: _key,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Column(children:[

          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: Get.statusBarHeight/2,right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Ionicons.chevron_back,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),


          Container(
            height: Get.width * 0.3,
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
            child: SvgPicture.asset("assets/icons/logo.svg",fit: BoxFit.contain,),
          ),

          Expanded(child:ListView.builder(
              shrinkWrap: true,
              itemCount: cartService.category.length + 1,
              itemBuilder: (context, index) {

                String text = "";

                if(index == 0){
                  text = "All Categories";
                }else{
                  text = "${cartService.category[index - 1].categoryName}";
                }

                return Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child:GestureDetector(
                      onTap: () {

                        setState(() {
                          //filterCategory = index - 1;
                        });

                        if(index == 0){
                          Navigator.pop(context);
                          Get.offAll(HomeScreen(currentMenu: 0,));
                        }else{
                          Navigator.pop(context);
                          Get.to(
                              CategoryProductList(
                                selectedCategoryId:
                                cartService.category[index-1]
                                    .categoryId,
                                catName: cartService.category[index-1]
                                    .categoryName,
                                category: cartService.category,
                                price: cartService.price,
                                products: cartService.products,
                              ));

                        }



                      },
                      child: CustomButton(
                        height: 50,
                        text: text,
                        textColor: index == 0 ? Colors.white : Colors.black,
                        color: index == 0 ? AppColors.themeColor.primaryColor : Colors.transparent,
                      ),
                    ));

              }))]),
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _key.currentState.openDrawer();
          },
          icon: Icon(Ionicons.filter, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'My Account',
          style: AppTextStyle.pageTitleStyle,
        ),
      ),

      body: isLogin ? isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          height: 85,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5.0)
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Row(
                          children: [
                            /* Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: new DecorationImage(
                            image: new NetworkImage(
                                'https://images.pexels.com/photos/2255935/pexels-photo-2255935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),*/
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.userName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    user.userEmail,
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyInformationScreen(user))).then((value) {
                          getUser();
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Information',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Icon(Icons.navigate_next, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewAddressScreen()));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add Address',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Icon(Icons.navigate_next, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePassword()));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Change Password',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Icon(Icons.navigate_next, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: ()async {
                        const number = '919825131537'; //set the number here
                        bool res = await FlutterPhoneDirectCaller.callNumber(number);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3.0)
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Contact Us',
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Icon(Icons.navigate_next, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.remove(ACCESS_TOKEN);
                        sp.remove(IS_USER_LOG_IN);

                        Get.offAll(LoginScreen());
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ) : LoginWidget()));
  }

  Future<String> getUser() async {
    var response = await http.Client()
        .get(Uri.parse(URL_USER_DATA), headers: await getHeader());
    print(response.body);
    print("Header ${await getHeader()}");
    String jsonString = response.body;

    var jsonResponse = json.decode(jsonString);
    print("Response $jsonResponse");
    for (var i in jsonResponse) {
      user = User.fromJson(i);
      print("Data --> $i");
    }
    setState(() {
      isLoading = false;
    });
    print("User-> ${user.userName}");
    return response.body;
  }
}
