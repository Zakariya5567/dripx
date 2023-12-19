import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/profile_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/custom_text_field.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

verifyCoupon(String couponValue, AuthProvider controller , BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  await controller.couponVerification(context, authProvider.authModel.data!.email!);
}
Future addCouponDialoge({
  required BuildContext context,
}) {


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        return Consumer<AuthProvider>( builder: (context, controller, child) {
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
                // height: 215.h,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      "Enter Coupon"
                          .toText(
                          maxLine: 2,
                          textAlign: TextAlign.center,
                          color: blackPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: sofiaLight)
                          .center,
                      20.height,
                      CustomTextField(
                        controller: controller.couponController,
                        hintText: "Coupon",
                        inputFormatter: 6,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if(value!.length == 0) {
                            controller.couponText = '';
                            controller.couponValidationText = '';
                            controller.couponValidation = false;
                            controller.notifyListeners();
                          }
                          else if(value.length == 6) {
                            controller.couponText = '';
                            controller.couponValidationText = '';
                            controller.couponValidation = false;
                            controller.notifyListeners();
                            verifyCoupon(value, controller, context);
                          }
                          else {
                            RegExp couponRegex = RegExp(r'[A-Z0-9]{6}');
                            bool hasCoupon = couponRegex.hasMatch(value);
                            if(!hasCoupon) {
                              controller.couponValidationText = 'Coupon code must be 6 characters with capital letters and numbers only.';
                              controller.couponValidation = true;
                              controller.notifyListeners();
                            }
                          }

                        },
                        validator: (value) {
                          RegExp couponRegex = RegExp(r'[A-Z0-9]{6}');

                          bool couponRegexResponse = couponRegex.hasMatch(value!);

                          if (value.isEmpty) {
                            return "Enter your coupon";
                          }
                          // else if(!couponRegexResponse) {
                          //   return "Coupon code must be 6 characters with capital letters and numbers only.";
                          // } else {
                            // verifyCoupon(context, value, controller);
                          // }

                        },
                      ),
                      5.height,
                      controller.couponValidation
                        ? controller.couponValidationText.toText(color: redPrimary, maxLine: 3).paddingSymmetric(horizontal: 20.w).align(Alignment.centerLeft)
                        : Container(),
                      10.height,
                      controller.isAddCouponValidation ? Center(child: Container(height: 35.h, child: const CircularProgressIndicator())) :  CustomButton(
                          buttonColor: bluePrimary,
                          buttonName: "Submit",
                          textSize: 14,
                          onPressed: () async {
                            if(formKey.currentState!.validate()) {
                              if(!controller.couponValidation) {
                                FocusManager.instance.primaryFocus!.unfocus();
                                controller.submitCoupon(context);
                              }
                            }
                          }
                      ),
                    ],
                  ).paddingSymmetric(vertical: 20.h, horizontal: 10.h),
                ),
              ));
        });


      });


}
