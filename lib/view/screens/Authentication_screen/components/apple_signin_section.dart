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

class AppleSignInSection extends StatelessWidget {
  bool signIn = false;
  AppleSignInSection(this.signIn);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isAppleUserSignIn ? const Center(child: CircularProgressIndicator(color: whitePrimary,),) : ButtonWithIcon(
      buttonName: btnContinueWithApple,
      icon: Images.iconApple,
      onPressed: () async {

        try{
          dynamic user = authProvider.signInWithApple(context);
          print("User is ${user}");
          print("Email is ${user.email}");
          print("name is ${user.givenName} ${user.familyName}");
          print("Authorization is ${user.authorizationCode}");
          print("Identity token is ${user.identityToken}");
        }
        catch(e) {
          print(e);
        }

        // showToast(message: "This will be available in next update.");
      },
      buttonColor: whitePrimary,
      borderColor: whitePrimary,
      buttonTextColor: blackPrimary,
    );
  }
}
