import 'dart:io';

import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/data_collection_screen/components/data_collection_box.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
import 'package:dripx/view/screens/home_screen/components/logout_dialoge.dart';
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
import 'components/data_collection_alert_box.dart';
import 'components/data_collection_dialog_box.dart';

class DataCollectionScreen extends StatefulWidget {
  const DataCollectionScreen({Key? key}) : super(key: key);

  @override
  State<DataCollectionScreen> createState() => _DataCollectionScreenState();
}

class _DataCollectionScreenState extends State<DataCollectionScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isFirstDataCollectionActive = true;
  bool isSecondDataCollectionActive = false;
  bool isThirdDataCollectionActive = false;
  bool isFourthDataCollectionActive = false;
  bool isFifthDataCollectionActive = false;

  bool goToNextScreen = false;

  @override
  void initState() {
    super.initState();
    var alertProvider = Provider.of<AlertProvider>(context, listen: false);
    alertProvider.addValueInWifiList = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await dataCollectionAlertDialogBox(context: context);
    });
  }

  @override
  void dispose() {
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
                                  "Data Collection".toText(color: blackPrimary, fontSize: 18, fontWeight: FontWeight.w600),
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

                              DataCollectionBox(
                                title: "Data Collection # 1",
                                onStartTap: () {
                                  if(isFirstDataCollectionActive) {
                                    controller.sendData(context, "start_collection", controller.deviceID!);
                                    dataCollectionDialogBox(context: context);
                                    isFirstDataCollectionActive = false;
                                    isSecondDataCollectionActive = true;
                                    controller.notifyListeners();
                                  }
                                },
                                isActive: isFirstDataCollectionActive
                              ),
                              15.height,

                              DataCollectionBox(
                                title: "Data Collection # 2",
                                onStartTap: () {
                                  if(isSecondDataCollectionActive) {
                                    controller.collectionStarted = false;
                                    controller.sendData(context, "start_collection", controller.deviceID!);
                                    dataCollectionDialogBox(context: context);
                                    isSecondDataCollectionActive = false;
                                    isThirdDataCollectionActive = true;
                                    controller.notifyListeners();
                                  }
                                },
                                isActive: isSecondDataCollectionActive
                              ),
                              15.height,

                              DataCollectionBox(
                                title: "Data Collection # 3",
                                onStartTap: () {
                                  if(isThirdDataCollectionActive) {
                                    controller.sendData(context, "start_collection", controller.deviceID!);
                                    dataCollectionDialogBox(context: context);
                                    isFourthDataCollectionActive = true;
                                    isThirdDataCollectionActive = false;
                                    controller.notifyListeners();
                                  }
                                },
                                isActive: isThirdDataCollectionActive
                              ),
                              15.height,

                              DataCollectionBox(
                                title: "Data Collection # 4",
                                onStartTap: () {
                                  if(isFourthDataCollectionActive) {
                                    controller.sendData(context, "start_collection", controller.deviceID!);
                                    dataCollectionDialogBox(context: context);
                                    isFourthDataCollectionActive = false;
                                    isFifthDataCollectionActive = true;
                                    controller.notifyListeners();
                                  }
                                },
                                isActive: isFourthDataCollectionActive,
                              ),
                              15.height,

                              DataCollectionBox(
                                title: "Data Collection # 5",
                                onStartTap: () {
                                  if(isFifthDataCollectionActive) {
                                    controller.sendData(context, "start_collection", controller.deviceID!);
                                    dataCollectionDialogBox(context: context);
                                    goToNextScreen = true;
                                    isFifthDataCollectionActive = false;
                                    controller.notifyListeners();
                                  }
                                },
                                isActive: isFifthDataCollectionActive
                              ),
                              const Spacer(),

                              controller.addValueInWifiList ? const Center(child: CircularProgressIndicator(),) : CustomButton(
                                buttonColor: goToNextScreen ? bluePrimary : greyPrimary,
                                borderColor: goToNextScreen ? bluePrimary : greyPrimary,
                                buttonTextColor: whitePrimary,
                                buttonName: "Next",
                                onPressed: () async {
                                  if(goToNextScreen) {
                                    if(Platform.isAndroid) {
                                      // setupProvider.wifiPasswordController.clear();
                                      // setupProvider.wifiNameController.clear();
                                      // controller.addValueInWifiList = true;
                                      // controller.notifyListeners();
                                      // await controller.sendData(context, "wifi_switching", controller.deviceID!);
                                      Navigator.pushNamed(context, RouterHelper.networkScreen);
                                    }
                                    else {
                                      setupProvider.wifiPasswordController.clear();
                                      setupProvider.wifiNameController.clear();
                                      controller.addValueInWifiList = true;
                                      controller.notifyListeners();
                                      await controller.sendData(context, "wifi_switching", controller.deviceID!);
                                      Navigator.pushNamed(context, RouterHelper.networkFormScreen);
                                    }
                                  }
                                }
                              ),
                              20 .height,
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
