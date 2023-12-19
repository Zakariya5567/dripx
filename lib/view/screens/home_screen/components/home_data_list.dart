import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/view/screens/home_screen/components/popup_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class HomeDataList extends StatelessWidget {
  HomeDataList(this.devices, this.controller);

  List<DevicesData> devices;
  HomeProvider controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: devices.length> 4 ? 4 : devices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.selectedDeviceForAlerts = devices[index];
              print(controller.selectedDeviceForAlerts);
              Navigator.pushNamed(context, RouterHelper.alertScreen, arguments: devices[index].id.toString());
            },
            child: Container(
              height: 65.h,
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
                        color: devices[index].currentState != "connected" ? pinkPrimary : greenPrimary,
                        borderRadius: borderRadiusCircular(10)),
                  ).paddingSymmetric(vertical: 5.h),
                  15.width,
                  SizedBox(
                    width: 260.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        devices[index].name!.toText(
                            fontSize: 16,
                            color: blackPrimary,
                            fontFamily: sofiaRegular),
                        6.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              Images.iconLocation,
                              height: 10.w,
                              width: 10.w,
                              color: greyPrimary,
                            ),
                            5.width,
                            SizedBox(
                              width: 240.w,
                              child: devices[index].macAddress!
                                  .toText(
                                  fontSize: 10,
                                  color: blackLight,
                                  fontFamily: sofiaLight),
                            )
                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: 5.h),
                  ),
                  SizedBox(width: 65.w, child: CustomPopupButton(devices, index, controller))
                ],
              ),
            ).paddingSymmetric(vertical: 5.h),
          );
        });
  }
}