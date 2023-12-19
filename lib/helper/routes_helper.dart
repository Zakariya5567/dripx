import 'package:dripx/view/screens/Authentication_screen/forget_password_screen.dart';
import 'package:dripx/view/screens/Authentication_screen/new_password_screen.dart';
import 'package:dripx/view/screens/Authentication_screen/otp_verification_screen.dart';
import 'package:dripx/view/screens/Authentication_screen/sign_up_otp_verification_screen.dart';
import 'package:dripx/view/screens/alert_screen/alert_screen.dart';
import 'package:dripx/view/screens/data_collection_screen/data_collection_screen.dart';
import 'package:dripx/view/screens/device_recalibration/recalibration_calibrated_Screen.dart';
import 'package:dripx/view/screens/device_recalibration/recalibration_device_screen.dart';
import 'package:dripx/view/screens/device_recalibration/recalibration_calibrating_screen.dart';
import 'package:dripx/view/screens/device_recalibration/recalibration_device_found_screen.dart';
import 'package:dripx/view/screens/device_recalibration/recalibration_scanning_screen.dart';
import 'package:dripx/view/screens/home_screen/add_venue_screen.dart';
import 'package:dripx/view/screens/home_screen/edit_device_screen.dart';
import 'package:dripx/view/screens/home_screen/edit_venue_screen.dart';
import 'package:dripx/view/screens/home_screen/home_screen.dart';
import 'package:dripx/view/screens/home_screen/your_devices_screen.dart';
import 'package:dripx/view/screens/network_screen/calibrated_screen.dart';
import 'package:dripx/view/screens/network_screen/calibrating_screen.dart';
import 'package:dripx/view/screens/network_screen/connected_screen.dart';
import 'package:dripx/view/screens/network_screen/device_entry_screen.dart';
import 'package:dripx/view/screens/network_screen/finishing_up_screen.dart';
import 'package:dripx/view/screens/network_screen/network_form_screen.dart';
import 'package:dripx/view/screens/network_screen/network_screen.dart';
import 'package:dripx/view/screens/network_screen/safely_placed_screen.dart';
import 'package:dripx/view/screens/notification_screen/notification_screen.dart';
import 'package:dripx/view/screens/products_screen/products_screen.dart';
import 'package:dripx/view/screens/profile_screen/create_new_password_screen.dart';
import 'package:dripx/view/screens/profile_screen/profile_screen.dart';
import 'package:dripx/view/screens/setting_screen/setting_screen.dart';
import 'package:dripx/view/screens/setup_screen/device_description_screen.dart';
import 'package:dripx/view/screens/setup_screen/device_found_screen.dart';
import 'package:dripx/view/screens/setup_screen/scan_device_screen.dart';
import 'package:dripx/view/screens/setup_screen/scanning_screen.dart';
import 'package:dripx/view/screens/setup_screen/setup_form_screen.dart';
import 'package:dripx/view/screens/setup_screen/setup_goodToGo_screen.dart';
import 'package:dripx/view/screens/setup_screen/setup_location_screen.dart';
import 'package:dripx/view/screens/setup_screen/setup_screen.dart';
import 'package:dripx/view/screens/setup_screen/venue_listing_screen.dart';
import 'package:dripx/view/screens/wifi_switching_screen/wifi_switching_network_form_screen.dart';
import 'package:dripx/view/screens/wifi_switching_screen/wifi_switching_network_screen.dart';
import 'package:dripx/view/screens/wifi_switching_screen/wifi_switching_scanning_screen.dart';
import 'package:flutter/material.dart';

import '../provider/data_collection_provider.dart';
import '../view/screens/Authentication_screen/signin_screen.dart';
import '../view/screens/Authentication_screen/signup_screen.dart';
import '../view/screens/alert_screen/alert_detail_screen.dart';
import '../view/screens/connection_screen/connection_error_screen.dart';
import '../view/screens/home_screen/update_firmware_screen.dart';
import '../view/screens/home_screen/updated_firmware_screen.dart';
import '../view/screens/network_screen/calibrate_device_screen.dart';
import '../view/screens/network_screen/connecting_screen.dart';
import '../view/screens/network_screen/finishined_screen.dart';
import '../view/screens/network_screen/ios_network_screen.dart';
import '../view/screens/setting_screen/privacy_policy_screen.dart';
import '../view/screens/setting_screen/term_and_condition_screen.dart';
import '../view/screens/setup_screen/add_device_screen.dart';
import '../view/screens/splash_screen/splash_screen.dart';
import '../view/screens/wifi_switching_screen/wifi_switiching_ios_network_screen.dart';

