import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/screens/setup_screen/component/add_venue_dialoge.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/authentication_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
    required this.title,
    this.isBackEnable = true,
    this.changeColor = false,
    this.showAddIcon = false,
  }) : super(key: key);

  String title;
  bool isBackEnable;
  bool changeColor;
  bool showAddIcon;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Positioned(
      left: 0,
      top: 60.h,
      child: SizedBox(
        height: authProvider.isIpad ? 50.h : 40.h,
        width: 390.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBackEnable == true
                ? IconButton(
                    onPressed: () {Navigator.pop(context);},
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: blackPrimary,
                      size: authProvider.isIpad ? 15.w : 22.w,
                    ),
                  )
            // GestureDetector(
            //         onTap: () {
            //           Navigator.pop(context);
            //         },
            //         child: Container(
            //           color: Colors.green,
            //           child: Image.asset(
            //             Images.iconArrowBack,
            //             height: 22.w,
            //             width: 22.w,
            //             color: changeColor ? whitePrimary : blackSecondary,
            //           ),
            //         )
            //       )
                : SizedBox(
                    width: 20.w,
                  ),
            Container(
              width: 250.w,
              child: title
                  .toText(
                      fontSize: authProvider.isIpad ? 26 : 20,
                      fontFamily: sofiaSemiBold,
                      color: blackSecondary)
                  .center,
            ),
            // SizedBox(
            //   width: 20.w,
            // ),
            showAddIcon ? IconButton(
              onPressed: () {
                addVenueDialoge(context: context, venueName: '', isEdit: false, venueID: '');
              },
              icon: Icon(
                Icons.add,
                color: blackPrimary,
                size: authProvider.isIpad ? 15.w : 25.w,
              ),
            ) : Container(width: 25.w)
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }
}
