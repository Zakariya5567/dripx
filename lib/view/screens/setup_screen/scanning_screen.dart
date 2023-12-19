import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
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

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({Key? key}) : super(key: key);

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnimationController? animationController;
  bool bluetoothDisable = false;

  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> discoveredDevices = [];

  StreamSubscription? _subscription;
  StreamSubscription<BleStatus>? bluetoothStatus;

  bool enableConnectButton = false;
  bool locationPermissionDenied = false;
  bool bluetoothPermissionDenied = false;
  bool isScanning = false;

  bool isScanAgain = true;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    getPermission();
    alertProvider.deviceBattery = null;
    alertProvider.deviceMacAddress = null;
    alertProvider.deviceFirmwareVersion = null;
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: const Duration(seconds: 5),
    )..repeat();
    // scanNearbyDevice();
    bluetoothStatus = flutterReactiveBle.statusStream.listen((event) {

      switch (event) {
      // Connected
        case BleStatus.ready:
          {
            print("Bluetooth mode is on");
            setState(() {
              enableConnectButton = true;
              bluetoothDisable = false;
              bluetoothPermissionDenied = false;
              locationPermissionDenied = false;
            });
            if(isScanAgain) {
              scanNearbyDevice();
              isScanAgain = false;
            }

            break;
          }
        case BleStatus.unauthorized:
          {
            print("Bluetooth mode is un authorized");
            setState(() {
              bluetoothDisable = true;
              if(Platform.isAndroid && double.parse(authProvider.androidVersion!) < 12) {
                bluetoothPermissionDenied = false;
              }else {
                bluetoothPermissionDenied = true;
              }

            });
            break;
          }
        case BleStatus.poweredOff:
          {
            print("Bluetooth mode is un powered off");
            setState(() {
              bluetoothDisable = true;
            });

            break;
          }
        default:
      }
    });

    // scanNearbyDevice();
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

  scanNearbyDevice() async {
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
        if(enableConnectButton) {
          _subscription = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency, ).listen((device) {
            setState(() {
              isScanning = true;
              final knownDeviceIndex = discoveredDevices.indexWhere((d) => d.id == device.id);
              if (knownDeviceIndex >= 0) {
                print("device ${device.id}");
                discoveredDevices[knownDeviceIndex] = device;
              } else {
                print("device ${device.id}");
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
        print('Start scanning devices');
        if(enableConnectButton) {
          _subscription = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency, ).listen((device) {
            setState(() {
              isScanning = true;
              final knownDeviceIndex = discoveredDevices.indexWhere((d) => d.id == device.id);
              if (knownDeviceIndex >= 0) {
                print("device ${device.id}");
                discoveredDevices[knownDeviceIndex] = device;
              } else {
                print("device ${device.id}");
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
  }

  stopScanning() {
    _subscription?.cancel();
    // animationController!.stop();
  }

  startScan() {
    scanNearbyDevice();
  }

  @override
  void dispose() {
    if(isScanning) {
      isScanning = false;
      stopScanning();
    }
    animationController!.dispose();
    bluetoothStatus!.cancel();
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {Navigator.pop(context);},
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: blackPrimary,
                                    size: authProvider.isIpad ? 15.w : 22.w,
                                  ),
                                ),
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
                                      fontSize: authProvider.isIpad ? 26 : 20,
                                      fontFamily: sofiaRegular,
                                      color: blackDark)
                                  .center,

                              10.height,

                              Expanded(
                                child: bluetoothPermissionDenied
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Platform.isIOS
                                            ? "Please enable bluetooth permission and connect to devices".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, overflow: TextOverflow.visible)
                                            : "Please enable nearby devices permission and connect to devices".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, overflow: TextOverflow.visible),
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
                                          "Please enable location permission.".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, overflow: TextOverflow.visible),
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
                                              "Please turn on bluetooth and scan again to connect to devices".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, overflow: TextOverflow.visible).center,
                                              10.height,
                                              CustomButton(buttonName: 'Settings', onPressed: () async {
                                                if(Platform.isIOS) {
                                                  final url = 'App-Prefs:root=Bluetooth';

                                                  if (await canLaunch(url)) {
                                                    await launch(url);
                                                  }
                                                } else {
                                                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                                                }

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
                                              "No device found.".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, overflow: TextOverflow.visible),
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
                                        : ListView(
                                          padding: EdgeInsets.zero,
                                          children: discoveredDevices
                                            .map((device) => device.name=='' ? Container() : ListTile(
                                              title: device.name.toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 16, maxLine: 2, fontWeight: FontWeight.w500),
                                              subtitle: "${device.id} \n ".toText(color: blackPrimary, fontSize: authProvider.isIpad ? 22 : 14, maxLine: 1,),
                                              leading: Icon(Icons.bluetooth, color: bluePrimary, size: authProvider.isIpad ? 18.w : 28.w,),
                                              trailing: InkWell(
                                                onTap: () async {
                                                  if(enableConnectButton) {
                                                    stopScanning();

                                                    await controller.connectToDevice(device, context);
                                                    // controller.sendData(context, "device_info", device.id);
                                                    Navigator.pushReplacementNamed(context, RouterHelper.deviceFoundScreen);
                                                  }
                                                },
                                                splashColor: whitePrimary,
                                                child: Ink(
                                                  color: enableConnectButton ? bluePrimary : greyPrimary,
                                                  child: Container(
                                                    width: 80.w,
                                                    height: 35.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),

                                                    ),
                                                    child: "Connect".toText(color: whitePrimary, fontSize: authProvider.isIpad ? 20 : 14).center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                        ),
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
                                  isScanAgain = true;
                                  startScan();
                                },
                                width: 100.w,
                              ),
                              authProvider.isIpad ? 15.height : 15.height,
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