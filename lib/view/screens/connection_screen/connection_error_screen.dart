import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/model/connection_model/connection_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/extention/border_extension.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionModel args =
    ModalRoute.of(context)!.settings.arguments as ConnectionModel;

    debugPrint("screen is : ${args.currentScreen}");
    debugPrint("message is : ${args.message}");

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        body: SizedBox(
          height: 896.h,
          width: 414.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 350.h,
                width: 350.h,
                child: Image.asset(
                  Images.connection,
                ),
              ),
              args.message.toText(
                  fontSize: 20, color: bluePrimary, fontFamily: sofiaBold),
              100.height,
              Container(
                height: 50.h,
                width: 120.h,
                decoration: BoxDecoration(
                    borderRadius: borderRadiusCircular(50),
                    border: borderAll(color: bluePrimary, width: 1),
                    color: whitePrimary),
                child: "Try Again"
                    .toText(
                    fontSize: 16,
                    color: bluePrimary,
                    fontFamily: sofiaRegular)
                    .center,
              ).onPress(() {
                Navigator.of(context).pop();
              })
            ],
          ).center,
        ),
      ),
    );
  }
}
