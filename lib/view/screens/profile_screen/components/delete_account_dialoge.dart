import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future deleteAccountDialog({
  required BuildContext context,
}) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
              height: 130.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  deleteAccountDescription
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
                          buttonName: btnCancel,
                          textSize: 14,
                          radius: 8,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      10.width,
                      controller.deleteUserLoading ? Container(width: 100.w, height: 35.h, child: const Center(child: CircularProgressIndicator())) :  CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: redPrimary,
                          buttonTextColor: whitePrimary,
                          borderColor: redPrimary,
                          textSize: 14,
                          buttonName: btnDelete,
                          radius: 8,
                          onPressed: () {
                            // Navigator.pop(context);
                            authProvider.deleteUser(context);
                          }
                      )
                    ],
                  )
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            )
        );
      });
    }
  );
}
