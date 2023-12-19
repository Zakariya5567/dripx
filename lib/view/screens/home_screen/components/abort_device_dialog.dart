import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
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

Future abortDeviceDialoge({
  required BuildContext context,
  required bool isDelete,
}) {
  final alertProvider = Provider.of<AlertProvider>(context, listen: false);
  final homeProvider = Provider.of<HomeProvider>(context, listen: false);
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
              height: 130.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Do you want to discard the process?"
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
                      alertProvider.deleteLoader ? Container(height: 35.h, width: 35.h, child: Center(child: CircularProgressIndicator(),)) : CustomButton(
                        height: 35.h,
                        width: 94.w,
                        buttonColor: redPrimary,
                        buttonTextColor: whitePrimary,
                        borderColor: redPrimary,
                        textSize: 14,
                        buttonName: "Yes",
                        radius: 8,
                        onPressed: () async {
                          if(alertProvider.isDeviceConnectedValue) {
                            await alertProvider.disconnectDevice();
                          }
                          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
                          // if(isDelete) {
                          //   alertProvider.disconnectDevice();
                          //   // alertProvider.dispose();
                          //   Navigator.pop(context);
                          //   Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
                          // } else {
                          //   alertProvider.disconnectDevice();
                          //   // alertProvider.dispose();
                          //   Navigator.pop(context);
                          //   Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
                          // }

                        }
                      ),
                      10.width,
                      CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: whitePrimary,
                          buttonTextColor: blackPrimary,
                          borderColor: greyPrimary,
                          buttonName: "No",
                          textSize: 14,
                          radius: 8,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            )
        );
      }
  );
}
