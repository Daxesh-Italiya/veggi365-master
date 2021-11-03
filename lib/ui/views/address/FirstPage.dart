import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/List/HomeScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/core/services/cart_service.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  CartService cartService = Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    //cartService.firstTimeOpen.toggle();
                    Get.offAll(HomeScreen(
                      currentMenu: 0,
                    ));
                  },
                  child: CustomButton(
                    height: 50,
                    text: 'Door To Door Delivery',
                    color: AppColors.themeColor.primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.offAll(HomeScreen(
                      currentMenu: 2 ,
                    ));
                  },
                  child: CustomButton(
                    height: 50,
                    text: 'Book A Cab',
                    color: AppColors.themeColor.primaryColor,
                  ),
                ),
              ),
            ],
          )
    );
  }
}