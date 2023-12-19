import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/widgets/custom_image.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/style.dart';
import '../../../widgets/extention/border_extension.dart';

class AlertList extends StatelessWidget {
  const AlertList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              height: 70.h,
              width: 340.w,
              decoration: BoxDecoration(
                  color: skyBlueSecondary,
                  boxShadow: const [
                    BoxShadow(
                        color: greyLight, offset: Offset(2, 1), blurRadius: 3)
                  ],
                  borderRadius: borderRadiusCircular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.h,
                        width: 240.w,
                        child: "Flap Open".toText(
                            fontSize: 16,
                            color: blackPrimary,
                            fontFamily: sofiaRegular),
                      ),
                      SizedBox(
                          height: 25.h,
                          width: 80.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomImage(
                                image: Images.iconTime,
                                iconColor: greyPrimary,
                                width: 10.w,
                                height: 10.w,
                              ),
                              5.width,
                              "16m ago".toText(
                                  fontSize: 10,
                                  color: blackLight,
                                  fontFamily: sofiaLight),
                            ],
                          ))
                    ],
                  ),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImage(
                        image: Images.iconLocation,
                        iconColor: greyPrimary,
                        width: 10.w,
                        height: 10.w,
                      ),
                      5.width,
                      SizedBox(
                        width: 240.w,
                        child: "od Tempor Invidunt Ut Labore Et Dolore".toText(
                            fontSize: 10,
                            color: blackLight,
                            fontFamily: sofiaLight),
                      )
                    ],
                  ),
                ],
              ).paddingOnly(top: 5.h, bottom: 5.h, left: 15.w, right: 5.w),
            ).onPress(() {
              Navigator.pushNamed(context, RouterHelper.alertDetailScreen);
            }).paddingSymmetric(vertical: 5.h);
          }),
    );
  }
}
