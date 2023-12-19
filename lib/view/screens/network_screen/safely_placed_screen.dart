import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/home_screen/components/abort_device_dialog.dart';
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
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../provider/setup_provider.dart';
import '../../../utils/string.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/extention/border_extension.dart';

class SafelyPlacedScreen extends StatefulWidget {
  const SafelyPlacedScreen({Key? key}) : super(key: key);

  @override
  State<SafelyPlacedScreen> createState() => _SafelyPlacedScreenState();
}

class _SafelyPlacedScreenState extends State<SafelyPlacedScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<SetupProvider>(builder: (context, controller, child) {
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Container()
                                  // IconButton(
                                  //   onPressed: () {
                                  //     alertProvider.deviceBattery = null;
                                  //     alertProvider.deviceMacAddress = null;
                                  //     alertProvider.deviceFirmwareVersion = null;
                                  //     abortDeviceDialoge(context: context);
                                  //   },
                                  //   icon: Icon(
                                  //     Icons.clear,
                                  //     color: blackPrimary,
                                  //     size: 22.w,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Image.asset(
                                Images.deviceImageNew,
                                height: 250.h,
                                width: 340,
                              ),
                              60.height,
                              safelyPlaced.toText(
                                  color: blackPrimary,
                                  fontSize: 20,
                                  fontFamily: sofiaSemiBold),
                              15.height,
                              safelyDescription.toText(
                                  textAlign: TextAlign.center,
                                  maxLine: 4,
                                  color: blackLight,
                                  fontSize: 16,
                                  fontFamily: sofiaLight),
                              180.height,
                              CustomButton(
                                  buttonName: btnContinue,
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        RouterHelper.finishingUpScreen);
                                  }).center,
                              10.height,
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
