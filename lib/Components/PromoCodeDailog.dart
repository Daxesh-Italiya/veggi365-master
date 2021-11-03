import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';
import 'CustomButton.dart';

class PromoCodeDailog extends StatefulWidget {
  @override
  _PromoCodeDailogState createState() => _PromoCodeDailogState();
}

class _PromoCodeDailogState extends State<PromoCodeDailog> {
  TextEditingController promoCode = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Take 20% Off',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize: 22),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Orders',
                    style: kToPayStyle,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Enter Your Promo Code',
                      style: kTextFieldStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      //width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Material(
                          color: Colors.white,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: promoCode,
                            cursorColor: Colors.black26,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Enter Your Promo Code',
                              hintStyle: kTextFieldStyle,
                              border: InputBorder.none,
                            ),
                          ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: CustomButton(
                      height: 40,
                      text: 'Get Started Now',
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
