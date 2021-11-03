import 'package:flutter/material.dart';

import '../Constants.dart';

class InputFieldSimple extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final prefixIcon;
  final TextInputType type;
  final bool readonly;

  InputFieldSimple(
      {this.controller,
      this.hintText,
      this.prefixIcon,
      this.type,
      this.readonly});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      width: size.width * 0.9,
      height: 40,
      child: TextFormField(
        readOnly: readonly == null ? false : readonly,
        enabled: readonly == null ? true : false,
        keyboardType: type,
        style: kInputTextStyleBlack,
        controller: controller,
        autofocus: false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          isDense: true,
          labelText: hintText,
          labelStyle: kInputTextStyleBlack,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black26,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffdfdfdf),
            ),
          ),
        ),
      ),
    );
  }
}
