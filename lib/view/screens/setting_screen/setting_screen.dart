import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/profile_provider.dart';
import 'package:dripx/provider/setting_provider.dart';
import 'package:dripx/view/screens/home_screen/components/logout_dialoge.dart';
import 'package:dripx/view/screens/setting_screen/components/notification_card.dart';
import 'package:dripx/view/screens/setting_screen/components/setting_card.dart';
import 'package:dripx/view/screens/setting_screen/components/system_check_dialoge.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<SettingProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: setting),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          children: [
                            140.height,
                            SettingCard(title: profile, onTap: () {
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                              profileProvider.countryCode =  authProvider.authModel.data!.countryCode!;
                              if(!profileProvider.countryCode.contains('+')) {
                                profileProvider.countryCode = "+${profileProvider.countryCode}";
                              }
                              Navigator.pushNamed(context, RouterHelper.profileScreen, arguments: false);
                            }),
                            // NotificationCard(controller: controller, title: notifications, onTap: () {Navigator.pushNamed(context, RouterHelper.notificationScreen);}),
                            SettingCard(title: notifications, onTap: () {Navigator.pushNamed(context, RouterHelper.notificationScreen);}),
                            SettingCard(title: faqs, onTap: () {openWebsite('https://dripx.iottechnologies.io/faqs.html');},),
                            SettingCard(title: aboutUs, onTap: () {openWebsite('https://dripx.iottechnologies.io/about-us.html');},),
                            SettingCard(title: systemCheck, onTap: () {controller.getSystemCheckValue(context); systemCheckDialoge(context: context);},),
                            SettingCard(title: logout, onTap: () {logoutDialog(context: context);}),
                          ],
                        ).paddingSymmetric(horizontal: 20.w),
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

  void openWebsite(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}