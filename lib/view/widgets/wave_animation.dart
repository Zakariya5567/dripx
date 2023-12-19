import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class WaveAnimation extends StatelessWidget {
  WaveAnimation({
    Key? key,
    required this.animationController,
    this.icon,
    this.image,
    this.onTap,
    required this.isIcon,
  }) : super(key: key);

  AnimationController? animationController;
  IconData? icon;
  String? image;
  bool isIcon;
  VoidCallback? onTap;

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - animationController!.value),
      ),
    ).onPress(onTap == null ? () {} : onTap!).center;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
          parent: animationController!, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(110.w * animationController!.value),
            _buildContainer(160.w * animationController!.value),
            isIcon == false
                ? Image.asset(
                    image!,
                    color: whitePrimary,
                    height: 25.w,
                    width: 25.w,
                  ).align(Alignment.center)
                : Align(
                    child: Icon(
                    icon!,
                    color: whitePrimary,
                    size: 30.w,
                  )),
          ],
        );
      },
    );
  }
}
