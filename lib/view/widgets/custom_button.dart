import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authentication_provider.dart';
import 'extention/border_extension.dart';

class CustomButton extends StatelessWidget {

  CustomButton(
      {required this.buttonName,
      required this.onPressed,
      this.buttonTextColor = whitePrimary,
      this.buttonColor = bluePrimary,
      this.borderColor = bluePrimary,
      this.height,
      this.width,
      this.radius = 30,
      this.textSize = 16});

  String buttonName;
  VoidCallback onPressed;
  Color buttonColor;
  Color borderColor;
  Color buttonTextColor = whitePrimary;
  double? height;
  double? width;
  double radius;
  double textSize;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return InkWell(
        onTap: onPressed,
        child: Container(
            height: height ?? 45.h,
            width: width ?? 322.w,
            decoration: BoxDecoration(
                borderRadius: borderRadiusCircular(radius),
                border: borderAll(color: borderColor),
                color: buttonColor),
            child: buttonName
                .toText(
                    color: buttonTextColor,
                    fontSize: authProvider.isIpad ? 22 : textSize,
                    fontFamily: sofiaRegular)
                .center));
  }
}
