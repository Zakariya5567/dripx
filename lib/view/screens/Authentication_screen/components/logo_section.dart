import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';

class LogoSection extends StatelessWidget {
  LogoSection({Key? key, required this.image, required this.title})
      : super(key: key);

  String image;
  String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 390.w,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.height,
              Image.asset(
                image,
                height: 90.w,
                width: 90.w,
              ).align(Alignment.center),
              15.height,
              title.toText(
                  fontSize: 25,
                  fontFamily: sofiaLight,
                  fontWeight: FontWeight.w300,
                  color: whitePrimary)
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              Images.sideLogoImage,
              height: 200.h,
              width: 110.w,
            ),
          )
        ],
      ),
    );
  }
}
