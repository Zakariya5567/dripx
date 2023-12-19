import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/setting_provider.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.controller})
      : super(key: key);

  String title;
  VoidCallback onTap;
  SettingProvider controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 340.w,
      decoration: BoxDecoration(
          color: greenLight, borderRadius: borderRadiusCircular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25.h,
            width: 240.w,
            child: title.toText(
                fontSize: 16, color: blackDark, fontFamily: sofiaRegular),
          ),
          Container(
            height: 20.h,
            width: 35.w,
            decoration: BoxDecoration(
                color: purplePrimary, borderRadius: borderRadiusCircular(10)),
            child: Row(
              children: [
                Container(
                  height: 15.w,
                  width: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isNotify == false
                        ? whitePrimary
                        : purplePrimary,
                  ),
                ).paddingOnly(left: 2.w),
                Container(
                  height: 15.w,
                  width: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isNotify == true
                        ? whitePrimary
                        : purplePrimary,
                  ),
                ).onPress(() {
                  controller.setNotify();
                }).paddingOnly(right: 2.w)
              ],
            ),
          ).paddingOnly(right: 20.w),
        ],
      ).paddingOnly(top: 5.h, bottom: 5.h, left: 15.w, right: 5.w),
    ).onPress(onTap).paddingSymmetric(vertical: 5.h);
  }
}
