import 'dart:io';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future updateAppDialog({
  required BuildContext context,
}) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
          // height: 130.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              "Update Available".toText(
                maxLine: 8,
                // textAlign: TextAlign.center,
                color: blackPrimary,
                fontSize: 16,
                isBold: true,
                fontFamily: sofiaBold
              ).center,
              7.height,
              "A new version of DripX is now available. We recommend updating to access the latest features, improvements, and bug fixes. Click 'Update' to get the latest version."
                .toText(
                maxLine: 8,
                textAlign: TextAlign.start,
                color: blackPrimary,
                fontSize: 15,
                fontFamily: sofiaLight
              ).center,
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    height: 35.h,
                    width: 230.w,
                    buttonColor: bluePrimary,
                    buttonTextColor: whitePrimary,
                    borderColor: bluePrimary,
                    textSize: 14,
                    buttonName: "Update",
                    radius: 8,
                    onPressed: () async {
                      if(Platform.isAndroid || Platform.isIOS) {
                        final appId = 'com.dripx.dripxapp';
                        final url = Uri.parse(
                          Platform.isAndroid
                            ? "market://details?id=$appId"
                            : "https://apps.apple.com/app/id6459365458",
                        );
                        launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    }
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(vertical: 15.h, horizontal: 10.w),
        ),
      );
    }
  );
}
