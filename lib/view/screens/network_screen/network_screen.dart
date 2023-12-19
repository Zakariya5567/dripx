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

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({Key? key}) : super(key: key);

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isScan = false;
  List<WifiNetwork?>? htResultNetwork = [];
  // StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool locationEnabledValue = false;
  bool nearbyWifiDevicesPermission = false;
  bool locationPermissionGranted = false;

  @override
  void initState() {
    checkLocationPermission();
    super.initState();
  }

  @override
  void dispose() {
    // subscription!.cancel();
    super.dispose();
  }

  checkLocationPermission() async {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      setState(() {
        locationPermissionGranted = false;
        homeProvider.preciseLocation = false;
      });
      permission = await Geolocator.requestPermission();
      if(permission!= LocationPermission.deniedForever) {
        checkLocationPermission();
      }

    }
    else if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      setState(() {
        locationPermissionGranted = true;
      });
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      if(double.parse(authProvider.androidVersion!) > 11) {
        final accuracyStatus = await Geolocator.getLocationAccuracy();
        switch(accuracyStatus) {
          case LocationAccuracyStatus.reduced:
            setState(() {
              homeProvider.preciseLocation = false;
            });
            break;
          case LocationAccuracyStatus.precise:
            setState(() {
              homeProvider.preciseLocation = true;
            });
            loadWifiList();
            break;
          case LocationAccuracyStatus.unknown:
            setState(() {
              homeProvider.preciseLocation = false;
            });
            break;
        }
      }
      else {
        setState(() {
          homeProvider.preciseLocation = true;
        });
        loadWifiList();
      }

    }

  }

  loadWifiList() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled) {
      if (true) {
        permissionGranted = false;
        setState(() {
          isScan = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          var authProvider = Provider.of<AuthProvider>(context, listen: false);
          if(double.parse(authProvider.androidVersion!) >12) {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.nearbyWifiDevices,
            ].request();

            if (statuses[Permission.nearbyWifiDevices]!.isGranted) {
              setState(() {
                nearbyWifiDevicesPermission = true;
              });
              try {
                htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
                print(htResultNetwork);
                setState(() {
                  isScan = false;
                });
              }
              on PlatformException {
                htResultNetwork = <WifiNetwork>[];
                setState(() {
                  isScan = false;
                });
              }
            }
            else {
              setState(() {
                nearbyWifiDevicesPermission = false;
              });
            }
          }
          else {
            setState(() {
              nearbyWifiDevicesPermission = true;
            });
            try {
              htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
              print(htResultNetwork);
              setState(() {
                isScan = false;
              });
            }
            on PlatformException {
              htResultNetwork = <WifiNetwork>[];
              setState(() {
                isScan = false;
              });
            }
          }
        });
      }
      setState(() {
        locationEnabledValue = true;
      });
    }

    else {
      setState(() {
        locationEnabledValue = false;
      });
    }

  }
  bool permissionGranted = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
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
                                child: !locationPermissionGranted
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        "Please enable location permission in app setting".toText(fontSize: 16, overflow: TextOverflow.visible),
                                        15.height,
                                        CustomButton(buttonName: "Open setting", onPressed: () {Geolocator.openAppSettings();}),
                                        10.height,
                                        CustomButton(buttonName: "Add wifi manually", onPressed: () {
                                          setupProvider.wifiPasswordController.clear();
                                          setupProvider.wifiNameController.clear();
                                          Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                                        }),
                                        10.height,
                                        CustomButton(buttonName: "Reload wifi", onPressed: () {checkLocationPermission();}),
                                      ],
                                    ),
                                  )
                                  : !homeProvider.preciseLocation
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          "Please enable${double.parse(authProvider.androidVersion!) > 11 ? " precise" : ''} location permission in app setting".toText(fontSize: 16, overflow: TextOverflow.visible),
                                          15.height,
                                          CustomButton(buttonName: "Open setting", onPressed: () {Geolocator.openAppSettings();}),
                                          10.height,
                                          CustomButton(buttonName: "Add wifi manually", onPressed: () {
                                            setupProvider.wifiPasswordController.clear();
                                            setupProvider.wifiNameController.clear();
                                            Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                                          }),
                                          10.height,
                                          CustomButton(buttonName: "Reload wifi", onPressed: () {checkLocationPermission();}),
                                        ],
                                      ),
                                    )
                                    : !locationEnabledValue
                                      ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            "Please enable location in settings".toText(fontSize: 16, overflow: TextOverflow.visible),
                                            15.height,
                                            CustomButton(buttonName: "Open setting", onPressed: () {Geolocator.openLocationSettings();}),

                                            10.height,
                                            CustomButton(buttonName: "Add wifi manually", onPressed: () {
                                              setupProvider.wifiPasswordController.clear();
                                              setupProvider.wifiNameController.clear();
                                              Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                                            }),
                                            10.height,
                                            CustomButton(buttonName: "Reload wifi", onPressed: () {checkLocationPermission();}),

                                          ],
                                        ),
                                      )
                                      : !nearbyWifiDevicesPermission
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                "Please enable nearby devices permission in settings".toText(fontSize: 16, overflow: TextOverflow.visible),
                                                15.height,
                                                CustomButton(buttonName: "Open setting", onPressed: () {Geolocator.openAppSettings();}),

                                                10.height,
                                                CustomButton(buttonName: "Add wifi manually", onPressed: () {
                                                  setupProvider.wifiPasswordController.clear();
                                                  setupProvider.wifiNameController.clear();
                                                  Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                                                }),
                                                10.height,
                                                CustomButton(buttonName: "Reload wifi", onPressed: () {checkLocationPermission();}),

                                              ],
                                            ),
                                          )
                                        : htResultNetwork!.length == 0
                                          ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                "No wifi available".toText(fontSize: 16),

                                                10.height,
                                                CustomButton(buttonName: "Add wifi manually", onPressed: () {
                                                  setupProvider.wifiPasswordController.clear();
                                                  setupProvider.wifiNameController.clear();
                                                  Navigator.pushNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                                                }),
                                                10.height,
                                                CustomButton(buttonName: "Reload wifi", onPressed: () {checkLocationPermission();}),
                                              ],
                                            ),
                                          )
                                          : RefreshIndicator(
                                            onRefresh: () {
                                              return loadWifiList();
                                            },
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                physics: const AlwaysScrollableScrollPhysics(),
                                                itemCount: htResultNetwork!.length,
                                                itemBuilder: (context, index) {
                                                  return htResultNetwork![index]!.ssid == ''
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
                                                        htResultNetwork![index]!.ssid!.toText(
                                                            fontSize: 18,
                                                            color: blackDark,
                                                            fontFamily: sofiaRegular,
                                                            overflow: TextOverflow.ellipsis
                                                        ),
                                                      ],
                                                    ),
                                                  ).onPress(() {
                                                    setupProvider.wifiNameController.text = htResultNetwork![index]!.ssid!;
                                                    setupProvider.wifiPasswordController.clear();
                                                    Navigator.pushNamed(context, RouterHelper.networkFormScreen, arguments: htResultNetwork![index]);
                                                  });
                                                }
                                            ),
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
