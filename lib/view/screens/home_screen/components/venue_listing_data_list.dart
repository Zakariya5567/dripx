import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/view/screens/home_screen/components/popup_button.dart';
import 'package:dripx/view/screens/home_screen/components/venue_popup_menu.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class VenueListingDataList extends StatelessWidget {
  VenueListingDataList(
      this.controller,
      this.goToDevicesScreen
      );

  // List<DevicesData> devices;
  HomeProvider controller;
  bool goToDevicesScreen = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.venueModel.venueData!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            controller.selectedVenue = controller.venueModel.venueData![index];
            controller.notifyListeners();
            final alertProvider = Provider.of<AlertProvider>(context, listen: false);
            alertProvider.addressController.text = '';
            alertProvider.countryController.text = '';
            alertProvider.stateController.text = '';
            alertProvider.cityController.text = '';
            alertProvider.postalCodeController.text = '';
            alertProvider.unitNumberController.text = '';
            alertProvider.deviceLocationController.text = '';
            if(controller.selectedVenue.id == null) {
              showToast(message: "Please select venue");
            } else {
              Navigator.pushNamed(context, RouterHelper.setupFormScreen);
            }
            // Navigator.pushNamed(context, RouterHelper.setupFormScreen);
          },
          child: Container(
            height: 65.h,
            width: 340.w,
            decoration: BoxDecoration(
                color: controller.selectedVenue == controller.venueModel.venueData![index] ? skyBluePrimary : skyBlueDark.withOpacity(0.4),
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
                          fontSize: 16,
                          color: blackPrimary,
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
                // SizedBox(width: 65.w, child: Center(
                //   child: VenuePopupButton(
                //     controller.venueModel.data![index].name!,
                //     controller.venueModel.data![index].id.toString(),
                //     index,
                //     controller,
                //   ),
                // ))
              ],
            ),
          ).paddingSymmetric(vertical: 5.h),
        );
      }
    );
  }
}