import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/CustomTextFied.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';

import '../Constants.dart';
import 'package:http/http.dart' as http;

class WriteAReview extends StatefulWidget {

  int productId;

  WriteAReview(this.productId);

  @override
  _WriteAReviewState createState() => _WriteAReviewState();
}

class _WriteAReviewState extends State<WriteAReview> {
  TextEditingController comment = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          child: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 30),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Write a Review',
          style: AppTextStyle.pageTitleStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black26, width: 1)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black54,
                                    decoration: TextDecoration.none),
                                textAlignVertical: TextAlignVertical.center,
                                controller:comment,
                                autofocus: false,
                                cursorColor: Colors.black,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: "Write a review here",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                      decoration: TextDecoration.none),
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                      decoration: TextDecoration.none),
                                )),
                          ),
                        ),
                      )


                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: GestureDetector(
              onTap: () {
                save();
              },
              child: CustomButton(
                height: 50,
                text: 'Save',
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void save() async{


    if(comment.text.isEmpty){
      Utils.showToast("Enter your review first!");
      return;
    }

    var response = await http.Client().post(Uri.parse(URL_COMMENT),
        headers: await getHeader(),
        body: json.encode({
          "product_id": widget.productId,
          "comment": comment.text,
        }));

    var message = jsonDecode(response.body);
    print("message = "+response.body);
    if (message["status"] == "success") {
      Utils.showToast("review added!");
      Get.back();
    } else {
      Utils.showToast("Add review failed!");
      //Utils.showToast(message["msg"]);
      //Utils.showToastError("Oops something went wrong");
    }
  }
}
