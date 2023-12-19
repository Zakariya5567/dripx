import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/provider/wifi_switching_provider.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/circle_with_icon.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/wave_animation.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';

class WifiSwitchingScanningScreen extends StatefulWidget {
  const WifiSwitchingScanningScreen({Key? key}) : super(key: key);

  @override
  State<WifiSwitchingScanningScreen> createState() => _WifiSwitchingScanningScreenState();
}

class _WifiSwitchingScanningScreenState extends State<WifiSwitchingScanningScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnimationController? animationController;

  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> discoveredDevices = [];

  StreamSubscription? _subscription;
  StreamSubscription<BleStatus>? bluetoothStatus;

  bool enableConnectButton = false;
  bool isScanAgain = true;
  bool locationPermissionDenied = false;
  bool bluetoothPermissionDenied = false;
  bool bluetoothDisable = false;
  bool isScanning = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: const Duration(seconds: 5),
    )..repeat();
    final wifiSwitchingProvider = Provider.of<WifiSwitchingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    getPermission();
    // scanNearbyDevice(wifiSwitchingProvider);
    bluetoothStatus = flutterReactiveBle.statusStream.listen((event) {
      switch (event) {
      // Connected
        case BleStatus.ready:
          {
            setState(() {
              enableConnectButton = true;
              bluetoothDisable = false;
              locationPermissionDenied = false;
              bluetoothPermissionDenied = false;
            });
            if(isScanAgain) {
              scanNearbyDevice(wifiSwitchingProvider);
              isScanAgain = false;
            }

            break;
          }
        case BleStatus.unauthorized:
          {
            // bluetoothDisable = true;
            if(Platform.isAndroid && double.parse(authProvider.androidVersion!) < 12) {
              bluetoothPermissionDenied = false;
            }else {
              bluetoothPermissionDenied = true;
            }
            break;
          }
        case BleStatus.poweredOff:
          {
            setState(() {
              bluetoothDisable = true;
            });

            break;
          }
        default:
      }
    });

  }

  getPermission() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if(Platform.isAndroid && double.parse(authProvider.androidVersion!)< 12) {
      LocationPermission permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
          setState(() {
            locationPermissionDenied = true;
          });
        }
      }
    }
    else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise
      ].request();
      if(statuses[Permission.bluetooth]!.isDenied && (statuses[Permission.bluetoothScan]!.isPermanentlyDenied || statuses[Permission.bluetoothScan]!.isDenied) && (statuses[Permission.bluetoothConnect]!.isPermanentlyDenied || statuses[Permission.bluetoothConnect]!.isDenied)) {
        print('Not scanning devices');
        setState(() {
          bluetoothPermissionDenied = true;
        });
      }
    }
  }

  startScan(WifiSwitchingProvider controller) {
    scanNearbyDevice(controller);
  }

  scanNearbyDevice(WifiSwitchingProvider wifiSwitchingProvider) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if(Platform.isAndroid && double.parse(authProvider.androidVersion!)< 12) {
      setState(() {
        bluetoothPermissionDenied = false;
      });
      LocationPermission permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
          setState(() {
            locationPermissionDenied = true;
          });
        }

      } else {
        setState(() {
          bluetoothPermissionDenied = false;
        });
        if(enableConnectButton) {
          await wifiSwitchingProvider.wifiSwitchingApi(context, wifiSwitchingProvider.searchingDevice!.macAddress!, "not connected", false);
          _subscription = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency, ).listen((device) {
            setState(() {
              isScanning = true;
              final knownDeviceIndex = discoveredDevices.indexWhere((d) => d.id == device.id);
              if (knownDeviceIndex >= 0) {
                discoveredDevices[knownDeviceIndex] = device;
                var searchingDevice = "DripX_" + wifiSwitchingProvider.searchingDevice!.macAddress!.substring(wifiSwitchingProvider.searchingDevice!.macAddress!.length - 5);
                print(searchingDevice);
                if(device.name == searchingDevice) {
                  wifiSwitchingProvider.connectToDevice(device, context);
                  stopScanning();
                  if(Platform.isIOS) {
                    // goToNextScreen();
                    // wifiSwitchingProvider.sendData('wifi_switching', wifiSwitchingProvider.wifiSwitchingDeviceID!);
                    // Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingNetworkFormScreen);
                    // Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingIosNetworkScreen);
                  }
                  else {
                    Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingNetworkScreen);
                  }
                }
              } else {
                discoveredDevices.add(device);
              }
            });
          }, onError: (e) {
            setState(() {
              discoveredDevices = [];
            });
            // print(e);
          });
        }
      }
    }

    else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise
      ].request();

      if(statuses[Permission.bluetooth]!.isDenied && (statuses[Permission.bluetoothScan]!.isPermanentlyDenied || statuses[Permission.bluetoothScan]!.isDenied) && (statuses[Permission.bluetoothConnect]!.isPermanentlyDenied || statuses[Permission.bluetoothConnect]!.isDenied)) {
        print('Not scanning devices');
        setState(() {
          bluetoothPermissionDenied = true;
        });
      }
      else {
        setState(() {
          bluetoothPermissionDenied = false;
        });
        await wifiSwitchingProvider.wifiSwitchingApi(context, wifiSwitchingProvider.searchingDevice!.macAddress!, "not connected", false);
        _subscription = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency, ).listen((device) {
          setState(() {
            isScanning = true;
            final knownDeviceIndex = discoveredDevices.indexWhere((d) => d.id == device.id);
            if (knownDeviceIndex >= 0) {
              discoveredDevices[knownDeviceIndex] = device;
              var searchingDevice = "DripX_" + wifiSwitchingProvider.searchingDevice!.macAddress!.substring(wifiSwitchingProvider.searchingDevice!.macAddress!.length - 5);
              print(searchingDevice);
              if(device.name == searchingDevice) {
                wifiSwitchingProvider.connectToDevice(device, context);
                stopScanning();
                if(Platform.isIOS) {
                  // goToNextScreen();
                  // Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingIosNetworkScreen);
                  //  wifiSwitchingProvider.sendData('wifi_switching', wifiSwitchingProvider.wifiSwitchingDeviceID!);
                }
                else {
                  Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingNetworkScreen);
                }
              }
            } else {
              discoveredDevices.add(device);
            }
          });
        }, onError: (e) {
          setState(() {
            discoveredDevices = [];
          });
          // print(e);
        });
      }
    }

  }

  int counter = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec, (Timer timer) {
      if (counter == 0) {
        _timer!.cancel();
        Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);

      } else {
        setState(() {
          counter--;
        });
      }
    },
    );
  }

  stopScanning() {
    _subscription!.cancel();
    // animationController!.stop();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    bluetoothStatus!.cancel();
    animationController!.dispose();
    _timer!.cancel();
    if(isScanning) {stopScanning();}
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<WifiSwitchingProvider>(builder: (context, controller, child) {
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {Navigator.pop(context);},
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: blackPrimary,
                                    size: 22.w,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30.h,
                                width: 270.w,
                                decoration: BoxDecoration(
                                    color: redPrimary,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: "Please turn off and then turn on the device".toText(fontSize: 12, color: whitePrimary).center.paddingSymmetric(horizontal: 5.w, vertical: 5.h) ,
                              ),
                              30.height,
                              SizedBox(
                                  height: 155.w,
                                  width: 155.w,
                                  child: Stack(
                                    children: [
                                      CircleWithIcon(
                                        isIcon: true,
                                        icon: Icons.search,
                                      ),
                                      WaveAnimation(
                                        animationController:
                                        animationController,
                                        icon: Icons.search,
                                        isIcon: true,
                                        onTap: () {
                                        },
                                      ).center,
                                    ],
                                  )),

                              10.height,
                              scanning
                                  .toText(
                                  fontSize: 20,
                                  fontFamily: sofiaRegular,
                                  color: blackDark)
                                  .center,

                              10.height,
                              "Process will end after ${counter.toString()} seconds".toText().center,
                              10.height,
                              Expanded(
                                child: bluetoothPermissionDenied
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Platform.isIOS
                                            ? "Please enable bluetooth permission and connect to devices".toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible)
                                            : "Please enable nearby devices permission and connect to devices".toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible),
                                        10.height,
                                        CustomButton(buttonName: 'Open settings', onPressed: () {openAppSettings();})
                                      ],
                                    ),
                                  )
                                  : locationPermissionDenied
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          "Please enable location permission.".toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible),
                                          10.height,
                                          CustomButton(buttonName: 'Open settings', onPressed: () {openAppSettings();})

                                        ],
                                      ),
                                    )
                                    : bluetoothDisable
                                      ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            "Please turn on bluetooth and scan again to connect to devices".toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible).center,
                                            10.height,
                                            CustomButton(buttonName: 'Settings', onPressed: () async {
                                              AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                                            })
                                          ],
                                        ),
                                      )
                                      : discoveredDevices.length == 0
                                        ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // "No device found.".toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible),
                                              10.height,
                                              // CustomButton(
                                              //     buttonName: "Open Setting",
                                              //     width: 120.w,
                                              //     radius: 10,
                                              //     onPressed: () {openAppSettings();},
                                              // )
                                            ],
                                          ),
                                        )
                                        : Container(),
                              ),
                              CustomButton(
                                buttonName: "Scan",
                                borderColor: bluePrimary,
                                buttonColor: bluePrimary,
                                buttonTextColor: whitePrimary,
                                onPressed: () {
                                  if(isScanning) {stopScanning();}
                                  locationPermissionDenied = false;
                                  bluetoothPermissionDenied = false;
                                  setState(() {

                                  });
                                  startScan(controller);
                                },
                                width: 100.w,
                              ),
                              15.height,
                            ],
                          ).paddingSymmetric(horizontal: 20.w)
                      ),


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