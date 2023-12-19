import 'package:dripx/provider/data_collection_provider.dart';
import 'package:dripx/provider/notification_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/provider/wifi_switching_provider.dart';
import 'package:provider/provider.dart';

import '../provider/alert_provider.dart';
import '../provider/authentication_provider.dart';
import '../provider/bottom_navigation_provider.dart';
import '../provider/home_provider.dart';
import '../provider/profile_provider.dart';
import '../provider/setting_provider.dart';
import '../provider/setup_provider.dart';

class ProviderHelper {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
    ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
    ChangeNotifierProvider<AlertProvider>(create: (context) => AlertProvider()),
    ChangeNotifierProvider<SettingProvider>(create: (context) => SettingProvider()),
    ChangeNotifierProvider<SetupProvider>(create: (context) => SetupProvider()),
    ChangeNotifierProvider<ProfileProvider>(create: (context) => ProfileProvider()),
    ChangeNotifierProvider<BottomNavigationProvider>(create: (context) => BottomNavigationProvider()),
    ChangeNotifierProvider<NotificationProvider>(create: (context) => NotificationProvider()),
    ChangeNotifierProvider<ReCalibrationProvider>(create: (context) => ReCalibrationProvider()),
    ChangeNotifierProvider<WifiSwitchingProvider>(create: (context) => WifiSwitchingProvider()),
    ChangeNotifierProvider<DataCollectionProvider>(create: (context) => DataCollectionProvider()),

  ];
}
