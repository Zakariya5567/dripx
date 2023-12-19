import 'package:flutter/material.dart';

// BORDER ALL
Border borderAll({Color? color, double width = 1}) => Border(
      top: BorderSide(color: color ?? Colors.black, width: width),
      bottom: BorderSide(color: color ?? Colors.black, width: width),
      left: BorderSide(color: color ?? Colors.black, width: width),
      right: BorderSide(color: color ?? Colors.black, width: width),
    );

// BORDER ONLY
Border borderOnly({
  Color? topColor,
  double topWidth = 1,
  Color? bottomColor,
  double bottomWidth = 1,
  Color? leftColor,
  double leftWidth = 1,
  Color? rightColor,
  double rightWidth = 1,
}) =>
    Border(
      top: topColor == null
          ? BorderSide.none
          : BorderSide(
              color: topColor,
              width: topWidth,
            ),
      bottom: bottomColor == null
          ? BorderSide.none
          : BorderSide(
              color: bottomColor,
              width: bottomWidth,
            ),
      left: leftColor == null
          ? BorderSide.none
          : BorderSide(
              color: leftColor,
              width: leftWidth,
            ),
      right: rightColor == null
          ? BorderSide.none
          : BorderSide(
              color: rightColor,
              width: rightWidth,
            ),
    );

// CIRCULAR BORDER RADIUS
BorderRadius borderRadiusCircular(double radius) =>
    BorderRadius.circular(radius);

// ONLY BORDER RADIUS
BorderRadius borderRadiusOnly(
        {double topLeft = 0,
        double bottomLeft = 0,
        double bottomRight = 0,
        double topRight = 0}) =>
    BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
