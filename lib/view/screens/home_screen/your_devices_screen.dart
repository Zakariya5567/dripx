import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/screens/home_screen/components/home_add_device_circle.dart';
import 'package:dripx/view/screens/home_screen/components/your_devices_list.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../../widgets/blue_gradient.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_status_bar.dart';
import '../../widgets/white_gradient.dart';

class YourDevicesScreen extends StatefulWidget {
  const YourDevicesScreen({Key? key}) : super(key: key);

  @override
  State<YourDevicesScreen> createState() => _YourDevicesScreenState();
}

class _YourDevicesScreenState extends State<YourDevicesScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<HomeProvider>(context, listen: false);
      controller.pageNumber = 1;
      controller.getDevices(context, '', controller.pageNumber.toString(), venueID: controller.searchDeviceByVenueID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context)!.settings.arguments as String;
    final authProvider = Provider.of<AuthProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>(builder: (context, controller, child) {
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
                    HomeAddVenueCircle(
                      controller,
                          () {
                        authProvider.isShowCouponContainer = false;
                        LocalDb.storeShowCouponContainerValue(authProvider.isShowCouponContainer);
                        controller.notifyListeners();
                      },
                      true
                    ),
                    CustomAppBar(title: args),
                  ],
                ),
                authProvider.isLimitLoading
                    ? 15.height
                    : Container(),
                authProvider.isLimitLoading
                    ? Container(height:25.w, width: 25.w, child: const Center(child: CircularProgressIndicator(strokeWidth: 3,),))
                    : Container(),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator(),)
                      : controller.venueModel.venueData == null || controller.venueModel.venueData!.length == 0
                        ? Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            "You have no devices".toText(
                                fontSize: authProvider.isIpad ? 22 : 16,
                                color: blackDark,
                                fontFamily: sofiaSemiBold
                            ),
                          ],
                        ))
                        : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 120.height,
                          // CustomTextField(
                          //   height: 40.h,
                          //   width: 340.w,
                          //   controller: controller.searchController,
                          //   hintText: hintSearch,
                          //   textInputType: TextInputType.text,
                          //   textInputAction: TextInputAction.done,
                          //   isSearch: true,
                          //   iconColor: bluePrimary,
                          //   radius: 10,
                          //   borderColor: skyBlueBorder,
                          //   onChanged: (value) {
                          //     controller.getDevices(context, controller.searchController.text, 1.toString());
                          //   },
                          // ),
                          // const Divider(),
                          // 10.height,
                          yourDevices.toText(
                              fontSize: authProvider.isIpad ? 22 : 16,
                              color: blackDark,
                              fontFamily: sofiaSemiBold),
                          10.height,
                          const YourDevicesList()
                        ],
                      ).paddingSymmetric(horizontal: 20.w),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
