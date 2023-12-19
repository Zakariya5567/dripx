import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  CustomImage(
      {Key? key,
      required this.image,
      required this.iconColor,
      required this.width,
      required this.height})
      : super(key: key);

  double height;
  double width;
  String image;
  Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: height,
      width: width,
      color: iconColor,
    );
  }
}
