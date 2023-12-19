import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/db/shared-preferences.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/colors.dart';
import '../../widgets/show_toast.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, String>> products = [
    {
      'title': 'DripX',
      'image': 'assets/images/img_logo.png',
    },
    {
      'title': 'PipeX',
      'image': 'assets/products_image/pipex.png',
    },
    {
      'title': 'PoolX',
      'image': 'assets/products_image/poolx.png',
    },
    {
      'title': 'SolarX',
      'image': 'assets/products_image/solarx.png',
    },
    {
      'title': 'DustX',
      'image': 'assets/products_image/dustx.png',
    },
    {
      'title': 'TrapX',
      'image': 'assets/products_image/trapx.png',
    },
    {
      'title': 'SafeX',
      'image': 'assets/products_image/safex.png',
    },
    {
      'title': 'AromaX',
      'image': 'assets/products_image/aromax.png',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: Scaffold(
        backgroundColor: whitePrimary,
        body: SizedBox(
          height: 844.h,
          width: 390.w,
          child: Column(
            children: [
              Stack(
                children: [
                  const GradientStatusBar(),
                  const BlueGradient(),
                  const WhiteGradient(),
                  CustomAppBar(title: "Products", isBackEnable: false),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      120.height,
                      Container(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 30.w,
                          runSpacing: 20.h,
                          children: [
                            ...products.asMap().entries.map((e) => InkWell(
                              onTap: () {
                                print(e.value);
                                print(e.key);
                                switch (e.key) {
                                  case 0:
                                    Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
                                    LocalDb.storeProductSelection(true);
                                    break;
                                  default:
                                    showToast(message: "Will be available in next release.");
                                    break;
                                }

                                // Add your action when the icon is tapped
                                // For example, you can show a dialog or navigate to a new screen.
                              },
                              splashColor: bluePrimary,
                              child: Container(
                                height: 145.h,
                                width: 135.w,
                                decoration: BoxDecoration(
                                  color: whitePrimary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      spreadRadius: 3, // Spread radius
                                      blurRadius: 5, // Blur radius
                                      offset: const Offset(0, 2), // Offset from top
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    e.key == 0
                                        ? Image.asset(e.value['image']!, color: bluePrimary, height: 30.w, width: 30.w, fit: BoxFit.cover,)
                                        : Image.asset(e.value['image']!, height: 30.w, width: 30.w, fit: BoxFit.cover,),
                                    15.height,
                                    e.value['title']!.toText(fontSize: 15),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      20.height,
                    ],
                  ).paddingSymmetric(horizontal: 15.w)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
