import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';
import '../../widgets/custom_button.dart';

class ScanDeviceScreen extends StatefulWidget {
  const ScanDeviceScreen({Key? key}) : super(key: key);

  @override
  State<ScanDeviceScreen> createState() => _ScanDeviceScreenState();
}

class _ScanDeviceScreenState extends State<ScanDeviceScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                      CustomAppBar(title: ""),
                      SizedBox(
                          height: 840.h,
                          width: 390.w,
                          child: Column(
                            children: [
                              150.height,
                              CircleWithIcon(
                                isIcon: true,
                                icon: Icons.search,
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context, RouterHelper.scanningScreen);
                                },
                              ),
                              10.height,
                              scanDripXDevice
                                  .toText(
                                      fontSize: authProvider.isIpad ? 22 : 20,
                                      fontFamily: sofiaRegular,
                                      color: blackDark)
                                  .center,
                              150.height,
                              scanNearBy
                                  .toText(
                                      fontSize: authProvider.isIpad ? 20 : 14,
                                      fontFamily: sofiaLight,
                                      color: greyPrimary)
                                  .center,
                              210.height,
                              CustomButton(
                                  buttonName: btnScan,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RouterHelper.scanningScreen);
                                  }).center
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
}
