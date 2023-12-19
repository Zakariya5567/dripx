import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/provider/wifi_switching_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/screens/home_screen/components/remove_dialog.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class CustomPopupButton extends StatelessWidget {
  List<DevicesData> devices;
  int index;
  HomeProvider controller;
  CustomPopupButton(this.devices, this.index, this.controller);
  
  final recalibrationProvider = Provider.of<ReCalibrationProvider>(AppKeys.mainNavigatorKey.currentContext!);
  final wifiSwitchingProvider = Provider.of<WifiSwitchingProvider>(AppKeys.mainNavigatorKey.currentContext!);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular(10)),
        padding: EdgeInsets.zero,
        color: whitePrimary,
        icon: Image.asset(
          Images.iconDots,
          height: 30.w,
          width: 30.w,
          color: bluePrimary,
        ),
        onSelected: (value) {
          switch (value) {
            case 0:
              recalibrationProvider.searchingDevice = devices[index];
              Navigator.pushNamed(context, RouterHelper.recalibrationScanningScreen);
              break;
            case 1:
              controller.deviceNameController.text = devices[index].name!;
              controller.addressController.text = devices[index].address!;
              controller.locationController.text = devices[index].location!;
              controller.unitNumberController.text = devices[index].unitNumber!;
              Navigator.pushNamed(context, RouterHelper.editDeviceScreen, arguments: devices[index]);
              break;
            case 2:
              removeDialog(context: context, index: index, devices: devices, controller: controller);
              break;
            case 3:
              devices[index].alertStatus = devices[index].alertStatus == "0" ? "1" : devices[index].alertStatus == "1" ? "0" : "";
              controller.notifyListeners();
              controller.updateDeviceAlertStatus(context, devices[index].alertStatus!, devices[index].macAddress!,);
              break;
            case 4:
              wifiSwitchingProvider.searchingDevice = devices[index];
              Navigator.pushNamed(context, RouterHelper.wifiSwitchingScanningScreen);
              break;
            // case 5:
            //   controller.updatedDevice = devices[index];
            //   Navigator.pushNamed(context, RouterHelper.updateFirmwareScreen);
            //   break;
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                value: 0,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.iconTrack,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    reCalibration.toText(
                        fontSize: 10,
                        color: blackLight,
                        fontFamily: sofiaRegular),
                  ],
                )),
            PopupMenuItem(
                value: 1,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.iconPencil,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    edit.toText(
                        fontSize: 10,
                        color: blackLight,
                        fontFamily: sofiaRegular),
                  ],
                )),
            PopupMenuItem(
                value: 2,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.iconDelete,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    remove.toText(
                        fontSize: 10,
                        color: blackLight,
                        fontFamily: sofiaRegular),
                  ],
                )
            ),
            PopupMenuItem(
              value: 3,
              height: 30.h,
              child: Row(
                children: [
                  Container(
                      height: 14.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: devices[index].alertStatus == "0" ? greyPrimary : bluePrimary, borderRadius: borderRadiusCircular(10)),
                      child: Row(
                        children: [
                          Container(
                            height: 8.w,
                            width: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: devices[index].alertStatus == "0"
                                  ? whitePrimary
                                  : bluePrimary,
                            ),
                          ).paddingOnly(left: 2.w),
                          Container(
                            height: 8.w,
                            width: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: devices[index].alertStatus == "1"
                                  ? whitePrimary
                                  : greyPrimary,
                            ),
                          ).onPress(() {
                          }).paddingOnly(right: 2.w)
                        ],
                      ).onPress(() {
                      }),
                    ),
                  6.width,
                  devices[index].alertStatus == "0"
                    ? "Enable alerts".toText(
                      fontSize: 10,
                      color: blackLight,
                      fontFamily: sofiaRegular
                    )
                    : "Disable alerts".toText(
                      fontSize: 10,
                      color: blackLight,
                      fontFamily: sofiaRegular
                    ),
                ],
              ).paddingOnly(right: 20.w),
            ),
            PopupMenuItem(
                value: 4,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.wifi,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    wifiSwitching.toText(
                      fontSize: 10,
                      color: blackLight,
                      fontFamily: sofiaRegular
                    ),
                  ],
                )),
            // PopupMenuItem(
            //   value: 5,
            //   height: 30.h,
            //   child: Row(
            //     children: [
            //       Image.asset(
            //         Images.iconUpdate,
            //         height: 15.w,
            //         width: 15.w,
            //         color: bluePrimary,
            //       ),
            //       10.width,
            //       "Update Device".toText(
            //         fontSize: 10,
            //         color: blackLight,
            //         fontFamily: sofiaRegular
            //       ),
            //     ],
            //   )
            // ),
          ];
        }).align(Alignment.bottomCenter);
  }
}