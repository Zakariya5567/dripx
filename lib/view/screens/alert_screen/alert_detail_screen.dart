import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_detail_item.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/extention/border_extension.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AlertDetailScreen extends StatefulWidget {
  const AlertDetailScreen({Key? key}) : super(key: key);

  @override
  State<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends State<AlertDetailScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    AlertsData alertDetail = ModalRoute.of(context)!.settings.arguments as AlertsData;
    DateTime dateTime = DateTime.parse(alertDetail.createdAt!);
    final pacificTimeZone = tz.getLocation(authProvider.timeZoneValue!);

    DateTime convertedDateTime = tz.TZDateTime.from(dateTime, pacificTimeZone);
    String formattedTime = DateFormat('hh:mm a').format(convertedDateTime);
    String formattedDate = DateFormat('MM-dd-yyyy').format(convertedDateTime);
    // var alertReceivedDate = dateTime.year.toString() + "-" + dateTime.month.toString() + "-" + dateTime.day.toString();
    // var alertReceivedTime = dateTime.hour.toString() + ":" + dateTime.minute.toString() + "-" + dateTime.second.toString();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<AlertProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: alert),
                      SizedBox(
                          height: 840.h,
                          width: 390.w,
                          child: Column(
                            children: [
                              130.height,
                              Container(
                                  //height: 70.h,
                                  width: 340.w,
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
                                      alertDetail.alertType!.toUpperCase().toText(color: redPrimary, fontSize: authProvider.isIpad ? 20 : 15, fontWeight: FontWeight.w500),
                                      5.height,
                                      AlertDetailItem(
                                        title: deviceName,
                                        description: alertDetail.device!.name!
                                      ),
                                      AlertDetailItem(
                                        title: location,
                                        description: alertDetail.device!.location!
                                      ),
                                      AlertDetailItem(
                                        title: alertDate,
                                        description: formattedDate
                                      ),
                                      AlertDetailItem(
                                        title: alertTime,
                                        description: formattedTime
                                      ),
                                    ],
                                  ).paddingSymmetric(
                                      horizontal: 5.w, vertical: 20.h)),
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