class RouterHelper {
  static const initial = "/";
  static const signUpScreen = "/signUpScreen";
  static const signInScreen = "/signInScreen";
  static const forgotPasswordScreen = "/forgotPasswordScreen";
  static const newPasswordScreen = "/newPasswordScreen";
  static const optVerificationScreen = "/optVerificationScreen";
  static const homeScreen = "/homeScreen";
  static const yourDevicesScreen = "/yourDevicesScreen";
  static const editDeviceScreen = "/editDeviceScreen";
  static const alertScreen = "/alertScreen";
  static const alertDetailScreen = "/alertDetailScreen";
  static const settingScreen = "/settingScreen";
  static const profileScreen = "/profileScreen";
  static const createNewPasswordScreen = "/createNewPasswordScreen";
  static const signUpOtpVerificationScreen = "/SignUpOtpVerificationScreen";

  static const setupScreen = "/setupScreen";
  static const setupFormScreen = "/setupFormScreen";
  static const setupLocationScreen = "/setupLocationScreen";
  static const setupGoodToGoScreen = "/setupGoodToGoScreen";
  static const addDeviceScreen = "/addDeviceScreen";
  static const deviceDescriptionScreen = "/deviceDescriptionScreen";
  static const scanDeviceScreen = "/scanDeviceScreen";
  static const scanningScreen = "/scanningScreen";
  static const deviceFoundScreen = "/deviceFoundScreen";
  static const venuesListingScreen = "/venuesListingScreen";
  static const addVenueScreen = "/addVenueScreen";
  static const editVenueScreen = "/editVenueScreen";

  static const networkScreen = "/networkScreen";
  static const networkFormScreen = "/networkFormScreen";
  static const connectingScreen = "/connectingScreen";
  static const connectedScreen = "/connectedScreen";
  static const deviceEntryScreen = "/deviceEntryScreen";
  static const calibrateDeviceScreen = "/calibrateDeviceScreen";
  static const calibratingScreen = "/calibratingScreen";
  static const calibratedScreen = "/calibratedScreen";
  static const safelyPlacedScreen = "/safelyPlacedScreen";
  static const finishingUpScreen = "/finishingUpScreen";
  static const finishedScreen = "/finishedScreen";
  static const notificationScreen = "/notificationScreen";

  static const recalibrationScanningScreen = "/recalibrationScanningScreen";
  static const recalibrationDeviceFoundScreen = "/recalibrationDeviceFoundScreen";
  static const recalibrateCalibrateDeviceScreen = "/recalibrateCalibrateDeviceScreen";
  static const recalibrationCalibratingScreen = "/recalibrationCalibratingScreen";
  static const recalibratedCalibratedScreen = "/recalibratedCalibratedScreen";

  static const wifiSwitchingScanningScreen = "/wifiSwitchingScanningScreen";
  static const wifiSwitchingNetworkScreen = "/wifiSwitchingNetworkScreen";
  static const wifiSwitchingNetworkFormScreen = "/wifiSwitchingNetworkFormScreen";
  static const termAndConditionScreen = "/termAndConditionScreen";
  static const privacyPolicyScreen = "/privacyPolicyScreen";
  static const updateFirmwareScreen = "/updateFirmwareScreen";
  static const updatedFirmwareScreen = "/updatedFirmwareScreen";
  static const iosNetworkScreen = "/iosNetworkScreen";
  static const dataCollectionScreen = "/dataCollectionScreen";
  static const wifiSwitchingIosNetworkScreen = "/wifiSwitchingIosNetworkScreen";

  static const noConnectionScreen = "/noConnectionScreen";
  static const productScreen = "/productsScreen";

