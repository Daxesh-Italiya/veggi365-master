import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final color;
  final String text;
  final Color textColor;
  const CustomButton({this.height, this.color, this.text,this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                decoration: TextDecoration.none,
                color:textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}