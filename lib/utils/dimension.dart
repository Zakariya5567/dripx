import 'package:flutter/material.dart';

mediaQuerySize(BuildContext context) {
  mediaQuery = MediaQuery.of(context).size;
}

// ignore: prefer_typing_uninitialized_variables
var mediaQuery;

double widgetHeight(double pixels) {
  double designHeight = 844;
  return mediaQuery.height / (designHeight / pixels);
}

double widgetWidth(double pixels) {
  double designWidth = 390;
  return mediaQuery.width / (designWidth / pixels);
}
