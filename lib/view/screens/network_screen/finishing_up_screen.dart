import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';
import '../../widgets/wave_animation.dart';

class FinishingUpScreen extends StatefulWidget {
  const FinishingUpScreen({Key? key}) : super(key: key);

  @override
  State<FinishingUpScreen> createState() => _FinishingUpScreenState();
}

class _FinishingUpScreenState extends State<FinishingUpScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: const Duration(seconds: 5),
    )..repeat();
    Future.delayed(const Duration(seconds: 5)).then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, RouterHelper.finishedScreen, (Route<dynamic> route) => false)
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<AlertProvider>(builder: (context, controller, child) {
          return SizedBox(
            height: 844.h,
            width: 390.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const GradientStatusBar(),
                      const BlueGradient(),
                      const WhiteGradient(),
                      SizedBox(
                          height: 840.h,
                          width: 390.w,
                          child: Column(
                            children: [
                              60.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {Navigator.pop(context);},
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: blackPrimary,
                                      size: 22.w,
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                              80.height,
                              SizedBox(
                                  height: 155.w,
                                  width: 155.w,
                                  child: Stack(
                                    children: [
                                      CircleWithIcon(
                                        isIcon: false,
                                        image: Images.iconDone,
                                      ),
                                      WaveAnimation(
                                        animationController:
                                            animationController,
                                        isIcon: false,
                                        image: Images.iconDone,
                                        onTap: () {
                                          // Navigator.pushNamed(context,
                                          //     RouterHelper.finishedScreen);
                                        },
                                      ).center,
                                    ],
                                  )),
                              10.height,
                              finishingUp
                                  .toText(
                                      fontSize: 20,
                                      fontFamily: sofiaRegular,
                                      color: blackDark)
                                  .center,
                            ],
                          ).paddingSymmetric(horizontal: 20.w))
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
