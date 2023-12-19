import 'package:dripx/utils/colors.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

class DataCollectionBox extends StatelessWidget {
  String? title;
  GestureTapCallback? onStartTap;
  bool? isActive = false;
  DataCollectionBox({this.title, this.onStartTap, this.isActive,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bluePrimary.withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title!.toText(fontSize: 16, fontWeight: FontWeight.w500, color: blackPrimary),
          CustomButton(
            buttonName: "Start",
            buttonColor: isActive! ? bluePrimary : greyPrimary,
            borderColor: isActive! ? bluePrimary : greyPrimary,
            buttonTextColor: isActive! ? whitePrimary : blackPrimary,
            width: 85.w,
            height: 35.h,
            radius: 5,
            onPressed: onStartTap!,
          )
        ],
      ).paddingSymmetric(horizontal: 20.w, vertical: 15.h).center,
    );
  }
}
