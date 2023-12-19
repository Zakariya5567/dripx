import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dripx/provider/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/data/model/authentication/auth_model.dart';
import 'package:dripx/main.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/dimension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/app_keys.dart';
import '../../../utils/images.dart';
import '../home_screen/components/update_app_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? appVersionNumber = '';

  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    getVersionNumberOfApp();
    checkInternetConnection();
    super.initState();
    routes();
  }

  checkInternetConnection() {
    final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    _initConnectivity();
    authProvider.connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult? result;
    try {
      result = await _connectivity.checkConnectivity();
    } on Exception catch (e) {
      print(e.toString());
    }
    _updateConnectionStatus(result!);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    switch (result) {
      case ConnectivityResult.wifi:
        authProvider.connectionStatus = 'Connected to WiFi';
        break;
      case ConnectivityResult.mobile:
        authProvider.connectionStatus = 'Connected to Mobile Data';
        break;
      case ConnectivityResult.none:
        authProvider.connectionStatus = 'No Internet Connection';
        break;
      default:
        authProvider.connectionStatus = 'Unknown';
        break;
    }
  }

  getVersionNumberOfApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersionNumber = packageInfo.version;
    setState(() {});
  }

  Timer? timer;

  void routes() async {
    Timer(const Duration(seconds: 3), () async {
      await getUser();
    });
  }

  getUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if(Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      authProvider.isIpad = iosInfo.model.toLowerCase().contains('ipad');
    }
    var value = await LocalDb.getUser();
    var productSelectionValue = await LocalDb.getProductSelection();
    authProvider.isShowCouponContainer = await LocalDb.getShowCouponContainerValue();
    var userCompleteProfileValue = await LocalDb.getUserCompleteProfileValue();
    if(userCompleteProfileValue) {
      authProvider.authModel = AuthModel.fromJson(value);
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.countryCode =  authProvider.authModel.data!.countryCode!;
      if(!profileProvider.countryCode.contains('+')) {
        profileProvider.countryCode = "+${profileProvider.countryCode}";
      }
      authProvider.goToProductScreen = true;
      Navigator.of(context).pushReplacementNamed(RouterHelper.profileScreen, arguments: true);
    }
    else {
      if(value != null) {
        authProvider.authModel = AuthModel.fromJson(value);
        authProvider.getUserProfile(context);
        if(productSelectionValue!) {
          Navigator.of(context).pushReplacementNamed(RouterHelper.homeScreen);
        } else {
          Navigator.of(context).pushReplacementNamed(RouterHelper.productScreen);
        }
      }
      else{
        Navigator.of(context).pushReplacementNamed(RouterHelper.signInScreen);
      }
    }
    authProvider.appVersion = await getAppVersion();
    print('App Version: ${authProvider.appVersion}');
    checkVersions();
  }

  checkVersions() async {
    var authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    await authProvider.getVersions(AppKeys.mainNavigatorKey.currentState!.context);
    if(Platform.isAndroid) {
      if(authProvider.androidAppVersion!= '') {
        print(authProvider.androidAppVersion);
        if(authProvider.appVersion!=authProvider.androidAppVersion) {
          updateAppDialog(context: AppKeys.mainNavigatorKey.currentState!.context);
        }
      }
    } else if(Platform.isIOS) {
      if(authProvider.iosAppVersion != '') {
        print(authProvider.iosAppVersion);
        if(authProvider.appVersion!=authProvider.iosAppVersion) {
          updateAppDialog(context: AppKeys.mainNavigatorKey.currentState!.context);
        }
      }
    }

  }

  Future<String> getAppVersion() async {
    if (kIsWeb) {
      return 'Not applicable';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (defaultTargetPlatform == TargetPlatform.android) {
      print("Current version: ${packageInfo.version}");
      return "${packageInfo.version}";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final platform = const MethodChannel('samples.flutter.dev/app_version');
      try {
        return await platform.invokeMethod('getAppVersion');
      } on PlatformException catch (e) {
        return 'Error: ${e.message}';
      }
    }

    return 'Not applicable';
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerySize(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: blueStatusBar(),
      child: Scaffold(
          body: Container(
            height: 844.h,
            width: 390.w,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(Images.splashImage))),
            child: Column(
              children: [
                Spacer(),
                Center(
                  child: Image.asset(
                    Images.logoWithNameImage,
                    height: 195.h,
                    width: 120.w,
                  ),
                ),
                Spacer(),
                // "V.1.0.1".toText(color: whitePrimary, fontSize: 16, fontWeight: FontWeight.w500),
                "V.${appVersionNumber}".toText(color: whitePrimary, fontSize: 16, fontWeight: FontWeight.w500),
                12.height,
              ],
            ),
          )
      ),
    );
  }
}