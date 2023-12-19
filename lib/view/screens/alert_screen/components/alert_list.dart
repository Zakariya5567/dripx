import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/data/model/notification/notification_model.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../utils/app_keys.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class AlertList extends StatelessWidget {
  Alerts alerts;
  String deviceID;
  AlertList(this.alerts, this.deviceID);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<AlertProvider>(builder: (context, controller, child) {
      return Expanded(
        child: alerts.alertsData == null || alerts.alertsData!.length==0
          ? deviceID == "-1"
            ? youHaveNoAlerts.toText(
              fontSize: 16,
              color: blackDark,
              fontFamily: sofiaSemiBold).center
            : "This device has no alerts".toText(
              fontSize: 16,
              color: blackDark,
              fontFamily: sofiaSemiBold
              ).center
          : ListView.builder(
            controller: controller.alertScrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: alerts.alertsData!.length,
            itemBuilder: (context, index) {
              DateTime dateTime = DateTime.parse(alerts.alertsData![index].createdAt!);
              final pacificTimeZone = tz.getLocation(authProvider.timeZoneValue!);
              DateTime convertedDateTime = tz.TZDateTime.from(dateTime, pacificTimeZone);
              return Column(
                children: [
                  Container(
                    height: 70.h,
                    width: 340.w,
                    decoration: BoxDecoration(
                        color: skyBlueSecondary,
                        boxShadow: const [
                          BoxShadow(
                              color: greyLight, offset: Offset(2, 1), blurRadius: 3)
                        ],
                        borderRadius: borderRadiusCircular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 25.h,
                              // width: 240.w,
                              child: alerts.alertsData![index].alertType!.toText(
                                  fontSize: authProvider.isIpad ? 22 : 16,
                                  color: blackPrimary,
                                  fontFamily: sofiaRegular),
                            ),
                            SizedBox(
                                height: 25.h,
                                // width: 80.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomImage(
                                      image: Images.iconTime,
                                      iconColor: greyPrimary,
                                      width: authProvider.isIpad ? 8.w : 10.w,
                                      height: authProvider.isIpad ? 8.w : 10.w,
                                    ),
                                    5.width,
                                    authProvider.formatTimeDifference(convertedDateTime).toText(
                                        fontSize: authProvider.isIpad ? 16 : 10,
                                        color: blackLight,
                                        fontFamily: sofiaLight),
                                  ],
                                ))
                          ],
                        ),
                        6.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomImage(
                              image: Images.iconLocation,
                              iconColor: greyPrimary,
                              width: authProvider.isIpad ? 8.w : 10.w,
                              height: authProvider.isIpad ? 8.w : 10.w,
                            ),
                            5.width,
                            SizedBox(
                              width: 240.w,
                              child: alerts.alertsData![index].device == null ? "".toText() : alerts.alertsData![index].device!.location!.toText(
                                  fontSize: authProvider.isIpad ? 16 : 10,
                                  color: blackLight,
                                  fontFamily: sofiaLight),
                            )
                          ],
                        ),
                      ],
                    ).paddingOnly(top: 5.h, bottom: 5.h, left: 15.w, right: 5.w),
                  ).onPress(() async {
                    Navigator.pushNamed(context, RouterHelper.alertDetailScreen, arguments: alerts.alertsData![index]);
                  }).paddingSymmetric(vertical: 5.h),

                ],
              );
            }
          ),
      );
    });
  }

}
