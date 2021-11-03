import 'package:flutter/material.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';

import '../Constants.dart';
import 'TrackYourOrderScreen.dart';

class OrderStatusScreen extends StatefulWidget {

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders Status',
          style: AppTextStyle.pageTitleStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 35),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#919100',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                'Today at 10:15 PM',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              SizedBox(height: 15),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrackYourOrderScreen()));
                },
                child: CustomButton(
                  height: 50,
                  text: 'Track Your Order',
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
