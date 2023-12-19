import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/images.dart';
import 'extention/border_extension.dart';

class ButtonWithIcon extends StatelessWidget {
  ButtonWithIcon(
      {required this.buttonName,
      required this.onPressed,
      this.buttonTextColor = whitePrimary,
      this.buttonColor = bluePrimary,
      this.borderColor = bluePrimary,
      this.height,
      this.width,
      required this.icon});

  String buttonName;
  VoidCallback onPressed;
  Color buttonColor;
  Color borderColor;
  Color buttonTextColor = whitePrimary;
  double? height;
  double? width;
  String icon;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return InkWell(
        onTap: onPressed,
        child: Container(
            height: height ?? 44.h,
            width: width ?? 322.w,
            decoration: BoxDecoration(
                borderRadius: borderRadiusCircular(30),
                border: borderAll(color: borderColor),
                color: buttonColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  height: authProvider.isIpad ? 18.w : 25.w,
                  width: authProvider.isIpad ? 18.w : 25.w,
                ),
                20.width,
                buttonName
                    .toText(
                        color: buttonTextColor,
                        fontSize: authProvider.isIpad ? 22 : 16,
                        fontFamily: sofiaRegular)
                    .center
              ],
            )));
  }
}
