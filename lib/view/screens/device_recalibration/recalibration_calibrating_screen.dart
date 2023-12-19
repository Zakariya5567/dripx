import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/view/screens/device_recalibration/components/abort_recalibrate_device_dialog.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/show_toast.dart';
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

class RecalibrationCalibratingScreen extends StatefulWidget {
  const RecalibrationCalibratingScreen({Key? key}) : super(key: key);

  @override
  State<RecalibrationCalibratingScreen> createState() => _RecalibrationCalibratingScreenState();
}

class _RecalibrationCalibratingScreenState extends State<RecalibrationCalibratingScreen>
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
      child: WillPopScope(
        onWillPop: () {
          showToast(message: "Can't go back during device calibration");
          return Future.value(false);
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: whitePrimary,
          body: Consumer<ReCalibrationProvider>(builder: (context, controller, child) {
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
                                    IconButton(
                                      onPressed: () {
                                        abortRecalibrateDeviceDialoge(context: context, recalibrate: true);
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: blackPrimary,
                                        size: 22.w,
                                      ),
                                    ),
                                  ],
                                ),
                                75.height,
                                SizedBox(
                                    height: 155.w,
                                    width: 155.w,
                                    child: Stack(
                                      children: [
                                        CircleWithIcon(
                                          isIcon: false,
                                          image: Images.iconTrack,
                                        ),
                                        WaveAnimation(
                                          animationController:
                                          animationController,
                                          image: Images.iconTrack,
                                          isIcon: false,
                                          onTap: () {
                                            // Navigator.pushNamed(context,
                                            //     RouterHelper.calibratedScreen);
                                          },
                                        ).center,
                                      ],
                                    )),
                                30.height,
                                calibrating
                                    .toText(
                                    color: blackPrimary,
                                    fontSize: 20,
                                    fontFamily: sofiaSemiBold)
                                    .center,
                                130.height,
                                calibratingDescription
                                    .toText(
                                    textAlign: TextAlign.center,
                                    maxLine: 4,
                                    color: greyPrimary,
                                    fontSize: 16,
                                    fontFamily: sofiaLight)
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
      ),
    );
  }
}
