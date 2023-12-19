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
import '../../../utils/string.dart';

import '../../../provider/setup_provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';

class DeviceDescriptionScreen extends StatefulWidget {
  const DeviceDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<DeviceDescriptionScreen> createState() =>
      _DeviceDescriptionScreenState();
}

class _DeviceDescriptionScreenState extends State<DeviceDescriptionScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<SetupProvider>(builder: (context, controller, child) {
          return SizedBox(
            height: 844.h,
            width: 390.w,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Image.asset(
                              Images.deviceImageNew,
                              height: 250.h,
                              width: 340,
                            ),
                            60.height,
                            bringDripXDevice.toText(
                                color: blackPrimary,
                                fontSize:  authProvider.isIpad ? 26 : 20,
                                fontFamily: sofiaSemiBold),
                            15.height,
                            bringDescription.toText(
                                textAlign: TextAlign.center,
                                maxLine: 10,
                                color: blackLight,
                                fontSize: authProvider.isIpad ? 22 : 16,
                                fontFamily: sofiaLight),
                            200.height,
                            CustomButton(
                                buttonName: btnContinue,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouterHelper.scanDeviceScreen);
                                }).center,
                          ],
                        ).paddingSymmetric(horizontal: 25.w))
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
