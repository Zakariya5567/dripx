import 'package:dripx/data/model/notification/notification_model.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/device_recalibration/components/abort_recalibrate_device_dialog.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
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
import '../../../provider/setup_provider.dart';
import '../../../utils/string.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/extention/border_extension.dart';

class RecalibrateDeviceScreen extends StatefulWidget {
  const RecalibrateDeviceScreen({Key? key}) : super(key: key);

  @override
  State<RecalibrateDeviceScreen> createState() => _RecalibrateDeviceScreenState();
}

class _RecalibrateDeviceScreenState extends State<RecalibrateDeviceScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      // controller.recalibrationDeviceBattery = null;
                                      // controller.recalibrationDeviceMacAddress = null;
                                      // controller.recalibrationDeviceFirmwareVersion = null;
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
                              Image.asset(
                                Images.deviceImageNew,
                                height: 250.h,
                                width: 340,
                              ),
                              30.height,
                              "Re-Calibrate Your Device"
                                  .toText(
                                  color: blackPrimary,
                                  fontSize: 20,
                                  fontFamily: sofiaSemiBold)
                                  .center,
                              10.height,
                              "Calibration is mandatory"
                                  .toText(
                                  textAlign: TextAlign.center,
                                  maxLine: 4,
                                  color: blackLight,
                                  fontSize: 16,
                                  fontFamily: sofiaLight)
                                  .center,
                              300.height,
                              controller.isCalibratingStartLoading ? const Center(child: CircularProgressIndicator(),) :
                              CustomButton(
                                  buttonName: "Re-Calibrate",
                                  onPressed: () async {
                                    controller.startCalibrating(context);
                                    controller.isCalibratingStartLoading = true;
                                    controller.notifyListeners();
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pushNamed(context, RouterHelper.recalibrationCalibratingScreen);
                                    controller.isCalibratingStartLoading = false;
                                    controller.notifyListeners();

                                  }).center,
                            ],
                          ).paddingSymmetric(horizontal: 25.w))
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
