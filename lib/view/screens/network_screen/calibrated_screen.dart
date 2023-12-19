import 'dart:io';

import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

import '../../../provider/setup_provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';
import '../../widgets/custom_button.dart';

class CalibratedScreen extends StatefulWidget {
  const CalibratedScreen({Key? key}) : super(key: key);

  @override
  State<CalibratedScreen> createState() => _CalibratedScreenState();
}

class _CalibratedScreenState extends State<CalibratedScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    var alertProvider = Provider.of<AlertProvider>(context, listen: false);
    alertProvider.addValueInWifiList = false;
    alertProvider.isDeviceInWaterTank = false;
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
    var setupProvider = Provider.of<SetupProvider>(context, listen: false);
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
                                  IconButton(
                                    onPressed: () {
                                      controller.deviceBattery = null;
                                      controller.deviceMacAddress = null;
                                      controller.deviceFirmwareVersion = null;
                                      abortDeviceDialoge(context: context, isDelete: true);
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: blackPrimary,
                                      size: 22.w,
                                    ),
                                  ),
                                ],
                              ),
                              60.height,
                              CircleWithIcon(
                                isIcon: false,
                                image: Images.iconTrack,
                              ),
                              150.height,
                              "Device calibrated successfully.".toText(color: blackPrimary, fontWeight: FontWeight.w500, fontSize: 16, maxLine: 4, overflow: TextOverflow.visible).center,
                              20.height,
                              "Place your device in water tank for data gathering purpose.".toText(color: blackPrimary, fontWeight: FontWeight.w600, fontSize: 16, maxLine: 4, overflow: TextOverflow.visible, textAlign: TextAlign.center, ).center,
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 20.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: controller.isDeviceInWaterTank ? bluePrimary : greyPrimary),
                                      color: controller.isDeviceInWaterTank ? bluePrimary : Colors.transparent
                                    ),
                                    child: Icon(Icons.done, color: whitePrimary, size: 12.w,).center,
                                  ),
                                  10.width,
                                  "Yes, my device is in the water tank.".toText(color: blackPrimary, fontWeight: FontWeight.w500, fontSize: 14),
                                ],
                              ).onPress(() { controller.isDeviceInWaterTank = !controller.isDeviceInWaterTank; controller.notifyListeners();}).paddingSymmetric(horizontal: 20.w),
                              15.height,
                              controller.readyToUseLoading ? const Center(child: CircularProgressIndicator(),) : CustomButton(
                                buttonColor: controller.isDeviceInWaterTank ? bluePrimary : greyPrimary,
                                borderColor: controller.isDeviceInWaterTank ? bluePrimary : greyPrimary,
                                buttonTextColor: whitePrimary,
                                buttonName: "Placed",
                                onPressed: () async {
                                  if(controller.isDeviceInWaterTank) {
                                    controller.readyToUseLoading = true;
                                    controller.notifyListeners();
                                    controller.sendData(context, "data_collection", controller.deviceID!);
                                    controller.readyToUseLoading = false;
                                    controller.notifyListeners();
                                    Navigator.pushNamed(context, RouterHelper.dataCollectionScreen);
                                  }
                                }
                              ),
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
