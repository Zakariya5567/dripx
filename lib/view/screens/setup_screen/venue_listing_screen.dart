import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/screens/home_screen/components/venue_data_list.dart';
import 'package:dripx/view/screens/home_screen/components/venue_listing_data_list.dart';
import 'package:dripx/view/screens/setup_screen/component/add_venue_dialoge.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/bottom_navigation.dart';

class VenuesListingScreen extends StatefulWidget {
  const VenuesListingScreen({Key? key}) : super(key: key);

  @override
  State<VenuesListingScreen> createState() => _VenuesListingScreenState();
}

class _VenuesListingScreenState extends State<VenuesListingScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool goToDevicesScreen = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<HomeProvider>(context, listen: false);
      controller.pageNumber = 1;
      controller.getVenues(context, false, controller.pageNumber);
      controller.venueListingScrollController.addListener(() {
        if (controller.venueListingScrollController.offset >= controller.venueListingScrollController.position.maxScrollExtent && !controller.venueListingScrollController.position.outOfRange) {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    goToDevicesScreen = ModalRoute.of(context)!.settings.arguments as bool;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: Consumer<HomeProvider>( builder: (context, controller, child) {
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
                      // CustomAppBar(title: "Venues", showAddIcon: true,),
                      SizedBox(
                        height: 840.h,
                        width: 390.w,
                        child: Column(
                          children: [
                            50.height,
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
                                "Venues"
                                    .toText(
                                    fontSize: 20,
                                    fontFamily: sofiaSemiBold,
                                    color: blackSecondary)
                                    .center,
                                IconButton(
                                  onPressed: () {
                                    addVenueDialoge(context: context, venueName: '', isEdit: false, venueID: '');
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: blackPrimary,
                                    size: 25.w,
                                  ),
                                )
                              ],
                            ),
                            controller.isVenueLoading
                              ? Expanded(
                                child: Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    70.height,
                                    const CircularProgressIndicator(),
                                  ],
                                )),
                              )
                              : controller.venueModel.venueData == null || controller.venueModel.venueData!.length == 0
                                ? Expanded(
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      70.height,
                                      "You have no venues".toText(
                                        fontSize: 16,
                                        color: blackDark,
                                        fontFamily: sofiaSemiBold
                                      ),
                                      10.height,
                                      CustomButton(
                                        buttonName: "Add Venue",
                                        onPressed: () {
                                          addVenueDialoge(context: context, venueName: '', isEdit: false, venueID: '');
                                        }
                                      )
                                    ],
                                  )),
                                )
                                : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () {
                                      controller.pageNumber = 1;
                                      // controller.getVenues(context, false);
                                      return controller.getVenues(context, false, controller.pageNumber);
                                    },
                                    child: SingleChildScrollView(
                                      controller: controller.venueListingScrollController,
                                      child: Column(
                                        children: [
                                          20.height,
                                          VenueListingDataList(
                                            controller,
                                            goToDevicesScreen
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
                                    ),
                                  ),
                                ),
                            10.height,
                            // controller.venueModel.venueData == null || controller.venueModel.venueData!.length == 0
                            //   ? Container()
                            //   : CustomButton(
                            //     buttonName: btnNext,
                            //     onPressed: () {
                            //
                            //     }
                            //   ),
                            // 10.height
                          ],
                        ).paddingSymmetric(horizontal: 20.w)
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