
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/CustomTextFied.dart';
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/MyAccount/Model/User.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/core/helper/utils.dart';

import '../Constants.dart';

class MyInformationScreen extends StatefulWidget {

  User user;

  MyInformationScreen(this.user);

  @override
  _MyInformationScreenState createState() => _MyInformationScreenState();
}

class _MyInformationScreenState extends State<MyInformationScreen> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();

  File image;
  _imgFromGallery() async {
    final pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      image = File(pickedImage.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstName.text = widget.user.userName;
    email.text = widget.user.userEmail;
    phoneNumber.text = "${widget.user.userPhone}";
  }

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
          'My Information',
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
                      /* Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 50,
                              child: image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        image,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        'https://images.pexels.com/photos/2255935/pexels-photo-2255935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 3,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  _imgFromGallery();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(Icons.camera_alt_outlined,
                                      size: 22, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      SizedBox(height: 20),
                      Text(
                        'Full Name',
                        style: kTextFieldStyle,
                      ),
                      SizedBox(height: 7),
                      CustomTextField(
                        height: 45,
                        controller: firstName,
                        hintText: widget.user.userName??"Veggi User",
                        type: TextInputType.text,
                        obscureText: false,
                      ),
                      SizedBox(height: 10),

                      Text(
                        'Email',
                        style: kTextFieldStyle,
                      ),
                      SizedBox(height: 7),
                      CustomTextField(
                        height: 45,
                        controller: email,
                        hintText: widget.user.userEmail??"Email",
                        type: TextInputType.emailAddress,
                        obscureText: false,
                        enable: false,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone Number',
                        style: kTextFieldStyle,
                      ),
                      SizedBox(height: 7),
                      CustomTextField(
                        height: 45,
                        controller: phoneNumber,
                        hintText: widget.user.userPhone.toString()??"Phone Number",
                        type: TextInputType.phone,
                        obscureText: false,
                        enable: false,
                      ),
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
                saveProfile(firstName.text);
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

  void saveProfile(String name) async{


    if(name.isEmpty){
      Utils.showToast("Enter your full name first!");
      return;
    }


    var response = await http.Client().patch(Uri.parse(URL_USER_DATA),
        headers: await getHeader(),
    body: json.encode({
    "user_name": name,
    }));

    if (response.statusCode == 200) {

    Utils.showToast("update success!");
      Get.back();
    } else {
      showDialogSuccess(context, "Oops something went wrong", callback: () {
      Navigator.pop(context);
      });
    }
  }

}
