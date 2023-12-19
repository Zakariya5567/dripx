import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/authentication_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';

class CustomAppBarAuth extends StatelessWidget {
  CustomAppBarAuth({
    Key? key,
    required this.title,
    this.isBackEnable = true,
    this.changeColor = false,
  }) : super(key: key);

  String title;
  bool isBackEnable;
  bool changeColor;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      height: 40.h,
      width: 390.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isBackEnable == true
              ? Image.asset(
            Images.iconArrowBack,
            height: authProvider.isIpad ? 12.w : 20.w,
            width: authProvider.isIpad ? 12.w : 20.w,
            color: changeColor ? whitePrimary : blackSecondary,
          ).onPress(() {
            Navigator.pop(context);
          })
              : SizedBox(
            width: 20.w,
          ),
          title
              .toText(
              fontSize: 20,
              fontFamily: sofiaSemiBold,
              color: blackSecondary)
              .center,
          SizedBox(
            width: 20.w,
          ),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
