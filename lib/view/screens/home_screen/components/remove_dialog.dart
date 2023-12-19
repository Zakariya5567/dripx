import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/device_model/devices.dart';

Future removeDialog({
  required BuildContext context,
  required int index,
  required List<DevicesData> devices,
  required HomeProvider controller,
}) {
  final homeProvider = Provider.of<HomeProvider>(context, listen: false);
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              color: whitePrimary,
              width: 250.w,
              // height: 180.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  removeDescription
                      .toText(
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight)
                      .center,
                  10.height,
                  "Note: In case of device deletion, you need to restart the device when you want to add this device again."
                      .toText(
                      maxLine: 3,
                      textAlign: TextAlign.center,
                      color: blackPrimary,
                      fontSize: 15,
                      fontFamily: sofiaLight)
                      .center,
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: whitePrimary,
                          buttonTextColor: blackPrimary,
                          borderColor: greyPrimary,
                          buttonName: btnCancel,
                          textSize: 14,
                          radius: 8,
                          onPressed: () {Navigator.pop(context);}),
                      10.width,
                      CustomButton(
                          height: 35.h,
                          width: 94.w,
                          buttonColor: redPrimary,
                          buttonTextColor: whitePrimary,
                          borderColor: redPrimary,
                          textSize: 14,
                          buttonName: btnRemove,
                          radius: 8,
                          onPressed: () async {
                            print(devices[index].id!.toString());
                            await homeProvider.deleteDevice(devices[index].id!.toString(), context);
                            controller.notifyListeners();
                            controller.getDevices(context, '', 1.toString(), venueID: controller.selectedVenue.id);
                            controller.getVenues(context, false, 1);
                          })
                    ],
                  )
                ],
              ).paddingSymmetric(vertical: 20.h, horizontal: 10),
            ));
      });
}