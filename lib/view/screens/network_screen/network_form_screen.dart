import 'dart:io';

import 'package:dripx/helper/validation.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/setup_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_connector/wifi_connector.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import '../../../utils/colors.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class NetworkFormScreen extends StatefulWidget {
  const NetworkFormScreen({Key? key}) : super(key: key);

  @override
  State<NetworkFormScreen> createState() => _NetworkFormScreenState();
}

class _NetworkFormScreenState extends State<NetworkFormScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool status = false;
  bool isWifiConnecting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  WifiNetwork? wiFiAccessPoint;

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<SetupProvider>(builder: (context, controller, child) {

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
                          child: Form(
                            key: formKey,
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
                                        alertProvider.deviceBattery = null;
                                        alertProvider.deviceMacAddress = null;
                                        alertProvider.deviceFirmwareVersion = null;
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
                                  width: 340,
                                ),
                                15.height,
                                wiFiNetwork.toText(
                                    fontSize: 14,
                                    fontFamily: sofiaSemiBold,
                                    color: blackDark),
                                10.height,
                                CustomTextField(
                                  controller: controller.wifiNameController,
                                  hintText: hintWifiName,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  radius: 8,
                                  fillColor: whitePrimary,
                                  validator: (value) {
                                    return Validation.wifiNameValidation(value);
                                  },
                                ),
                                15.height,
                                passwordWithStar.toText(
                                    fontSize: 14,
                                    fontFamily: sofiaSemiBold,
                                    color: blackDark),
                                10.height,
                                CustomTextField(
                                  isPassword: true,
                                  obscureText: controller.isVisible,
                                  isVisible: !controller.isVisible,
                                  controller: controller.wifiPasswordController,
                                  hintText: hintPassword,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  radius: 8,
                                  fillColor: whitePrimary,
                                  onEyeTap: () {
                                    controller.passwordVisibility();
                                  },
                                  validator: (value) {
                                    return Validation.wifiPasswordValidation(value);
                                  },
                                ),
                                170.height,
                                isWifiConnecting ? const Center(child: CircularProgressIndicator(),) :  CustomButton(
                                    buttonName: "Next",
                                    onPressed: () async {
                                      if(formKey.currentState!.validate()) {
                                        bool isSuccess = false;
                                        try{
                                          setState(() {
                                            isWifiConnecting = true;
                                          });
                                          final connectedWifiName = await WiFiForIoTPlugin.getSSID();
                                          if(connectedWifiName == controller.wifiNameController.text) {
                                            print('Mobile connected with same ssid');
                                            bool value = await WiFiForIoTPlugin.disconnect();
                                            if(value) {
                                              print('Disconnected Successfully');
                                            }

                                            if(Platform.isIOS) {
                                              ///wifi_connector work for ios
                                              isSuccess = await WifiConnector.connectToWifi(ssid: controller.wifiNameController.text, password: controller.wifiPasswordController.text);
                                            }
                                            else {
                                              ///wifi_iot work for android
                                              isSuccess = await WiFiForIoTPlugin.connect(
                                                controller.wifiNameController.text,
                                                password: controller.wifiPasswordController.text,
                                                joinOnce: true,
                                                security: NetworkSecurity.WPA,
                                              );
                                            }

                                          }
                                          else {

                                            try {

                                              if(Platform.isIOS) {
                                                ///wifi_connector work for ios
                                                isSuccess = await WifiConnector.connectToWifi(ssid: controller.wifiNameController.text, password: controller.wifiPasswordController.text);
                                              }
                                              else {
                                                ///wifi_iot work for android
                                                isSuccess = await WiFiForIoTPlugin.connect(
                                                    controller.wifiNameController.text,
                                                    password: controller.wifiPasswordController.text,
                                                    joinOnce: true,
                                                    security: NetworkSecurity.WPA,
                                                );
                                              }

                                              print("Is Success value is ${isSuccess}");
                                            }
                                            catch(e) {
                                              print(e);
                                            }

                                          }
                                          final connectWifiName = await WiFiForIoTPlugin.getSSID();
                                          setState(() {
                                            isWifiConnecting = false;
                                          });
                                          print('Wifi connected with ${connectWifiName}');
                                          if(Platform.isAndroid) {
                                            if(isSuccess) {
                                              print('Wifi connected Successfully');
                                              alertProvider.sendData(context, 'ssid', alertProvider.deviceID!);
                                              alertProvider.sendData(context, controller.wifiNameController.text, alertProvider.deviceID!);
                                              alertProvider.sendData(context, 'password', alertProvider.deviceID!);
                                              alertProvider.sendData(context, controller.wifiPasswordController.text, alertProvider.deviceID!);
                                              Navigator.pushNamed(context, RouterHelper.connectingScreen);
                                              WiFiForIoTPlugin.disconnect();
                                            }
                                            else {
                                              print('Wrong Wifi Credentials');
                                              // showToast(message: 'Wrong wifi Credentials');
                                              setState(() {
                                                isWifiConnecting = false;
                                              });
                                              // Navigator.pop(context);
                                            }
                                          }
                                          else {
                                            if(connectWifiName == controller.wifiNameController.text) {
                                              print("Wifi Name ${controller.wifiNameController.text}");
                                              print("Wifi Password ${controller.wifiPasswordController.text}");
                                              await alertProvider.sendDataOnIOS(context, controller.wifiNameController.text, controller.wifiPasswordController.text);
                                              WiFiForIoTPlugin.disconnect();
                                              alertProvider.isDeviceConnectedValue = false;
                                              Navigator.pushNamed(context, RouterHelper.connectingScreen);
                                            }

                                          }

                                        } catch(e) {
                                          setState(() {
                                            isWifiConnecting = true;
                                          });
                                          setState(() {
                                            status = false;
                                          });
                                          print(e);
                                        }
                                      }

                                    }).center
                              ],
                            ).paddingSymmetric(horizontal: 25.w),
                          )),
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
