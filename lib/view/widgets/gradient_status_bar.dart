import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class GradientStatusBar extends StatelessWidget {
  const GradientStatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top,
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
