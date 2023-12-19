import 'dart:async';

import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/colors.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/blue_gradient.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/gradient_status_bar.dart';
import '../../widgets/white_gradient.dart';

class UpdateFirmwareScreen extends StatefulWidget {
  const UpdateFirmwareScreen({Key? key}) : super(key: key);

  @override
  State<UpdateFirmwareScreen> createState() => _UpdateFirmwareScreenState();
}

class _UpdateFirmwareScreenState extends State<UpdateFirmwareScreen> {

  bool callApi = false;
  @override
  void initState() {
    // TODO: implement initState
    callApi = true;
    startApiCalling(context);
    super.initState();
  }

  @override
  dispose() {
    callApi = false;
    super.dispose();
  }

  navigate() {
    Timer(const Duration(seconds: 5), () async {
      Navigator.pushNamed(context, RouterHelper.updatedFirmwareScreen);
    });
  }

  startApiCalling(BuildContext context) async {
    var controller = Provider.of<HomeProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    var authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    print(controller.updatedDevice);
    if(callApi) {
      await controller.getDevices(context, controller.updatedDevice!.name!, 1.toString(), isUpdate : true);
      if(controller.updateDevices.data!.length!=0) {
        for(int i=0; i<controller.updateDevices.data!.length; i++) {
          if(controller.updatedDevice!.id == controller.updateDevices.data![i].id) {
            if(authProvider.firmwareVersion == controller.updateDevices.data![i].firmwareVersion) {
              Navigator.pushNamed(context, RouterHelper.updatedFirmwareScreen);
              callApi = false;
            } else {
              print("15 second delayed start");
              await Future.delayed(const Duration(seconds: 15));
              print("15 second delayed end");
              startApiCalling(context);
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: "Update Firmware"),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                "Latest Version: ".toText(fontSize: 18, isBold: true, color: blackPrimary),
                                authProvider.firmwareVersion!.toText(fontSize: 18, color: blackPrimary),
                              ],
                            ),
                            12.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                "Current Version: ".toText(fontSize: 18, isBold: true, color: blackPrimary),
                                controller.updatedDevice!.firmwareVersion!.toText(fontSize: 18, color: blackPrimary),
                              ],
                            ),
                            12.height,
                            "Please restart your DripX device. And wait for a moment...".toText(
                              fontSize: 18,
                              maxLine: 10,
                              fontFamily: sofiaSemiBold,
                              color: blackPrimary
                            ),
                            20.height,

                          ],
                        ).paddingSymmetric(horizontal: 25.w),
                      )
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
