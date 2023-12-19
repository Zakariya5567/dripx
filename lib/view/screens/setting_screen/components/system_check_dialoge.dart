import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/setting_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/screens/home_screen/components/add_coupon_dialoge.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future systemCheckDialoge({
  required BuildContext context,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Consumer<SettingProvider>( builder: (context, controller, child) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Container(
                color: whitePrimary,
                width: 280.w,
                height: 250.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "System Checks".toText(
                        maxLine: 3,
                        textAlign: TextAlign.center,
                        color: blackPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: sofiaLight
                    ).center,
                    10.height,
                    controller.isSystemCheckLoading
                      ? Column(
                        children: [
                          SizedBox(height: 65.h,),
                          const Center(child: CircularProgressIndicator(),),

                        ],
                      )
                      : controller.systemCheckModel == null || controller.systemCheckModel.systemCheck == null || controller.systemCheckModel.systemCheck!.length == 0
                        ? Column(
                          children: [
                            SizedBox(height: 65.h,),
                            "No data available.".toText(
                                maxLine: 3,
                                textAlign: TextAlign.center,
                                color: blackPrimary,
                                fontSize: 16,
                                fontFamily: sofiaBold
                            ).center,
                          ],
                        )
                        : ListView.builder(
                          itemCount: controller.systemCheckModel.systemCheck!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String systemValue = controller.systemCheckModel.systemCheck![index].text!;
                            if(!controller.systemCheckModel.systemCheck![index].value!) {
                              if(!systemValue.contains("Overall")) {
                                systemValue = systemValue.replaceAll("enabled", "disabled");
                              }
                            }
                            return controller.systemCheckModel.systemCheck![index].text!.contains("Overall")
                              ? Container()
                              : Row(
                                children: [
                                  Icon(Icons.error, color: controller.systemCheckModel.systemCheck![index].value == true ? greenPrimary : redPrimary, size: 25.w,),
                                  "${systemValue}.".toText(color: blackPrimary, fontSize: 14, fontFamily: sofiaLight).paddingOnly(left: 5.w, right: 3.w)
                                ],
                              ).paddingAll(5.w);
                          },
                        ),
                    const Spacer(),
                    CustomButton(
                        height: 35.h,
                        width: 100.w,
                        buttonColor: bluePrimary,
                        buttonTextColor: whitePrimary,
                        borderColor: bluePrimary,
                        textSize: 14,
                        buttonName: "OK",
                        radius: 8,
                        onPressed: () {
                          Navigator.pop(context);
                        }).center
                  ],
                ).paddingSymmetric(vertical: 10.h, horizontal: 10.w),
              ));
        });
      });
}