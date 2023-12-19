import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/view/screens/home_screen/components/popup_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/authentication_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class YourDevicesList extends StatefulWidget {
  const YourDevicesList({Key? key}) : super(key: key);

  @override
  State<YourDevicesList> createState() => _YourDevicesListState();
}

class _YourDevicesListState extends State<YourDevicesList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<HomeProvider>( builder: (context, controller, child) {
      return Expanded(
        child: controller.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : controller.devices.data == null || controller.devices.data!.length == 0
            ? Center(child: youHaveNoDevices.toText(
                fontSize: 16,
                color: blackDark,
                fontFamily: sofiaSemiBold),
              )
            :  ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.devices.data!.length,
                itemBuilder: (context, index) {
                  String macAddress = '';
                  if(controller.devices.data![index].macAddress != null) {
                    macAddress = controller.devices.data![index].macAddress!.replaceAll(":", "");
                    if(macAddress.length > 6) {
                      macAddress = macAddress.substring(macAddress.length - 6);
                    }
                  }
                  return GestureDetector(
                    onTap: () {
                      controller.selectedDeviceForAlerts = controller.devices.data![index];
                      print(controller.selectedDeviceForAlerts);
                      Navigator.pushNamed(context, RouterHelper.alertScreen, arguments: controller.devices.data![index].id.toString());
                    },
                    child: Container(
                      height: authProvider.firmwareVersion != controller.devices.data![index].firmwareVersion ? 85.h : 70.h,
                      width: 340.w,
                      decoration: BoxDecoration(
                          color: skyBluePrimary,
                          borderRadius: borderRadiusCircular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 70.h,
                            width: 5,
                            decoration: BoxDecoration(
                                color: controller.devices.data![index].isActive != "1" ? pinkPrimary : greenPrimary,
                                // color: index % 2 == 0 ? pinkPrimary : greenDark,
                                borderRadius: borderRadiusCircular(10)),
                          ).paddingSymmetric(vertical: 5.h),
                          15.width,
                          SizedBox(
                            width: 260.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    controller.devices.data![index].name!.toText(
                                      fontSize: authProvider.isIpad ? 22 : 16,
                                      color: blackPrimary,
                                      fontFamily: sofiaRegular
                                    ),
                                  ],
                                ),

                                // authProvider.firmwareVersion != controller.devices.data![index].firmwareVersion ? 6.height : 0.height,
                                // authProvider.firmwareVersion != controller.devices.data![index].firmwareVersion
                                //   ? Row(
                                //     children: [
                                //       "Please ".toText(color: redPrimary, fontSize: 13),
                                //       "update".toText(color: bluePrimary, fontSize: 13, underLine: true),
                                //       " your device.".toText(color: redPrimary, fontSize: 13),
                                //     ],
                                //   ).onPress(() {
                                //     controller.updatedDevice = controller.devices.data![index];
                                //     Navigator.pushNamed(context, RouterHelper.updateFirmwareScreen);
                                //
                                //   })
                                //   : Container(),

                                6.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    // Image.asset(
                                    //   Images.iconLocation,
                                    //   height: 10.w,
                                    //   width: 10.w,
                                    //   color: greyPrimary,
                                    // ),
                                    // 5.width,
                                    // SizedBox(
                                    //   width: 240.w,
                                    //   child: macAddress
                                    //       .toText(
                                    //       fontSize: 10,
                                    //       color: blackLight,
                                    //       fontFamily: sofiaLight),
                                    // ),

                                    controller.devices.data![index].isActive == "1" && controller.devices.data![index].currentState!.toLowerCase() == "connected"
                                        ? "Connected"
                                        .toText(
                                          fontSize: authProvider.isIpad ? 18 : 13,
                                          cutThrough: false,
                                          color: Colors.green,
                                          fontFamily: sofiaBold,
                                        )
                                        : "Not Connected"
                                        .toText(
                                          fontSize: authProvider.isIpad ? 18 : 13,
                                          cutThrough: true,
                                          color: redPrimary,
                                          fontFamily: sofiaBold,
                                        ),
                                    " | "
                                        .toText(
                                        fontSize: 13,
                                        color: blackLight,
                                        fontFamily: sofiaLight),

                                        controller.devices.data![index].calibrationStatus!.toLowerCase() != "completed"
                                        ? "Not Calibrated"
                                            .toText(
                                            fontSize: authProvider.isIpad ? 18 : 13,
                                            cutThrough: true,
                                            color: redPrimary,
                                            fontFamily: sofiaBold
                                        )
                                        : "Calibrated"
                                            .toText(
                                            fontSize: authProvider.isIpad ? 18 : 13,
                                            cutThrough: false,
                                            color: Colors.green,
                                            fontFamily: sofiaBold
                                        ),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(vertical: 5.h),
                          ),
                          SizedBox(width: 65.w, child: CustomPopupButton(controller.devices.data!, index, controller)).paddingSymmetric(vertical: authProvider.isIpad ? 20.h : authProvider.firmwareVersion != controller.devices.data![index].firmwareVersion ? 16.h :  8.h),
                        ],
                      ),
                    ).paddingSymmetric(vertical: 5.h),
                  );
                }
            ),
      );
    });
  }
}