import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';

class BlueGradient extends StatelessWidget {
  const BlueGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      width: 390.w,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
            gradientDarkGreen,
            gradientGreen,
            gradientLightSkyBLue,
            gradientSkyBlue
          ])),
    );
  }
}
