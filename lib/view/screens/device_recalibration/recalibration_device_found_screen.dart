import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/view/screens/device_recalibration/components/abort_recalibrate_device_dialog.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';

class RecalibrateDeviceFoundScreen extends StatefulWidget {
  const RecalibrateDeviceFoundScreen({Key? key}) : super(key: key);

  @override
  State<RecalibrateDeviceFoundScreen> createState() => _RecalibrateDeviceFoundScreenState();
}

class _RecalibrateDeviceFoundScreenState extends State<RecalibrateDeviceFoundScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: WillPopScope(
        onWillPop: () {return Future.value(false);},
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
                            child: controller.recalibrationDeviceBattery == null || controller.recalibrationDeviceMacAddress == null ||controller.recalibrationDeviceFirmwareVersion == null
                                ? Column(
                              children: [
                                60.height,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      abortRecalibrateDeviceDialoge(context: context, recalibrate: true);
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: blackPrimary,
                                      size: 22.w,
                                    ),
                                  ).paddingSymmetric(horizontal: 20.w),
                                ),
                                Spacer(),
                                Center(child: CircularProgressIndicator(),),
                                Spacer(),
                              ],
                            )
                                : Column(
                              children: [
                                60.height,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
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
                                ),
                                60.height,
                                CircleWithIcon(
                                  isIcon: true,
                                  icon: Icons.search,
                                ),
                                30.height,
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: blueLight.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      getRow("Bluetooth", controller.recalibrationDeviceName!),
                                      12.height,
                                      getRow("Firmware version", controller.recalibrationDeviceFirmwareVersion!),
                                      12.height,
                                      getRow("Serial number", controller.recalibrationConnectedDeviceMacAddress!),
                                      12.height,
                                      getRow("Battery", controller.recalibrationDeviceBattery!),
                                      // 12.height,
                                      // getRow("SD Card", "No"),
                                    ],
                                  ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
                                ),
                                const Spacer(),
                                CustomButton(
                                    buttonColor: bluePrimary,
                                    buttonTextColor: whitePrimary,
                                    buttonName: "Next",
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouterHelper.recalibrateCalibrateDeviceScreen);
                                    }),
                                20.height,
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

  getRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title.toText(fontSize: 15, color: blackPrimary, fontWeight: FontWeight.w600),
        value.toText(fontSize: 13, color: blackLight),
      ],
    );
  }

}
