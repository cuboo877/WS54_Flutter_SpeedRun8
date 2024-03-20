import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun8/constant/style_guide.dart';

Widget customTextButton(Color color, String text, int size, onPressed) {
  return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: size.toDouble(), color: AppColor.white),
      ));
}
