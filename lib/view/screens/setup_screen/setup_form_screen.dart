import 'package:dio/dio.dart';
import 'package:dripx/helper/validation.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
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

class SetupFormScreen extends StatefulWidget {
  const SetupFormScreen({Key? key}) : super(key: key);

  @override
  State<SetupFormScreen> createState() => _SetupFormScreenState();
}

class _SetupFormScreenState extends State<SetupFormScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var searchPlacesResult = [];
  bool showSearchDialoge = false;
  bool disableDialog  = true;

  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context,listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<AlertProvider>(builder: (context, controller, child) {
          controller.venueController.text = homeProvider.selectedVenue.name!;
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
                                        "Add Device".toText(color: blackPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                                        Container(width: 25.w,)
                                      ],
                                    ),
                                    // 15.height,
                                    // TypeAheadFormField<String>(
                                    //   textFieldConfiguration: TextFieldConfiguration(
                                    //     controller: _searchController,
                                    //     decoration: InputDecoration(
                                    //     errorStyle: const TextStyle(
                                    //       fontSize: 12, color: redPrimary, fontFamily: sofiaRegular
                                    //     ),
                                    //     // fillColor: fillColor,
                                    //     filled: false,
                                    //
                                    //     floatingLabelBehavior: FloatingLabelBehavior.always,
                                    //     hintText: hintAddress,
                                    //     hintStyle: const TextStyle(
                                    //         fontSize: 14, color: greySecondary, fontFamily: sofiaRegular),
                                    //     // Content padding is the inside padding of the text field
                                    //     contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20),
                                    //
                                    //     border: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       borderSide: BorderSide(color: greyPrimary, width: 1),
                                    //     ),
                                    //
                                    //     errorBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       borderSide: const BorderSide(color: redPrimary, width: 1),
                                    //     ),
                                    //
                                    //     focusedErrorBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       borderSide: const BorderSide(color: redPrimary, width: 1.2),
                                    //     ),
                                    //
                                    //     enabledBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       borderSide: BorderSide(color: greyPrimary, width: 1),
                                    //     ),
                                    //
                                    //     focusedBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       borderSide: const BorderSide(color: bluePrimary, width: 1),
                                    //     )
                                    //   )),
                                    //   suggestionsCallback: (pattern) async {
                                    //     searchPlaces(pattern, controller);
                                    //     return _searchResults;
                                    //   },
                                    //   itemBuilder: (context, suggestion) {
                                    //     return ListView.builder(
                                    //       padding: EdgeInsets.zero,
                                    //       itemCount: searchPlacesResult.length,
                                    //       shrinkWrap: true,
                                    //       itemBuilder: (context, index) {
                                    //         String text = searchPlacesResult[index]['description'];
                                    //         return GestureDetector(
                                    //             onTap: () async {
                                    //               final sessionToken = Uuid().v4();
                                    //               const kGoogleApiKey = "AIzaSyDOTw-MMejPjZv5vsX_Re0jYawJXivX0J4";
                                    //               Dio dio = Dio();
                                    //               controller.addressController.text = searchPlacesResult[index]['description'];
                                    //               final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=${searchPlacesResult[index]['place_id']}&fields=address_component&key=$kGoogleApiKey';
                                    //               final response = await dio.get(request);
                                    //               final result = response.data['result'];
                                    //               final addressComponents = result['address_components'];
                                    //               for (var component in addressComponents) {
                                    //                 final types = component['types'];
                                    //
                                    //                 if (types.contains('country')) {
                                    //                   controller.countryController.text = component['long_name'];
                                    //                 } else if (types.contains('locality')) {
                                    //                   controller.cityController.text = component['long_name'];
                                    //                 } else if (types.contains('administrative_area_level_1')) {
                                    //                   controller.stateController.text = component['long_name'];
                                    //                 } else if (types.contains('postal_code')) {
                                    //                   controller.postalCodeController.text = component['long_name'];
                                    //                 }
                                    //               }
                                    //               showSearchDialoge = false;
                                    //               controller.notifyListeners();
                                    //             },
                                    //             child: Container(child: text.toText(fontSize: 16, overflow: TextOverflow.visible, maxLine: 2).paddingSymmetric(horizontal: 10.w, vertical: 7.h,))
                                    //         );
                                    //       },
                                    //     );
                                    //   },
                                    //   onSuggestionSelected: (suggestion) {
                                    //     setState(() {
                                    //       _searchController.text = suggestion;
                                    //     });
                                    //   },
                                    //
                                    // ),

                                    15.height,
                                    "Venue".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      isReadOnly : true,
                                      controller: controller.venueController,
                                      hintText: "Venue",
                                      textInputType: TextInputType.none,
                                      radius: 8,
                                      onTap: () {},
                                      fillColor: greyLight,
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
                                      controller: controller.addressController,
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

                                    "Unit number".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.unitNumberController,
                                      hintText: "Unit number",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        // return Validation.devicePostalCodeValidation(value);
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
                                      controller: controller.cityController,
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
                                      controller: controller.stateController,
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
                                      controller: controller.postalCodeController,
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
                                      controller: controller.countryController,
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


                                    "Device location*".toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      width: 340.w,
                                      controller: controller.deviceLocationController,
                                      hintText: "Device location",
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.deviceDeviceLocationValidation(value);
                                      },
                                    ),
                                    15.height,

                                    CustomButton(
                                        buttonName: btnSave,
                                        onPressed: () {
                                          if(formKey.currentState!.validate()) {
                                            Navigator.pushNamed(context,
                                                RouterHelper.setupGoodToGoScreen);
                                          }
                                        }).center
                                  ],
                                ).paddingSymmetric(horizontal: 25.w),
                              ),
                            )),
                      ),
                      Positioned(
                        top: 300.h,
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
                                          controller.countryController.text = component['long_name'];
                                        } else if (types.contains('locality')) {
                                          controller.cityController.text = component['long_name'];
                                        } else if (types.contains('administrative_area_level_1')) {
                                          controller.stateController.text = component['long_name'];
                                        } else if (types.contains('postal_code')) {
                                          controller.postalCodeController.text = component['long_name'];
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
