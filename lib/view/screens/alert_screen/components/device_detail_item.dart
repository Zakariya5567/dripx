import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';

class DeviceDetailItem extends StatelessWidget {
  DeviceDetailItem({Key? key, required this.title, required this.description})
      : super(key: key);

  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      height: 25.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.h,
            width: 110.w,
            child: title.toText(
                fontSize: authProvider.isIpad ? 18 : 12, color: blackPrimary, fontFamily: sofiaRegular),
          ),
          SizedBox(
            height: 25.h,
            width: 190.w,
            child: description.toText(
                textAlign: TextAlign.end,
                fontSize: authProvider.isIpad ? 18 : 12,
                color: blackLight,
                fontFamily: sofiaLight),
          )
        ],
      ).center.paddingSymmetric(horizontal: 15.h,),
    );
  }
}
