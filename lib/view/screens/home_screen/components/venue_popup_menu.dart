import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/data/model/venue/venue_model.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/recalibration_provider.dart';
import 'package:dripx/provider/wifi_switching_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/screens/home_screen/components/delete_venue_dialoge.dart';
import 'package:dripx/view/screens/home_screen/components/remove_dialog.dart';
import 'package:dripx/view/screens/setup_screen/component/add_venue_dialoge.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/authentication_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class VenuePopupButton extends StatelessWidget {
  VenueData venue;
  int index;
  HomeProvider controller;
  VenuePopupButton(
      this.venue,
      this.index,
      this.controller
  );

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return PopupMenuButton(
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular(10)),
        padding: EdgeInsets.zero,
        color: whitePrimary,
        icon: Image.asset(
          Images.iconDots,
          height: 30.w,
          width: 30.w,
          color: bluePrimary,
        ),
        onSelected: (value) {
          switch (value) {
            case 0:
              final alertProvider = Provider.of<AlertProvider>(context, listen: false);
              alertProvider.editVenueController.text = venue.name!;
              alertProvider.editAddressController.text = venue.address!;
              alertProvider.editCityController.text = venue.city!;
              alertProvider.editStateController.text = venue.state!;
              alertProvider.editPostalCodeController.text = venue.zipCode!;
              alertProvider.editCountryController.text = venue.country!;
              alertProvider.selectedEditVenueID = venue.id.toString();
              Navigator.pushNamed(context, RouterHelper.editVenueScreen);
              // addVenueDialoge(context: context, venueName: venueName, isEdit: true, venueID: venueID);
              break;
            case 1:
              deleteDeviceDialoge(context: context, venueID: venue.id.toString());
              break;
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                value: 0,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.iconPencil,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    edit.toText(
                        fontSize: authProvider.isIpad ? 20 : 10,
                        color: blackLight,
                        fontFamily: sofiaRegular),
                  ],
                )),
            PopupMenuItem(
                value: 1,
                height: 30.h,
                child: Row(
                  children: [
                    Image.asset(
                      Images.iconDelete,
                      height: 15.w,
                      width: 15.w,
                      color: bluePrimary,
                    ),
                    10.width,
                    remove.toText(
                        fontSize: authProvider.isIpad ? 20 : 10,
                        color: blackLight,
                        fontFamily: sofiaRegular),
                  ],
                )),
          ];
        }).align(Alignment.bottomCenter);
  }
}