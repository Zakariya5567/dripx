import 'dart:async';

import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/setup_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';

class IOSNetworkScreen extends StatefulWidget {
  const IOSNetworkScreen({Key? key}) : super(key: key);

  @override
  State<IOSNetworkScreen> createState() => _IOSNetworkScreenState();
}

class _IOSNetworkScreenState extends State<IOSNetworkScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
                              Image.asset(
                                Images.deviceImageNew,
                                height: 250.h,
                                width: 340.w,
                              ),
                              20.height,
                              connectToWiFiNetwork.toText(
                                  color: blackPrimary,
                                  fontSize: 20,
                                  fontFamily: sofiaSemiBold),
                              15.height,
                              wifiDescription.toText(
                                  textAlign: TextAlign.center,
                                  maxLine: 3,
                                  color: blackLight,
                                  fontSize: 16,
                                  fontFamily: sofiaLight),
                              30.height,
                              Container(
                                height: 1,
                                width: 390.w,
                                color: skyBluePrimary,
                              ),
                              10.height,
                              // SizedBox(
                              //   height: 40.h,
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       availableNetworks.toText(
                              //           fontSize: 12,
                              //           color: greyPrimary,
                              //           fontFamily: sofiaLight),
                              //       CustomImage(
                              //           image: Images.iconSetting,
                              //           iconColor: greyPrimary,
                              //           width: 15.w,
                              //           height: 15.w)
                              //     ],
                              //   ),
                              // ),
                              Expanded(
                                child: controller.wifiNetworks == null || controller.wifiNetworks.length == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          "No wifi available".toText(fontSize: 16),

                                          10.height,
                                          CustomButton(buttonName: "Add wifi manually", onPressed: () {Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);}),

                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.wifiNetworks.length,
                                        itemBuilder: (context, index) {
                                          return controller.wifiNetworks[index] == ''
                                              ? const SizedBox()
                                              : SizedBox(
                                            height: 40.h,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.wifi,
                                                  color: bluePrimary,
                                                  size: 25.w,
                                                ),
                                                15.width,
                                                controller.wifiNetworks[index].toText(
                                                    fontSize: 18,
                                                    color: blackDark,
                                                    fontFamily: sofiaRegular,
                                                    overflow: TextOverflow.ellipsis
                                                ),
                                              ],
                                            ),
                                          ).onPress(() {
                                            setupProvider.wifiNameController.text = controller.wifiNetworks[index];
                                            setupProvider.wifiPasswordController.clear();
                                            Navigator.pushNamed(context, RouterHelper.networkFormScreen, arguments: controller.wifiNetworks[index]);
                                          });
                                        }
                                    ),
                              )
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
