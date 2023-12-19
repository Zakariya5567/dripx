import 'dart:io';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/helper/firebase_messaging_helper.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/screens/Authentication_screen/components/logo_section.dart';
import 'package:dripx/view/screens/home_screen/components/home_add_device_circle.dart';
import 'package:dripx/view/screens/home_screen/components/home_data_list.dart';
import 'package:dripx/view/screens/home_screen/components/venue_data_list.dart';
import 'package:dripx/view/screens/setup_screen/component/add_venue_dialoge.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/validation.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'components/popup_button.dart';
import 'components/update_app_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<HomeProvider>(context, listen: false);
      controller.pageNumber = 1;
      // controller.getDevices(context, '', controller.pageNumber.toString());
      controller.getVenues(context, false, controller.pageNumber);
      controller.venueHomeListingScrollController.addListener(() {
        if (controller.venueHomeListingScrollController.offset >= controller.venueHomeListingScrollController.position.maxScrollExtent && !controller.venueHomeListingScrollController.position.outOfRange) {
          controller.pageNumber++;
          if(!controller.isVenuePaginationLoading) {
            print('pagination');
            controller.getVenues(AppKeys.mainNavigatorKey.currentState!.context, true, controller.pageNumber);
          }
        }
      });
    });

    super.initState();
  }

  initPlatformState() {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      var data = result.notification.additionalData;
      if(data!=null && authProvider.authModel != null && authProvider.authModel.token != null) {
        bool routing = data['routing'];
        String alertID = data['id'].toString();
        String type = data['type'].toString();
        print(routing);
        print(alertID);
        print(type);
        var alertDetail = await alertProvider.getAlertDetails(context, alertID);
        AlertsData alertsData = AlertsData.fromJson(alertDetail['data']);
        Navigator.pushNamed(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.alertDetailScreen, arguments: alertsData);
      }
    });
  }

  checkLocationPermission(HomeProvider homeProvider) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final accuracyStatus = await Geolocator.getLocationAccuracy();
      switch(accuracyStatus) {
        case LocationAccuracyStatus.reduced:
          homeProvider.preciseLocation = false;
          break;
        case LocationAccuracyStatus.precise:
          homeProvider.preciseLocation = true;
          print('Precise location');
          break;
        case LocationAccuracyStatus.unknown:
          homeProvider.preciseLocation = false;
          break;
      }
    }
    else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final accuracyStatus = await Geolocator.getLocationAccuracy();
        switch(accuracyStatus) {
          case LocationAccuracyStatus.reduced:
              homeProvider.preciseLocation = false;
            break;
          case LocationAccuracyStatus.precise:
              homeProvider.preciseLocation = true;
            print('Precise location');
            break;
          case LocationAccuracyStatus.unknown:
              homeProvider.preciseLocation = false;
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>( builder: (context, controller, child) {
          return SingleChildScrollView(
            controller: controller.venueHomeListingScrollController,
            child: Column(
              children: [
                Stack(
                  children: [
                    const GradientStatusBar(),
                    const BlueGradient(),
                    const WhiteGradient(),
                    HomeAddVenueCircle(
                      controller,
                      () {
                        authProvider.isShowCouponContainer = false;
                        LocalDb.storeShowCouponContainerValue(authProvider.isShowCouponContainer);
                        controller.notifyListeners();
                      },
                      false
                    ),
                    CustomAppBar(
                      title: home,
                      isBackEnable: false,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          yourVenues.toText(
                              fontSize: authProvider.isIpad ? 22 : 16,
                              color: blackDark,
                              fontFamily: sofiaSemiBold),
                          // IconButton(
                          //   onPressed: () {
                          //     addVenueDialoge(context: context, venueName: '', isEdit: false, venueID: '');
                          //   },
                          //   icon: Icon(
                          //     Icons.add,
                          //     color: blackPrimary,
                          //     size: 25.w,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    9.height,

                    controller.isVenueLoading
                      ? Center(child: Column(
                        children: [
                          SizedBox(height: 170.h,),
                          const CircularProgressIndicator(),
                        ],
                      ))
                      : authProvider.connectionStatus == "No Internet Connection"
                        ? Center(child: Column(
                            children: [
                              SizedBox(height: 160.h,),
                              "Please make sure you have an active internet connection.".toText(
                                  fontSize: authProvider.isIpad ? 22 : 16,
                                  color: blackDark,
                                  maxLine: 3,
                                  fontFamily: sofiaSemiBold
                              ),
                              10.height,
                              CustomButton(
                                buttonName: "Reload",
                                onPressed: () {
                                  controller.isVenuePaginationLoading = false;
                                  controller.isVenueLoading = false;
                                  controller.getVenues(context, false, 1);
                                },
                              ),
                            ],
                          ))
                        : controller.venueModel.venueData == null || controller.venueModel.venueData!.length == 0
                          ? Center(child: Column(
                            children: [
                              SizedBox(height: 160.h,),
                              "You have no venues".toText(
                                fontSize: authProvider.isIpad ? 22 : 16,
                                color: blackDark,
                                fontFamily: sofiaSemiBold
                              ),
                              10.height,
                              CustomButton(
                                buttonName: "Add Venue",
                                onPressed: () {
                                  final alertProvider = Provider.of<AlertProvider>(context, listen: false);
                                  alertProvider.addressController.clear();
                                  alertProvider.venueController.clear();
                                  alertProvider.countryController.clear();
                                  alertProvider.stateController.clear();
                                  alertProvider.cityController.clear();
                                  alertProvider.postalCodeController.clear();
                                  alertProvider.unitNumberController.clear();
                                  alertProvider.deviceLocationController.clear();
                                  Navigator.pushNamed(context, RouterHelper.addVenueScreen);                              },
                              ),
                            ],
                          ))
                          : Column(
                          children: [
                            VenueDataList(
                              controller,
                              true,
                            ),
                            controller.isVenuePaginationLoading ?  Column(
                              children: [
                                10.height,
                                const Center(child: CircularProgressIndicator(),),
                                10.height,
                              ],
                            ) : Container()
                          ],
                        ),
                    // HomeDataList(controller.devices.data!, controller),
                  ],
                ).paddingSymmetric(horizontal: 20.w, vertical: 10.h)
              ],
            ),
          );
        }),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}