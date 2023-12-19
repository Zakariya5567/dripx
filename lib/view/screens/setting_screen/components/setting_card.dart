import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class SettingCard extends StatelessWidget {
  SettingCard({Key? key, required this.title, required this.onTap, this.isActive = true})
      : super(key: key);

  String title;
  bool? isActive;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 340.w,
      decoration: BoxDecoration(
          color: isActive! ? greenLight : greyLight, borderRadius: borderRadiusCircular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25.h,
            width: 240.w,
            child: title.toText(
                fontSize: 16, color: blackDark, fontFamily: sofiaRegular),
          ),
          CustomImage(
            image: Images.iconArrowForward,
            iconColor: blackDark,
            width: 15.w,
            height: 15.w,
          ).paddingOnly(right: 20.w),
        ],
      ).paddingOnly(top: 5.h, bottom: 5.h, left: 15.w, right: 5.w),
    ).onPress(onTap).paddingSymmetric(vertical: 5.h);
  }
}
