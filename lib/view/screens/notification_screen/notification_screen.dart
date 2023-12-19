import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/notification_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/screens/notification_screen/components/notification_list.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<NotificationProvider>(context, listen: false);
      controller.pageNumber =1;
      controller.getNotifications(context, Provider.of<NotificationProvider>(context, listen: false).pageNumber);
      controller.notificationsScrollController.addListener(() {
        if (controller.notificationsScrollController.offset >= controller.notificationsScrollController.position.maxScrollExtent && !controller.notificationsScrollController.position.outOfRange) {
          if(!controller.isPaginationLoading){
            controller.pageNumber++;
            controller.getNotifications(context, controller.pageNumber, paginationLoading: true);
          }
        }
      }
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<NotificationProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: notifications),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          children: [
                            110.height,
                            controller.isReadAllNotificationDataLoading ? SizedBox(width: 20.w, height: 20.w, child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5,),),).align(Alignment.centerRight) : "Mark all as read".toText(fontSize: 14, color: bluePrimary).align(Alignment.centerRight).onPress(() {
                              controller.markReadAllNotification(context);
                            }),
                            10.height,
                            controller.isLoading
                              ? const Expanded(child: Center(child: CircularProgressIndicator(),))
                              : NotificationList(controller.notificationsModel),

                            controller.isPaginationLoading ?  Column(
                              children: [
                                10.height,
                                const Center(child: CircularProgressIndicator(),),
                                10.height,
                              ],
                            ) : Container()
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
    );
  }
}
