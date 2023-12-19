
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

Future userBlockDialoge({
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
              "Your account has been blocked because of too many unauthorized attempt of adding device."
                .toText(
                maxLine: 5,
                textAlign: TextAlign.center,
                color: blackPrimary,
                fontSize: 16,
                fontFamily: sofiaLight
              ).center,
              20.height,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    height: 35.h,
                    // width: 94.w,
                    buttonColor: bluePrimary,
                    buttonTextColor: whitePrimary,
                    borderColor: bluePrimary,
                    textSize: 14,
                    buttonName: "Contact Admin",
                    radius: 8,
                    onPressed: () async {
                      Navigator.pop(context);
                      sendMail();
                    }
                  ),
                  10.height,
                  CustomButton(
                    height: 35.h,
                    // width: 94.w,
                    buttonColor: whitePrimary,
                    buttonTextColor: blackPrimary,
                    borderColor: greyPrimary,
                    buttonName: "Cancel",
                    textSize: 14,
                    radius: 8,
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                ],
              )
            ],
          ).paddingSymmetric(vertical: 20.h, horizontal: 10),
        )
      );
    }
  );
}

sendMail() async {
  // Android and iOS
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'miansabahat10@gmail.com',
    // queryParameters: {'subject': 'Feedback', 'body': ''},
  );

  if (await canLaunch(_emailLaunchUri.toString())) {
    await launch(_emailLaunchUri.toString());
  } else {
    throw 'Could not launch email';
  }
}

