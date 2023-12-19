import 'package:dripx/provider/alert_provider.dart';
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
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../provider/setup_provider.dart';
import '../../../utils/string.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/extention/border_extension.dart';

class SetupLocationScreen extends StatefulWidget {
  const SetupLocationScreen({Key? key}) : super(key: key);

  @override
  State<SetupLocationScreen> createState() => _SetupLocationScreenState();
}

class _SetupLocationScreenState extends State<SetupLocationScreen> {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<SetupProvider>(builder: (context, controller, child) {
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

                      SizedBox(
                          height: 840.h,
                          width: 390.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              60.height,
                              IconButton(
                                onPressed: () {Navigator.pop(context);},
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: blackPrimary,
                                  size: 22.w,
                                ),
                              ),
                              Image.asset(
                                Images.deviceImageNew,
                                height: 250.h,
                                width: 340,
                              ),
                              15.height,
                              location.toText(
                                  fontSize: 14,
                                  fontFamily: sofiaSemiBold,
                                  color: blackDark),
                              10.height,
                              CustomTextField(
                                height: 42.h,
                                width: 340.w,
                                controller: controller.locationController,
                                hintText: hintCurrentLocation,
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                radius: 8,
                                fillColor: whitePrimary,
                              ),
                              // 20.height,
                              // Container(
                              //   height: 195.h,
                              //   width: 340.w,
                              //   decoration: BoxDecoration(
                              //       color: greyPrimary,
                              //       borderRadius: borderRadiusCircular(10)),
                              //   child: ClipRRect(
                              //     borderRadius: borderRadiusCircular(10),
                              //     child: GoogleMap(
                              //       initialCameraPosition:
                              //           initialCameraPosition,
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
                              20.height,
                              CustomButton(
                                  buttonName: btnContinue,
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        RouterHelper.setupGoodToGoScreen);
                                  }).center,
                              10.height,
                              CustomButton(
                                      buttonName: btnSkip,
                                      borderColor: skyBlueBorder,
                                      buttonColor: whitePrimary,
                                      buttonTextColor: bluePrimary,
                                      onPressed: () {
                                        Navigator.pushNamed(context, RouterHelper.setupGoodToGoScreen);
                                      })
                                  .center,
                            ],
                          ).paddingSymmetric(horizontal: 25.w))
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
