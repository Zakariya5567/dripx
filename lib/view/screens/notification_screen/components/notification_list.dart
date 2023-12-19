import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/data/model/notification/notification_model.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:dripx/provider/notification_provider.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class NotificationList extends StatelessWidget {
  NotificationsModel notificationsModel;
  NotificationList(this.notificationsModel);


  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, controller, child) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      return Expanded(
        child: notificationsModel.notificationData == null || notificationsModel.notificationData!.length==0
            ? youHaveNoNotifications.toText(
              fontSize: 16,
              color: blackDark,
              fontFamily: sofiaSemiBold).center
            : controller.isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : ListView.builder(
              controller: controller.notificationsScrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notificationsModel.notificationData!.length,
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(notificationsModel.notificationData![index].createdAt!);
                final pacificTimeZone = tz.getLocation(authProvider.timeZoneValue!);

                DateTime convertedDateTime = tz.TZDateTime.from(dateTime, pacificTimeZone);
                String formattedTime = DateFormat('hh:mm a').format(convertedDateTime);
                String formattedDate = DateFormat('MM-dd-yyyy').format(convertedDateTime);
                return Column(
                  children: [
                    Container(
                      height: 90.h,
                      width: 340.w,
                      decoration: BoxDecoration(
                          color: controller.notificationsModel.notificationData![index].readAt != "null"
                              ? skyBlueLight
                              : skyBlueDark.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                                color: controller.notificationsModel.notificationData![index].readAt != "null" ? greyLight : greyPrimary, offset: Offset(2, 1), blurRadius: controller.notificationsModel.notificationData![index].isRead! ? 2 : 2)
                          ],
                          borderRadius: borderRadiusCircular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Container(
                          //   height: 5.w,
                          //   width: 5.w,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: controller.notificationsModel.notificationData![index].readAt != "null" ? Colors.transparent : bluePrimary
                          //   ),
                          // ).paddingSymmetric(horizontal: 5.w),
                          Container(
                            height: 45.w,
                            width: 45.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bluePrimary.withOpacity(0.5)
                            ),
                            child: Center(child: Icon(Icons.notifications, color: bluePrimary, size: 25.w,),),
                          ).paddingSymmetric(horizontal: 5.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55.h,
                                    width: 230.w,
                                    // color: Colors.green,
                                    child: notificationsModel.notificationData![index].data!.message!.toText(
                                        fontSize: 13,
                                        color: blackPrimary,
                                        fontFamily: sofiaRegular,
                                      maxLine: 3
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      8.height,
                                      "View".toText(
                                          fontSize: 13,
                                          color: bluePrimary,
                                          fontFamily: sofiaRegular,
                                      ).center.paddingSymmetric(horizontal: 5.w),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 25.h,
                                  //   width: 80.w,
                                  //   child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.end,
                                  //       children: [
                                  //         CustomImage(
                                  //           image: Images.iconTime,
                                  //           iconColor: greyPrimary,
                                  //           width: 10.w,
                                  //           height: 10.w,
                                  //         ),
                                  //         5.width,
                                  //         "16m ago".toText(
                                  //             fontSize: 10,
                                  //             color: blackLight,
                                  //             fontFamily: sofiaLight),
                                  //       ],
                                  //     )
                                  // )
                                ],
                              ),
                              3.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomImage(
                                    image: Images.iconTime,
                                    iconColor: greyPrimary,
                                    width: 10.w,
                                    height: 10.w,
                                  ),
                                  5.width,
                                  SizedBox(
                                    width: 240.w,
                                    child: authProvider.formatTimeDifference(convertedDateTime).toText(
                                      fontSize: 10,
                                      color: blackLight,
                                      fontFamily: sofiaLight
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ).paddingOnly(top: 5.h, bottom: 5.h, left: 2.w, right: 5.w),
                        ],
                      ),
                    ).onPress(() {

                      AlertsData notificationAlert = AlertsData(
                        id: int.parse(notificationsModel.notificationData![index].data!.alert!.id!),
                        leakType: notificationsModel.notificationData![index].data!.alert!.leakType!,
                        leakDate: notificationsModel.notificationData![index].data!.alert!.createdAt!,
                        alertType: notificationsModel.notificationData![index].data!.alert!.alertType!,
                        deviceId: int.parse(notificationsModel.notificationData![index].data!.alert!.deviceId == "null" ? '0' : notificationsModel.notificationData![index].data!.alert!.deviceId!),
                        createdAt: notificationsModel.notificationData![index].data!.alert!.createdAt!,
                        device: AlertDevice(
                          id: int.parse(notificationsModel.notificationData![index].data!.alert!.device == null ? '0' : notificationsModel.notificationData![index].data!.alert!.device!.id!),
                          name: notificationsModel.notificationData![index].data!.alert!.device!.name!,
                          macAddress: notificationsModel.notificationData![index].data!.alert!.device!.macAddress!,
                          publicIp: notificationsModel.notificationData![index].data!.alert!.device!.publicIp!,
                          address: notificationsModel.notificationData![index].data!.alert!.device!.address!,
                          location: notificationsModel.notificationData![index].data!.alert!.device!.location!,
                          sdCard: notificationsModel.notificationData![index].data!.alert!.device!.sdCard!,
                          currentState: notificationsModel.notificationData![index].data!.alert!.device!.currentState!,
                        )
                      );
                      if(notificationsModel.notificationData![index].readAt=="null") {
                        controller.readSingleNotification(context, controller.notificationsModel.notificationData![index].id!.toString());
                      }
                      DateTime now = DateTime.now();
                      controller.notificationsModel.notificationData![index].readAt = now.toString();
                      controller.notifyListeners();
                      Navigator.pushNamed(context, RouterHelper.alertDetailScreen, arguments: notificationAlert);
                    }).paddingSymmetric(vertical: 5.h),

                  ],
                );
              }
            ),
      );
    });
  }
}
