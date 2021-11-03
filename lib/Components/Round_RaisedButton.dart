import 'package:flutter/material.dart';

class RoundRaisedButton extends StatelessWidget {
  final String buttonText;
  final String icon;
  final Function onPress;
  final Color color;
  final double height, width;
  final TextStyle textStyle;
  final double circular;

  RoundRaisedButton(
      {this.buttonText,
      this.onPress,
      this.color,
      this.height,
      this.width,
      this.textStyle,
      this.circular,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: RaisedButton.icon(
        elevation: 3,
        icon: Image.asset('assets/icons/$icon', height: 20, width: 20),
        color: color,
        label: Text(
          buttonText,
          style: textStyle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circular),
        ),
        onPressed: onPress,
      ),
    );
  }
}
