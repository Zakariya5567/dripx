import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/view/screens/home_screen/components/popup_button.dart';
import 'package:dripx/view/screens/home_screen/components/venue_popup_menu.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/authentication_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class VenueDataList extends StatelessWidget {
  VenueDataList(
    this.controller,
    this.goToDevicesScreen
  );

  // List<DevicesData> devices;
  HomeProvider controller;
  bool goToDevicesScreen = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () {
        controller.pageNumber = 1;
        return controller.getVenues(context, false, controller.pageNumber);
      },
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          // controller: controller.venueHomeListingScrollController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.venueModel.venueData!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                authProvider.getVersions(context);
                controller.selectedVenue = controller.venueModel.venueData![index];
                controller.searchDeviceByVenueID = controller.venueModel.venueData![index].id.toString();
                Navigator.pushNamed(context, RouterHelper.yourDevicesScreen, arguments: controller.venueModel.venueData![index].name.toString());
              },
              child: Tooltip(
                message: controller.venueModel.venueData![index].name!,
                preferBelow: false,
                child: Container(
                  height: 65.h,
                  width: 340.w,
                  decoration: BoxDecoration(
                      color: skyBlueDark.withOpacity(0.5),
                      borderRadius: borderRadiusCircular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      15.width,
                      SizedBox(
                        width: 260.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            controller.venueModel.venueData![index].name!.toText(
                                fontSize: authProvider.isIpad ? 22 : 16,
                                color: blackPrimary,
                                fontFamily: sofiaRegular),
                            "Devices: ${controller.venueModel.venueData![index].totalDevices!}".toText(
                                fontSize: authProvider.isIpad ? 20 : 14,
                                color: greyPrimary,
                                fontFamily: sofiaRegular),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Image.asset(
                            //       Images.iconLocation,
                            //       height: 10.w,
                            //       width: 10.w,
                            //       color: greyPrimary,
                            //     ),
                            //     5.width,
                            //     SizedBox(
                            //       width: 240.w,
                            //       child: "Venue address"
                            //         .toText(
                            //         fontSize: 10,
                            //         color: blackLight,
                            //         fontFamily: sofiaLight
                            //       ),
                            //     )
                            //   ],
                            // ),
                          ],
                        ).paddingSymmetric(vertical: 5.h),
                      ),
                      SizedBox(
                          width: 65.w, child: Center(
                        child: VenuePopupButton(
                            controller.venueModel.venueData![index],
                            index,
                            controller,
                        ),
                      )).paddingSymmetric(vertical: authProvider.isIpad ? 12.h : 7.h),
                    ],
                  ),
                ).paddingSymmetric(vertical: 5.h),
              ),
            );
          }),
    );
  }
}