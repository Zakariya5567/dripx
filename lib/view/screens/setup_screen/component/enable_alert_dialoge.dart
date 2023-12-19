import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future enableAlertPrompt({
  required BuildContext context,
  required GestureTapCallback onNoClick,
  required GestureTapCallback onYesClick,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              color: whitePrimary,
              width: 250.w,
              height: 120.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Do you want to enable the alerts?"
                      .toText(
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight)
                      .center,
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: whitePrimary,
                          buttonTextColor: blackPrimary,
                          borderColor: greyPrimary,
                          buttonName: "No",
                          textSize: 14,
                          radius: 8,
                          onPressed: onNoClick,
                      ),
                      10.width,
                      CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: bluePrimary,
                          buttonTextColor: whitePrimary,
                          borderColor: bluePrimary,
                          textSize: 14,
                          buttonName: "Yes",
                          radius: 8,
                          onPressed: onYesClick
                      )
                    ],
                  )
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            ));
      });
}
