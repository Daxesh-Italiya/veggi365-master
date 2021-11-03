import 'package:flutter/material.dart';

class RoundMaterialButton extends StatelessWidget {


  final String buttonText;
  final Function onPress;
  final Color color;
  final double height,width;
  final TextStyle textStyle;
  final double circular;

  RoundMaterialButton({this.buttonText,this.onPress, this.color, this.height, this.width, this.textStyle, this.circular});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: MaterialButton(
        color: color,
        child: Text(
          buttonText,
          style: textStyle,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular),
        ),
        onPressed:onPress,
      ),
    );
  }
}
