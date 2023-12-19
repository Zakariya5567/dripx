import 'package:dripx/utils/colors.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:flutter/material.dart';

class Wave1Animation extends StatefulWidget {
  Wave1Animation({Key? key, required this.icon}) : super(key: key);
  IconData icon;

  @override
  State<Wave1Animation> createState() => _Wave1AnimationState();
}

class _Wave1AnimationState extends State<Wave1Animation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(150 * _controller!.value),
            _buildContainer(200 * _controller!.value),
            _buildContainer(250 * _controller!.value),
            _buildContainer(300 * _controller!.value),
            _buildContainer(350 * _controller!.value),
            Align(
                child: Icon(
              widget.icon,
              color: whitePrimary,
              size: 30.w,
            )),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(1 - _controller!.value),
      ),
    );
  }
}
