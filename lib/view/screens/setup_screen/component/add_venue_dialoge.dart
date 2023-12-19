import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/colors.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/utils/style.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/custom_text_field.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future addVenueDialoge({
  required BuildContext context,
  required String venueName,
  required String venueID,
  required bool isEdit,
}) {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (context) {
        return Consumer<HomeProvider>( builder: (context, controller, child) {
          controller.venueNameController.text = venueName;
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Container(
                color: whitePrimary,
                width: 250.w,
                height: 215.h,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isEdit
                        ? "Edit Venue".toText(
                            maxLine: 2,
                            textAlign: TextAlign.center,
                            color: blackPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: sofiaLight
                          ).center
                        : "Add Venue"
                          .toText(
                            maxLine: 2,
                            textAlign: TextAlign.center,
                            color: blackPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: sofiaLight
                          ).center,
                      20.height,
                      CustomTextField(
                        controller: controller.venueNameController,
                        hintText: "Venue name",
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          venueName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your venue name.";
                          }
                          bool hasOnlyBlankSpaces = value.trim().isEmpty;

                          if (hasOnlyBlankSpaces) {
                            return "Please enter valid venue name.";
                          }
                        },
                      ),
                      10.height,
                      controller.isVenueAddLoading ? Center(child: Container(height: 35.h, child: const CircularProgressIndicator())) : CustomButton(
                          buttonColor: bluePrimary,
                          buttonName: isEdit ? "Update" : "Add",
                          textSize: 14,

                          onPressed: () async {
                            if(formKey.currentState!.validate()) {
                              if(isEdit) {
                                // await controller.editVenue(context, venueName, venueID);
                              } else {
                                // await controller.addVenues(context, venueName);
                              }

                              controller.venueNameController.clear();
                              venueName = '';
                            }

                          }
                      ),
                    ],
                  ).paddingSymmetric(vertical: 20.h, horizontal: 10.h),
                ),
              ));
        });
      });
}
