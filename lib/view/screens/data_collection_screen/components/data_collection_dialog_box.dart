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

Future dataCollectionDialogBox({
  required BuildContext context,
}) {
  final alertProvider = Provider.of<AlertProvider>(context, listen: false);
  final homeProvider = Provider.of<HomeProvider>(context, listen: false);
  return showDialog(
      barrierDismissible: false,
    context: context,
    builder: (context) {
      return Consumer<AlertProvider>(builder: (context, controller, child) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  controller.collectionStarted
                    ? "Please wait, data collection is in progress.".toText(
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight,
                    ).center
                    : "Press the flush button.".toText(
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight,
                    ).center
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            )
        );
      });
    }
  );
}
