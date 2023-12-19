import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast({@required String? message}) {
  // Toast.show(message!, duration: Toast.lengthShort, gravity:  Toast.bottom);
  // ScaffoldMessenger.of(AppKeys.mainNavigatorKey.currentContext!).showSnackBar(SnackBar(
  //   content: Text(
  //     message,
  //     textAlign: TextAlign.center,
  //     style: const TextStyle(
  //       color: whitePrimary,
  //       fontSize: 16,
  //     ),
  //   ),
  //   backgroundColor: primaryColor[900],
  //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  //   // shape: RoundedRectangleBorder(
  //   //   borderRadius: BorderRadius.only(
  //   //       topRight: Radius.circular(20), topLeft: Radius.circular(20)),
  //   // ),
  //   elevation: 10,
  //   duration: Duration(seconds: 3),
  //   behavior: SnackBarBehavior.floating,
  //   margin: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
  // ));
  Fluttertoast.showToast(
    msg: message!,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
    fontSize: 16,
  );

}