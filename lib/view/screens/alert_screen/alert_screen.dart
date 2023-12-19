import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_detail_item.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/alert_screen/components/device_detail_item.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? deviceID = '-1';
  String deviceMacAddress = '';
  String deviceVersion = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<AlertProvider>(context, listen: false);
      deviceID = ModalRoute.of(context)!.settings.arguments as String?;
      print("Search device id is ${deviceID}");
      var homeProvider = Provider.of<HomeProvider>(context, listen: false);
      if(deviceID!= "-1") {
        deviceMacAddress = homeProvider.selectedDeviceForAlerts.macAddress!;
        deviceVersion = homeProvider.selectedDeviceForAlerts.firmwareVersion!;
        print(deviceMacAddress);
        if(deviceMacAddress != null) {
          deviceMacAddress = deviceMacAddress.replaceAll(":", "");
          if(deviceMacAddress.length > 6) {
            deviceMacAddress = deviceMacAddress.substring(deviceMacAddress.length - 6);
          }
        }
      }

      controller.alerts = Alerts();
      controller.pageNumber = 1;
      controller.getAlert(AppKeys.mainNavigatorKey.currentState!.context, Provider.of<AlertProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false).pageNumber, deviceID!);
      controller.alertScrollController.addListener(() {
        if (controller.alertScrollController.offset >= controller.alertScrollController.position.maxScrollExtent && !controller.alertScrollController.position.outOfRange) {
          controller.pageNumber++;
          controller.getAlert(AppKeys.mainNavigatorKey.currentState!.context, controller.pageNumber, deviceID!, paginationLoading: true);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<AlertProvider>(builder: (context, controller, child) {
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
                    CustomAppBar(title: deviceID!="-1" ? homeProvider.selectedDeviceForAlerts.name??"" : alert),
                    Visibility(
                      visible: deviceID!="-1",
                      child: Positioned(
                        top: 105.h,
                        child: Container(
                          // height: 125.h,
                          // width: 350.w,
                          decoration: BoxDecoration(
                              color: skyBlueSecondary,
                              boxShadow: const [
                                BoxShadow(
                                    color: greyLight,
                                    offset: Offset(0, 0.3),
                                    blurRadius: 5)
                              ],
                              borderRadius: borderRadiusCircular(10)),
                          child: Column(
                            children: [
                              5.height,
                              DeviceDetailItem(
                                title: deviceName,
                                description: homeProvider.selectedDeviceForAlerts.name??""
                              ),
                              DeviceDetailItem(
                                title: "Serial Number",
                                description: deviceMacAddress
                              ),
                              DeviceDetailItem(
                                title: "Version",
                                description: deviceVersion
                              ),
                              DeviceDetailItem(
                                title: battery,
                                description: "${homeProvider.selectedDeviceForAlerts.battery}%"??""
                              ),
                              DeviceDetailItem(
                                title: location,
                                description: homeProvider.selectedDeviceForAlerts.location??""
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),
                        ).paddingSymmetric(horizontal: 20.w),
                      ),
                    ),
                    SizedBox(
                      height: 840.h,
                      width: 390.w,
                      child: Column(
                        children: [
                          deviceID == "-1" ? 130.height : 250.height,
                          controller.isLoading
                            ? const Expanded(child: Center(child: CircularProgressIndicator(),))
                            : AlertList(controller.alerts, deviceID!),

                          controller.isPaginationLoading ?  Column(
                            children: [
                              10.height,
                              const Center(child: CircularProgressIndicator(),),
                              10.height,
                            ],
                          ) : Container()
                        ],
                      ).paddingSymmetric(horizontal: 20.w)
                    )
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
