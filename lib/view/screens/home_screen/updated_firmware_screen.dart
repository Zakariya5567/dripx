
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/colors.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/style.dart';
import '../../widgets/blue_gradient.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/gradient_status_bar.dart';
import '../../widgets/white_gradient.dart';

class UpdatedFirmwareScreen extends StatefulWidget {
  const UpdatedFirmwareScreen({Key? key}) : super(key: key);

  @override
  State<UpdatedFirmwareScreen> createState() => _UpdatedFirmwareScreenState();
}

class _UpdatedFirmwareScreenState extends State<UpdatedFirmwareScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: "Complete"),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                "Latest Version: ".toText(fontSize: 18, isBold: true, color: blackPrimary),
                                authProvider.firmwareVersion!.toText(fontSize: 18, color: blackPrimary),
                              ],
                            ),
                            12.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                "Current Version: ".toText(fontSize: 18, isBold: true, color: blackPrimary),
                                controller.updatedDevice!.firmwareVersion!.toText(fontSize: 18, color: blackPrimary),
                              ],
                            ),
                            12.height,
                            "DripX device has been updated successfully.".toText(
                              fontSize: 18,
                              maxLine: 10,
                              fontFamily: sofiaSemiBold,
                              color: blackPrimary
                            ),
                            20.height,
                            CustomButton(
                              buttonName: "Back to Homepage",
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
                              }
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 25.w),
                      )
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
