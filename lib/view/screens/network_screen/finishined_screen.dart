import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/setup_screen/component/enable_alert_dialoge.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/circle_with_icon.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({Key? key}) : super(key: key);

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: WillPopScope(
        onWillPop: () {return Future.value(false);},
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
                                150.height,
                                CircleWithIcon(
                                  isIcon: false,
                                  image: Images.iconDone,
                                ),
                                180.height,
                                deviceProcessCompleted.toText(color: blackPrimary, fontSize: 16, overflow: TextOverflow.visible, textAlign: TextAlign.center).center,
                                180.height,
                                CustomButton(
                                  buttonColor: greenPrimary,
                                  buttonTextColor: whitePrimary,
                                  borderColor: greenPrimary,
                                  buttonName: btnFinish,
                                  onPressed: () {
                                    enableAlertPrompt(
                                      context: context,
                                      onNoClick: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
                                      },
                                      onYesClick: () {
                                        homeProvider.updateDeviceAlertStatus(context, "1", homeProvider.bluetoothDeviceMacAddress!);
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
                                      },
                                    );
                                    // Navigator.pop(context);
                                  }
                                )
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
      ),
    );
  }
}
