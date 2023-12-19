import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class WhiteGradient extends StatelessWidget {
  const WhiteGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      width: 390.w,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0.98),
            Color.fromRGBO(255, 255, 255, 0.90),
            Color.fromRGBO(255, 255, 255, 0.3),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
          ])),
    );
  }
}
