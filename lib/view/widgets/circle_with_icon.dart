import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authentication_provider.dart';
import '../../utils/colors.dart';

class CircleWithIcon extends StatelessWidget {
  CircleWithIcon(
      {Key? key, this.icon, this.image, this.onTap, required this.isIcon})
      : super(key: key);
  IconData? icon;
  String? image;
  bool isIcon;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      height: authProvider.isIpad ? 130.w : 155.w,
      width: authProvider.isIpad ? 130.w : 155.w,
      decoration:
          const BoxDecoration(color: skyBlueLight, shape: BoxShape.circle),
      child: Container(
        decoration:
            const BoxDecoration(color: skyBluePrimary, shape: BoxShape.circle),
        child: Container(
          decoration:
              const BoxDecoration(color: blueLight, shape: BoxShape.circle),
          child: isIcon == false
              ? Image.asset(
                  image!,
                  color: whitePrimary,
                  height: authProvider.isIpad ? 18.w : 25.w,
                  width: authProvider.isIpad ? 18.w : 25.w,
                ).align(Alignment.center)
              : Icon(
                  icon!,
                  color: whitePrimary,
                  size: authProvider.isIpad ? 15.w : 30.w,
                ).align(Alignment.center),
        ).paddingAll(authProvider.isIpad ? 23.w : 30.w),
      ).paddingAll(authProvider.isIpad ? 20.w : 25.w),
    ).onPress(onTap == null ? () {} : onTap!).center;
  }
}
