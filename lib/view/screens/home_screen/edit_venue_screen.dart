import 'package:dio/dio.dart';
import 'package:dripx/helper/validation.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
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
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/colors.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditVenueScreen extends StatefulWidget {
  const EditVenueScreen({Key? key}) : super(key: key);

  @override
  State<EditVenueScreen> createState() => _EditVenueScreenState();
}

class _EditVenueScreenState extends State<EditVenueScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var searchPlacesResult = [];
  bool showSearchDialoge = false;
  bool disableDialog  = true;

  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
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
                    clipBehavior: Clip.none,
                    children: [
                      const GradientStatusBar(),
                      const BlueGradient(),
                      const WhiteGradient(),
                      GestureDetector(
                        onTap: () {
                          showSearchDialoge = false;
                          controller.notifyListeners();
                        },
                        child: SizedBox(
                            height: 840.h,
                            width: 390.w,
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    60.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {Navigator.pop(context);},
                                          icon: Icon(
                                            Icons.arrow_back_ios_new,
                                            color: blackPrimary,
                                            size: 22.w,
                                          ),
                                        ),
                                        "Edit Venue".toText(color: blackPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                                        Container(width: 25.w,)
                                      ],
                                    ),

                                    15.height,
                                    "Venue name*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      // isReadOnly : true,
                                      controller: controller.editVenueController,
                                      hintText: "Venue name",
                                      textInputType: TextInputType.text,
                                      radius: 8,
                                      onTap: () {},
                                      validator: (value) {
                                        return Validation.deviceVenueNameValidation(value);
                                      },
                                    ),
                                    15.height,


                                    addressWithStar.toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.editAddressController,
                                      hintText: "Address",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      onChanged: (value) {
                                        showSearchDialoge = true;
                                        controller.notifyListeners();
                                        searchPlaces(value, controller);
                                      },
                                      validator: (value) {
                                        return Validation.deviceAddressValidation(value);
                                      },
                                      // onEditingComplete: () {
                                      //   showSearchDialoge = false;
                                      //   controller.notifyListeners();
                                      // },
                                      // onTapOutside: (value) {
                                      //   if(disableDialog) {
                                      //
                                      //   }
                                      // },
                                      onSubmitted: (value) {
                                        showSearchDialoge = false;
                                        controller.notifyListeners();
                                      },
                                    ),
                                    15.height,

                                    "City*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.editCityController,
                                      hintText: "City",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.deviceCityValidation(value);
                                      },
                                    ),
                                    15.height,

                                    "State*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.editStateController,
                                      hintText: "State",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.deviceStateValidation(value);
                                      },
                                    ),
                                    15.height,

                                    "Postal code*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.editPostalCodeController,
                                      hintText: "Postal code",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.devicePostalCodeValidation(value);
                                      },
                                    ),
                                    15.height,

                                    "Country*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.editCountryController,
                                      hintText: "Country",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.deviceCountryValidation(value);
                                      },
                                    ),
                                    15.height,

                                    homeProvider.isVenueEditLoading ? Center(child: Container(height: 35.h, child: const CircularProgressIndicator())) : CustomButton(
                                        buttonName: btnSave,
                                        onPressed: () async {
                                          if(formKey.currentState!.validate()) {
                                            await homeProvider.editVenue(context, controller.selectedEditVenueID!, controller.editVenueController.text, controller.editAddressController.text, controller.editCityController.text, controller.editStateController.text, controller.editPostalCodeController.text, controller.editCountryController.text);
                                          }
                                        }).center,
                                  ],
                                ).paddingSymmetric(horizontal: 25.w),
                              ),
                            )),
                      ),
                      Positioned(
                        top: 305.h,
                        child: !showSearchDialoge ? Container() : Container(
                          height: 200.h,
                          width: 340.w,
                          decoration: BoxDecoration(
                              color: whitePrimary,
                              borderRadius: BorderRadius.circular(10.w),
                              border: Border.all(color: greyPrimary)
                          ),
                          child: searchPlacesResult == null || searchPlacesResult.length == 0
                              ? "No place found".toText(fontSize: 16).center
                              : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: searchPlacesResult.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              disableDialog = false;
                              String text = searchPlacesResult[index]['description'];
                              return GestureDetector(
                                  onTap: () async {
                                    final sessionToken = Uuid().v4();
                                    const kGoogleApiKey = "AIzaSyDOTw-MMejPjZv5vsX_Re0jYawJXivX0J4";
                                    Dio dio = Dio();
                                    controller.addressController.text = searchPlacesResult[index]['description'];
                                    final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${searchPlacesResult[index]['place_id']}&fields=address_component&key=$kGoogleApiKey';
                                    final response = await dio.get(request);
                                    final result = response.data['result'];
                                    final addressComponents = result['address_components'];
                                    for (var component in addressComponents) {
                                      final types = component['types'];

                                      if (types.contains('country')) {
                                        controller.editCountryController.text = component['long_name'];
                                      } else if (types.contains('locality')) {
                                        controller.editCityController.text = component['long_name'];
                                      } else if (types.contains('administrative_area_level_1')) {
                                        controller.editStateController.text = component['long_name'];
                                      } else if (types.contains('postal_code')) {
                                        controller.editPostalCodeController.text = component['long_name'];
                                      }
                                    }
                                    showSearchDialoge = false;
                                    controller.notifyListeners();
                                  },
                                  child: Container(child: text.toText(fontSize: 16, overflow: TextOverflow.visible, maxLine: 2).paddingSymmetric(horizontal: 10.w, vertical: 7.h,))
                              );
                            },
                          ),
                        ).paddingSymmetric(horizontal: 25.w),
                      ),
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

  void _onTextChanged() {
    setState(() {
      // Clear previous search results
      _searchResults = [];
    });

    // Delay the search execution to avoid frequent searches while typing
    Future.delayed(Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String searchText) {
    // Replace this with your own search logic
    // that returns a list of search results based on the searchText
    // For example:
    setState(() {
      if (searchText.isNotEmpty) {
        for (int i = 0; i < 10; i++) {
          _searchResults.add('Result $i');
        }
      }
    });
  }

  searchPlaces(value, AlertProvider controller) async {
    Dio dio = Dio();
    final sessionToken = Uuid().v4();
    const kGoogleApiKey = "AIzaSyDOTw-MMejPjZv5vsX_Re0jYawJXivX0J4";
    final request = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&types=address&language=eng&key=$kGoogleApiKey';
    final response = await dio.get(request);
    searchPlacesResult = response.data['predictions'];
    controller.notifyListeners();
    print(response.data['predictions']);

  }
}
