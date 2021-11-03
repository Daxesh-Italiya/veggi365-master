import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veggi/Cab/SelectAddressScreen.dart';
import 'package:veggi/Components/CustomButton.dart';
import 'package:veggi/Components/Input_Field_Simple.dart';
import 'package:http/http.dart' as http;
import 'package:veggi/External/Globle.dart';
import 'package:veggi/External/ServicesConstants.dart';
import 'package:veggi/Orders/OrderScreen.dart';
import 'package:veggi/constants/app_colors.dart';
import 'package:veggi/constants/app_text_style.dart';
import 'package:veggi/core/helper/utils.dart';

import '../Constants.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController address = TextEditingController();
  //final TextEditingController city = TextEditingController();
  //final TextEditingController state = TextEditingController();
  final TextEditingController pinCode = TextEditingController();

  var _city = ["Rajkot", "Surat", "Baroda", "Bhavanagar"];
  var _state = ["Gujarat"];

  var _currentCity = "Rajkot";
  var _currentState = "Gujarat";
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //state.text = "Gujarat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Add New Address',
          style: AppTextStyle.pageTitleStyle,
        ),
        leading: GestureDetector(
          child: Icon(Icons.navigate_before_outlined,
              color: AppColors.themeColor.primaryIconColor, size: 30),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            maxLines: 3,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          SizedBox(height: 5),
                          InputFieldSimple(
                            controller: address,
                            hintText: 'Enter Address',
                            type: TextInputType.text,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    //width: MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'City',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 13),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    //width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      'State',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 13),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child:Container(
                                  margin: EdgeInsets.only(bottom: 10),

                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelStyle: kInputTextStyleBlack,
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16.0),
                                          hintText: 'City Name',
                                        ),
                                        isEmpty: _currentCity == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _currentCity,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _currentCity =
                                                    newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: _city.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ))),

                              Expanded(
                                flex: 1,
                                child:Container(
                                    margin: EdgeInsets.only(bottom: 10),

                                    child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            labelStyle: kInputTextStyleBlack,
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16.0),
                                            hintText: 'State',
                                          ),
                                          isEmpty: _currentState == '',
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _currentState,
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  _currentState =
                                                      newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: _state.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    ))),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Pin Code',
                            maxLines: 3,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          SizedBox(height: 5),
                          InputFieldSimple(
                            controller: pinCode,
                            hintText: 'Enter Pin Code',
                            type: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // if(address.text.isEmpty){
                      //   showtoast('Enter Address');
                      // }else if(_currentSelectedValue == ""){
                      //   showtoast('Select city');
                      // }else if(state.text.isEmpty){
                      //   showtoast('Enter state name');
                      // }else if(pinCode.text.isEmpty){
                      //   showtoast('Enter pin code');
                      // }else{
                      addNewAddress(address.text, _currentCity, pinCode.text,_currentState);
                      // }
                    },
                    child: CustomButton(
                      height: 50,
                      text: 'Save',
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
    );
  }

  Future<String> addNewAddress(
      String address, String city, String pinCode,String state) async {
    setState(() {
      isLoading = true;
    });

    String fullAddress = "$address, $city, $state - $pinCode";

    var response = await http.Client().post(Uri.parse(URL_ADD_ADDRESS),
        headers: await getHeader(),
        body: json.encode({
          "address": [
            {
              "user_address_name": address ?? "",
              "full_address": fullAddress,
              "pincode": pinCode ?? "",
              "city_name": city ?? ""
            },
          ]
        }));

    var message = jsonDecode(response.body);
    if (message["status"] == "success") {

      Utils.showToast("Address added!");
      Get.back();

     /* showDialogSuccess(context, "Buy successful", callback: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => OrderScreen()));
      });*/
    } else {
      showDialogSuccess(context, "Oops something went wrong", callback: () {
        Navigator.pop(context);
      });
    }

    setState(() {
      isLoading = false;
    });

    print(response.body);
    return response.body;
  }
}
