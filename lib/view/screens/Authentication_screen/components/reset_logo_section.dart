import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/authentication_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';

class ResetLogoSection extends StatelessWidget {
  ResetLogoSection(
      {Key? key,
      required this.image,
      required this.title,
      required this.description,
      required this.iconColor,
      required this.titleVisibility,
      required this.iconVisibility})
      : super(key: key);

  String image;
  String title;
  String description;
  Color iconColor;
  bool titleVisibility;
  bool iconVisibility;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      height: authProvider.isIpad ? 340.h : 330.h,
      width: 390.w,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconVisibility == false ? 210.height : 150.height,
              Visibility(
                visible: iconVisibility,
                child: Container(
                  height: 90.w,
                  width: 90.w,
                  decoration: const BoxDecoration(
                      color: bluePrimary, shape: BoxShape.circle),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: whitePrimary, shape: BoxShape.circle),
                    child: Image.asset(
                      image,
                      height: 30.w,
                      width: 30.w,
                      color: iconColor,
                    ).align(Alignment.center),
                  ).paddingAll(15.w),
                ).center,
              ).center,
              15.height,
              Visibility(
                visible: titleVisibility,
                child: title.toText(
                    fontSize: authProvider.isIpad ? 26 : 20,
                    fontFamily: sofiaMedium,
                    fontWeight: FontWeight.w300,
                    color: whitePrimary),
              ).center,
              SizedBox(
                width: 320.w,
                child: description.toText(
                    fontSize: authProvider.isIpad ? 22 : 16,
                    textAlign: TextAlign.center,
                    maxLine: 4,
                    fontFamily: sofiaLight,
                    color: whiteSecondary),
              ).paddingOnly(top: 10.h).center
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              Images.sideLogoImage,
              height: 250.h,
              width: 110.w,
            ),
          )
        ],
      ),
    );
  }
}
