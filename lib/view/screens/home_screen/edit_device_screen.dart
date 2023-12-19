import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/screens/Authentication_screen/components/logo_section.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/validation.dart';
import '../../../provider/authentication_provider.dart';
import '../../../provider/home_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/blue_gradient.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/gradient_status_bar.dart';
import '../../widgets/white_gradient.dart';

class EditDeviceScreen extends StatefulWidget {
  const EditDeviceScreen({Key? key}) : super(key: key);

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // GoogleMapController? googleMapController;
  //
  // static const CameraPosition initialCameraPosition = CameraPosition(
  //     target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);
  //
  // Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // position();

    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  // Future<Position> position() async {
  //   Position position = await _determinePosition();
  //   googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //           target: LatLng(position.latitude, position.longitude), zoom: 14)));
  //
  //   setState(() {
  //     markers.clear();
  //   });
  //
  //   markers.add(Marker(
  //       markerId: const MarkerId('currentLocation'),
  //       position: LatLng(position.latitude, position.longitude)));
  //
  //   return position;
  // }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    DevicesData device = ModalRoute.of(context)!.settings.arguments as DevicesData;
    print(device);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>(builder: (context, controller, child) {
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
                      CustomAppBar(title: editDevice),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            140.height,
                            Row(
                              children: [
                                CustomImage(
                                    image: Images.iconCircuit,
                                    iconColor: bluePrimary,
                                    width: 43.w,
                                    height: 43.w),
                                12.width,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    device.macAddress!.toText(
                                        fontSize: 14,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    device.publicIp!.toText(
                                        fontSize: 12,
                                        fontFamily: sofiaSemiBold,
                                        color: greenHigh),
                                  ],
                                )
                              ],
                            ),
                            20.height,
                            deviceName.toText(
                                fontSize: 16,
                                fontFamily: sofiaSemiBold,
                                color: blackDark),
                            10.height,
                            CustomTextField(
                              height: 48.h,
                              width: 340.w,
                              controller: controller.deviceNameController,
                              hintText: hintDeviceName,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              radius: 8,
                              fillColor: whitePrimary,
                            ),
                            10.height,
                            "Unit Number".toText(
                                fontSize: 16,
                                fontFamily: sofiaSemiBold,
                                color: blackDark),
                            10.height,
                            CustomTextField(
                              height: 48.h,
                              width: 340.w,
                              controller: controller.unitNumberController,
                              hintText: hintAddress,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              radius: 8,
                              fillColor: whitePrimary,
                            ),
                            10.height,
                            location.toText(
                                fontSize: 16,
                                fontFamily: sofiaSemiBold,
                                color: blackDark),
                            10.height,
                            CustomTextField(
                              height: 48.h,
                              width: 340.w,
                              controller: controller.locationController,
                              hintText: "Location",
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              radius: 8,
                              fillColor: whitePrimary,
                            ),
                            // 14.height,
                            // Container(
                            //   height: 195.h,
                            //   width: 340.w,
                            //   decoration: BoxDecoration(
                            //       color: greyPrimary,
                            //       borderRadius: borderRadiusCircular(10)),
                            //   child: ClipRRect(
                            //     borderRadius: borderRadiusCircular(10),
                            //     child: GoogleMap(
                            //       initialCameraPosition: initialCameraPosition,
                            //       markers: markers,
                            //       zoomControlsEnabled: false,
                            //       mapType: MapType.normal,
                            //       onMapCreated:
                            //           (GoogleMapController controller) {
                            //         googleMapController = controller;
                            //       },
                            //     ),
                            //   ),
                            // ),
                            14.height,
                            controller.isUpdateDeviceLoading ? const Center(child: CircularProgressIndicator(),) :  CustomButton(
                                buttonName: btnSave,
                                onPressed: () async {
                                  await controller.updateDevice(context, device.macAddress!);
                                  Navigator.pop(context);
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  homeProvider.getDevices(context, '', 1.toString());
                                })
                                .center,
                            10.height,
                            CustomButton(
                                buttonName: btnCancel,
                                borderColor: skyBlueBorder,
                                buttonColor: whitePrimary,
                                buttonTextColor: bluePrimary,
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                                .center,
                          ],
                        ).paddingSymmetric(horizontal: 25.w),
                      )
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
