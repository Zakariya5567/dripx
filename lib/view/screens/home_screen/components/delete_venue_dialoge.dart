import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/provider/wifi_switching_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future deleteDeviceDialoge({
  required BuildContext context,
  required String venueID,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer<HomeProvider>( builder: (context, controller, child) {
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
                  "Do you want to delete the venue?"
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
                      controller.isDeleteVenue ? Center(child: Container(height: 35.h, width: 35.h, child: const CircularProgressIndicator())) : CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: redPrimary,
                          buttonTextColor: whitePrimary,
                          borderColor: redPrimary,
                          textSize: 14,
                          buttonName: "Yes",
                          radius: 8,
                          onPressed: () async {
                            controller.deleteVenue(venueID, context);
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
            ));
      });
    }
  );
}
