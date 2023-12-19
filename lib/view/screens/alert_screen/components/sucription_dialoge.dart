import 'dart:io';

import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/screens/home_screen/components/add_coupon_dialoge.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future subscriptionDialog({
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
              // height: 200.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  "You must have subscription plan ${authProvider.isShowCouponContainer ? "or a coupon availed " : "" }to access alerts feature."
                      .toText(
                      maxLine: 3,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight)
                      .center,
                  10.height,
                  if(Platform.isIOS)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "By continuing, you agree to our ",
                                style: TextStyle(
                                  color: blackPrimary,
                                  fontSize: authProvider.isIpad ? 20 : 14,
                                  fontFamily: sofiaRegular,
                                ),
                              ),
                              TextSpan(
                                text: 'Term & Conditions ',
                                style: const TextStyle(
                                  color: blueSecondary,
                                  fontSize: 14,
                                  fontFamily: sofiaRegular,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.pushNamed(context, RouterHelper.termAndConditionScreen);
                                },
                              ),
                              const TextSpan(
                                text: "and ",
                                style: TextStyle(
                                  color: blackPrimary,
                                  fontSize: 14,
                                  fontFamily: sofiaRegular,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style: const TextStyle(
                                  color: blueSecondary,
                                  fontSize: 14,
                                  fontFamily: sofiaRegular,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.pushNamed(context, RouterHelper.privacyPolicyScreen);
                                },
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  10.height,
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
                          buttonName: "Show Subscription Plan",
                          radius: 8,
                          onPressed: () {
                            Navigator.pop(context);
                            openWebsite();
                          }),
                      10.height,
                      !authProvider.isShowCouponContainer
                          ? CustomButton(
                            height: 35.h,
                            buttonColor: whitePrimary,
                            buttonTextColor: blackPrimary,
                            borderColor: greyPrimary,
                            buttonName: btnCancel,
                            textSize: 14,
                            radius: 8,
                            onPressed: () {
                              Navigator.pop(context);
                            })
                          : CustomButton(
                            height: 35.h,
                            // width: 94.w,
                            buttonColor: bluePrimary,
                            buttonTextColor: whitePrimary,
                            borderColor: bluePrimary,
                            textSize: 14,
                            buttonName: "Apply Coupon",
                            radius: 8,
                            onPressed: () {
                              Navigator.pop(context);
                              authProvider.couponController.clear();
                              authProvider.couponText = '';
                              authProvider.couponValidationText = '';
                              authProvider.couponValidation = false;
                              addCouponDialoge(context: context);
                            }
                          )
                    ],
                  )
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            ));
      });


}

void openWebsite() async {
  final Uri _url = Uri.parse('https://app.iottechnologies.io/subscriptions/plans');

  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}