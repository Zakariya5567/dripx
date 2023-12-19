import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/images.dart';
import '../../../../utils/string.dart';
import '../../../../utils/style.dart';
import '../../../widgets/button_with_icon.dart';

class GoogleSignInSection extends StatelessWidget {
  bool signIn = false;
  GoogleSignInSection(this.signIn);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: whitePrimary,
                height: 1,
                width: 130.w,
              ),
              or
                  .toText(
                      fontSize: authProvider.isIpad ? 24 : 18, color: pinkLight, fontFamily: sofiaRegular)
                  .align(Alignment.topCenter)
                  .paddingSymmetric(horizontal: 10.w),
              Container(
                color: whitePrimary,
                height: 1,
                width: 130.w,
              ),
            ],
          ).paddingSymmetric(horizontal: 5.w),
        ),
        15.height,
        authProvider.isGoogleUserSignIn ? const Center(child: CircularProgressIndicator(color: whitePrimary,),) : ButtonWithIcon(
                buttonName: btnContinueWithGoogle,
                icon: Images.iconGoogle,
                onPressed: () async {

                  try{
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    var user = await googleSignIn.signIn();
                    print("user value is ${user}");
                    if(user!=null) {
                      await authProvider.googleUserSignIn(context, user.email, user.displayName!, user.id, user.photoUrl!, "google");
                    }
                    await googleSignIn.disconnect();
                  }
                  catch(e) {
                    print(e);
                  }

                  // showToast(message: "This will be available in next update.");
                },
                buttonColor: whitePrimary,
                borderColor: whitePrimary,
                buttonTextColor: blackPrimary,
              )
      ],
    );
  }
}
