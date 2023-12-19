
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';

import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';
import '../../widgets/custom_button.dart';

class RecalibratedCalibratedScreen extends StatefulWidget {
  const RecalibratedCalibratedScreen({Key? key}) : super(key: key);

  @override
  State<RecalibratedCalibratedScreen> createState() => _RecalibratedCalibratedScreenState();
}

class _RecalibratedCalibratedScreenState extends State<RecalibratedCalibratedScreen>
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
      child: Scaffold(
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
                                children: const [
                                  // IconButton(
                                  //   onPressed: () {Navigator.pop(context);},
                                  //   icon: Icon(
                                  //     Icons.arrow_back_ios_new,
                                  //     color: blackPrimary,
                                  //     size: 22.w,
                                  //   ),
                                  // ),
                                  // IconButton(
                                  //   onPressed: () {
                                  //     controller.recalibrationDeviceBattery = null;
                                  //     controller.recalibrationDeviceMacAddress = null;
                                  //     controller.recalibrationDeviceFirmwareVersion = null;
                                  //     abortRecalibrateDeviceDialoge(context: context, recalibrate: true);
                                  //   },
                                  //   icon: Icon(
                                  //     Icons.clear,
                                  //     color: blackPrimary,
                                  //     size: 22.w,
                                  //   ),
                                  // ),
                                ],
                              ),
                              60.height,
                              CircleWithIcon(
                                isIcon: false,
                                image: Images.iconTrack,
                              ),
                              Spacer(),
                              controller.isLoading ? const Center(child: CircularProgressIndicator(),) : "Device calibrated successfully".toText(color: blackPrimary, fontWeight: FontWeight.w500, fontSize: 16).center,
                              Spacer(),
                              CustomButton(
                                  buttonColor: controller.isLoading ? greyPrimary : bluePrimary,
                                  borderColor: controller.isLoading ? greyPrimary : bluePrimary,
                                  buttonTextColor: whitePrimary,
                                  buttonName: "Next",
                                  onPressed: () async {
                                    if(!controller.isLoading) {
                                      Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
                                    }
                                    // controller.dispose();
                                  }),
                              30.height,
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
