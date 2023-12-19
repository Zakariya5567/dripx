import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/data/model/venue/venue_model.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/setup_provider.dart';
import 'package:dripx/view/screens/home_screen/components/add_coupon_dialoge.dart';
import 'package:dripx/view/screens/home_screen/components/device_limit_dialoge.dart';
import 'package:dripx/view/screens/setup_screen/component/add_venue_dialoge.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';

class HomeAddVenueCircle extends StatelessWidget {
  HomeProvider homeProvider;
  VoidCallback onSkipTap;
  bool isDevice;
  HomeAddVenueCircle(this.homeProvider, this.onSkipTap, this.isDevice);

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    DateTime expiryDate = DateTime.now();
    int showExpiryNotification = 1;
    if(authProvider.authModel.data!.coupon!.expiry!="" && authProvider.authModel.data!.coupon!.expiry!=null) {
      DateTime dateTime = DateTime.parse(authProvider.authModel.data!.coupon!.expiry!);
      final pacificTimeZone = tz.getLocation(authProvider.timeZoneValue!);
      DateTime convertedDateTime = tz.TZDateTime.from(dateTime, pacificTimeZone);
      String formattedDate = DateFormat('yyyy-MM-dd').format(convertedDateTime);
      expiryDate = DateTime.parse(formattedDate);
      showExpiryNotification = DateTime.now().difference(expiryDate).inDays;
      if(expiryDate.day == DateTime.now().day && expiryDate.month == DateTime.now().month && expiryDate.year == DateTime.now().year) {
        showExpiryNotification = 0;
      } else {
        showExpiryNotification = showExpiryNotification-1;
      }
      print(showExpiryNotification);
    }
    print('df');
    return Positioned(
      left: 0,
      top: 120.h,
      child: SizedBox(
        // height: 340.h,
        width: 390.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            !authProvider.isShowCouponContainer
              ? Container(
                  height: 20.h,
                  )
              : Container(
            // height: 47.h,
            decoration: BoxDecoration(
                color: bluePrimary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "You are just one step from enabling your device. ",
                    style: TextStyle(
                      color: whitePrimary,
                      fontSize: authProvider.isIpad ? 20 : 14,
                      fontFamily: sofiaRegular,
                    ),
                  ),
                  TextSpan(
                    text: 'Click here ',
                    style: const TextStyle(
                      color: blueSecondary,
                      fontSize: 14,
                      fontFamily: sofiaRegular,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      authProvider.couponController.clear();
                      authProvider.couponText = '';
                      authProvider.couponValidationText = '';
                      authProvider.couponValidation = false;
                      addCouponDialoge(context: context);
                    },
                  ),
                  const TextSpan(
                    text: "to enter the coupon code",
                    style: TextStyle(
                      color: whitePrimary,
                      fontSize: 14,
                      fontFamily: sofiaRegular,
                    ),
                  ),
                  // const TextSpan(
                  //   text: 'to avail the coupon or ',
                  //   style: TextStyle(
                  //     color: whitePrimary,
                  //     fontSize: 14,
                  //     fontFamily: sofiaRegular,
                  //   ),
                  // ),
                  // TextSpan(
                  //   text: 'skip.',
                  //   style: const TextStyle(
                  //     color: blueSecondary,
                  //     fontSize: 14,
                  //     fontFamily: sofiaRegular,
                  //   ),
                  //   recognizer: TapGestureRecognizer()..onTap = onSkipTap
                  // ),

                ],
              ),
            ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),

          ).paddingSymmetric(horizontal: 20.w),

            authProvider.authModel.data!.subscription!.id != null
              ? Container()
              : authProvider.authModel.data!.coupon!.expiry == null
                ? Container()
                : expiryDate.day == DateTime.now().day && expiryDate.month == DateTime.now().month && expiryDate.year == DateTime.now().year
                  ? Container(
                // height: 47.h,
                decoration: BoxDecoration(
                  color: bluePrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Attention! your coupon will expire today.",
                        style: TextStyle(
                          color: whitePrimary,
                          fontSize: authProvider.isIpad ? 20 : 14,
                          fontFamily: sofiaRegular,
                        ),
                      ),
                      // TextSpan(
                      //   text: 'Hide ',
                      //   style: const TextStyle(
                      //     color: blueSecondary,
                      //     fontSize: 14,
                      //     fontFamily: sofiaRegular,
                      //   ),
                      //   recognizer: TapGestureRecognizer()..onTap = () {
                      //     authProvider.hideNotificationExpiryDialoge = true;
                      //     LocalDb.storeNotificationExpiry(true);
                      //     authProvider.notifyListeners();
                      //   },
                      // ),

                    ],
                  ),
                ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),

              ).paddingSymmetric(horizontal: 20.w)
                  :  showExpiryNotification < 0 && showExpiryNotification >= -3
                    ? Container(
                      // height: 47.h,
                      decoration: BoxDecoration(
                          color: bluePrimary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Attention! your coupon will expire after ${showExpiryNotification.toString().replaceAll('-','')} ${showExpiryNotification == -1 ? 'day' : "days"}. ",
                              style: TextStyle(
                                color: whitePrimary,
                                fontSize: authProvider.isIpad ? 20 : 14,
                                fontFamily: sofiaRegular,
                              ),
                            ),
                            // TextSpan(
                            //   text: 'Hide ',
                            //   style: const TextStyle(
                            //     color: blueSecondary,
                            //     fontSize: 14,
                            //     fontFamily: sofiaRegular,
                            //   ),
                            //   recognizer: TapGestureRecognizer()..onTap = () {
                            //     authProvider.hideNotificationExpiryDialoge = true;
                            //     LocalDb.storeNotificationExpiry(true);
                            //     authProvider.notifyListeners();
                            //   },
                            // ),

                          ],
                        ),
                      ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),

                    ).paddingSymmetric(horizontal: 20.w)
                    : Container(),
            8.height,
            Container(
              height: authProvider.isIpad ? 95.w : 140.w,
              width: authProvider.isIpad ? 95.w : 140.w,
              decoration: const BoxDecoration(color: skyBlueLight, shape: BoxShape.circle),
              child: Container(
                decoration: const BoxDecoration(color: skyBluePrimary, shape: BoxShape.circle),
                child: Container(
                  decoration: const BoxDecoration(color: blueLight, shape: BoxShape.circle),
                  child: Icon(
                    Icons.add,
                    color: whitePrimary,
                    size: authProvider.isIpad ? 15.w : 40.w,
                  ).align(Alignment.center),
                ).paddingAll(17.w),
              ).paddingAll(17.w),
            ).center.onPress(() async {
              if(isDevice) {
                final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                homeProvider.notifyListeners();
                final alertProvider = Provider.of<AlertProvider>(context, listen: false);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.isLimitLoading = true;
                homeProvider.notifyListeners();
                await authProvider.getUserProfile(context);
                authProvider.isLimitLoading = false;
                homeProvider.notifyListeners();
                alertProvider.addressController.clear();
                alertProvider.countryController.clear();
                alertProvider.stateController.clear();
                alertProvider.cityController.clear();
                alertProvider.postalCodeController.clear();
                alertProvider.unitNumberController.clear();
                alertProvider.deviceLocationController.clear();
                if(authProvider.authModel.data!.subscription!.id!=null) {
                  Navigator.pushNamed(context, RouterHelper.setupGoodToGoScreen);
                }
                else if(authProvider.authModel.data!.coupon!.id!=null) {
                  if(double.parse(authProvider.authModel.data!.coupon!.allowedDevices!) > double.parse(authProvider.authModel.data!.activeDevices!)){
                    Navigator.pushNamed(context, RouterHelper.setupGoodToGoScreen);
                  }
                  else {
                    deviceLimitDialoge(context: context, txt: "Your devices limit is exceeded.");
                    // showToast(message: "Your devices limit is exceeded.");
                  }
                }
                else {
                  Navigator.pushNamed(context, RouterHelper.setupFormScreen);
                }
                // else if (authProvider.authModel.data!.subscription!.id==null && authProvider.authModel.data!.coupon!.id==null){
                //   deviceLimitDialoge(context: context, txt: "You must have coupon or subscription to add device.");
                // }

              } else {
                final alertProvider = Provider.of<AlertProvider>(context, listen: false);
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.getUserProfile(context);
                alertProvider.addressController.clear();
                alertProvider.venueController.clear();
                alertProvider.countryController.clear();
                alertProvider.stateController.clear();
                alertProvider.cityController.clear();
                alertProvider.postalCodeController.clear();
                alertProvider.unitNumberController.clear();
                alertProvider.deviceLocationController.clear();
                Navigator.pushNamed(context, RouterHelper.addVenueScreen);
                // addVenueDialoge(context: context, venueName: '', isEdit: false, venueID: '');
              }

            }),
            5.height,
            isDevice
                ? "Add Device".toText(
                fontSize: authProvider.isIpad ? 24 : 18,
                fontFamily: sofiaRegular,
                color: blackDark)
                .center
                : "Add Venue"
                .toText(
                fontSize: authProvider.isIpad ? 24 : 18,
                fontFamily: sofiaRegular,
                color: blackDark)
                .center,
            10.height,
            Container(
              height: 1,
              width: 390.w,
              color: skyBluePrimary,
            ).paddingSymmetric(horizontal: 30.w)
          ],
        ),
      ),
    );
  }
}
