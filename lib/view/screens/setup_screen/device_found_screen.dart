import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
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

class DeviceFoundScreen extends StatefulWidget {
  const DeviceFoundScreen({Key? key}) : super(key: key);

  @override
  State<DeviceFoundScreen> createState() => _DeviceFoundScreenState();
}

class _DeviceFoundScreenState extends State<DeviceFoundScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        key: scaffoldKey,
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
                        child: controller.deviceBattery == null || controller.deviceMacAddress == null ||controller.deviceFirmwareVersion == null
                          ? Column(
                            children: [
                              60.height,
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    abortDeviceDialoge(context: context, isDelete: false);
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
                                    controller.deviceBattery = null;
                                    controller.deviceMacAddress = null;
                                    controller.deviceFirmwareVersion = null;
                                    abortDeviceDialoge(context: context, isDelete: false);
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
                                    getRow("Bluetooth", controller.deviceName!),
                                    12.height,
                                    getRow("Firmware version", controller.deviceFirmwareVersion!),
                                    12.height,
                                    getRow("Serial number", controller.connectedDeviceMacAddress!),
                                    12.height,
                                    getRow("Battery", controller.deviceBattery!),
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
                                    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                                    homeProvider.bluetoothDeviceMacAddress = controller.deviceMacAddress;
                                    controller.nameYourDeviceController.clear();
                                    Navigator.pushNamed(
                                        context, RouterHelper.deviceEntryScreen);
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
