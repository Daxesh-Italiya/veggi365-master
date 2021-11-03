import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType type;
  final double height;
  bool obscureText;
  bool enable;

  CustomTextField(
      {this.controller,
      this.hintText,
      this.type,
      this.height,
        this.enable = true,
      this.obscureText});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3.0)],
        borderRadius: BorderRadius.circular(8),
      ),
      width: size.width * 0.9,
      height: widget.height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            obscureText: widget.obscureText,
            keyboardType: widget.type,
            enabled: widget.enable,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                decoration: TextDecoration.none),
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            autofocus: false,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              hintText: widget.hintText,
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.black38,
                decoration: TextDecoration.none,
              ),
              labelStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldShow extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefix;
  final String suffix;
  final TextInputType type;
  final double height;
  bool obscureText;

  CustomTextFieldShow(
      {this.controller,
      this.hintText,
      this.prefix,
      this.type,
      this.height,
      this.obscureText,
      this.suffix});

  @override
  _CustomTextFieldShowState createState() => _CustomTextFieldShowState();
}

class _CustomTextFieldShowState extends State<CustomTextFieldShow> {
  void toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  // bool obscureText = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black26, width: 1)),
      width: size.width * 0.9,
      height: widget.height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
              obscureText: widget.obscureText,
              keyboardType: widget.type,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  decoration: TextDecoration.none),
              textAlignVertical: TextAlignVertical.center,
              controller: widget.controller,
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: widget.hintText,
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
    );
  }
}