  static Map<String, Widget Function(BuildContext context)> routes = {
    initial: (context) => const SplashScreen(),
    noConnectionScreen: (context) => const NoConnection(),
    signUpScreen: (context) => const SignUpScreen(),
    signInScreen: (context) => const SignInScreen(),
    forgotPasswordScreen: (context) => const ForgetPasswordScreen(),
    optVerificationScreen: (context) => const OtpVerificationScreen(),
    newPasswordScreen: (context) => const NewPasswordScreen(),
    homeScreen: (context) => const HomeScreen(),
    yourDevicesScreen: (context) => const YourDevicesScreen(),
    editDeviceScreen: (context) => const EditDeviceScreen(),
    settingScreen: (context) => const SettingScreen(),
    alertScreen: (context) => const AlertScreen(),
    alertDetailScreen: (context) => const AlertDetailScreen(),
    profileScreen: (context) => const ProfileScreen(),
    signUpOtpVerificationScreen: (context) => const SignUpOtpVerificationScreen(),
    createNewPasswordScreen: (context) => const CreateNewPasswordScreen(),
    setupScreen: (context) => const SetupScreen(),
    setupFormScreen: (context) => const SetupFormScreen(),
    setupLocationScreen: (context) => const SetupLocationScreen(),
    setupGoodToGoScreen: (context) => const SetupGoodToGoScreen(),
    addDeviceScreen: (context) => const AddDeviceScreen(),
    deviceDescriptionScreen: (context) => const DeviceDescriptionScreen(),
    scanDeviceScreen: (context) => const ScanDeviceScreen(),
    scanningScreen: (context) => const ScanningScreen(),
    deviceFoundScreen: (context) => const DeviceFoundScreen(),
    networkScreen: (context) => const NetworkScreen(),
    wifiSwitchingIosNetworkScreen: (context) => const WifiSwitchingIOSNetworkScreen(),
    iosNetworkScreen: (context) => const IOSNetworkScreen(),
    networkFormScreen: (context) => const NetworkFormScreen(),
    connectingScreen: (context) => const ConnectingScreen(),
    connectedScreen: (context) => const ConnectedScreen(),
    deviceEntryScreen: (context) => const DeviceEntryScreen(),
    calibrateDeviceScreen: (context) => const CalibrateDeviceScreen(),
    calibratingScreen: (context) => const CalibratingScreen(),
    calibratedScreen: (context) => const CalibratedScreen(),
    safelyPlacedScreen: (context) => const SafelyPlacedScreen(),
    finishingUpScreen: (context) => const FinishingUpScreen(),
    finishedScreen: (context) => const FinishedScreen(),
    notificationScreen: (context) => const NotificationScreen(),
    recalibrationScanningScreen: (context) => const RecalibrationScanningScreen(),
    recalibrateCalibrateDeviceScreen: (context) => const RecalibrateDeviceScreen(),
    recalibrationDeviceFoundScreen: (context) => const RecalibrateDeviceFoundScreen(),
    recalibrationCalibratingScreen: (context) => const RecalibrationCalibratingScreen(),
    recalibratedCalibratedScreen: (context) => const RecalibratedCalibratedScreen(),
    wifiSwitchingScanningScreen: (context) => const WifiSwitchingScanningScreen(),
    wifiSwitchingNetworkScreen: (context) => const WifiSwitchingNetworkScreen(),
    wifiSwitchingNetworkFormScreen: (context) => const WifiSwitchingNetworkFormScreen(),
    venuesListingScreen: (context) => const VenuesListingScreen(),
    addVenueScreen: (context) => const AddVenueScreen(),
    editVenueScreen: (context) => const EditVenueScreen(),
    termAndConditionScreen: (context) => const TermAndConditionScreen(),
    privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
    updateFirmwareScreen: (context) => const UpdateFirmwareScreen(),
    updatedFirmwareScreen: (context) => const UpdatedFirmwareScreen(),
    dataCollectionScreen: (context) => const DataCollectionScreen(),
    productScreen: (context) => const ProductScreen(),
  };
}
