import 'dart:io';
import 'package:dripx/view/screens/Authentication_screen/components/reset_logo_section.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_app_bar_auth.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/routes_helper.dart';
import '../../../helper/validation.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  //Scaffold key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: blueStatusBar(),
      child: SafeArea(
        key: scaffoldKey,
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: greenSecondary,
          body: Consumer<AuthProvider>(builder: (context, controller, child) {
            // controller.isLoading = false;
            return Container(
              height: 844.h,
              width: 390.w,
              decoration: BoxDecoration(gradient: gradientBlue),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    10.height,
                    CustomAppBarAuth(title: '', changeColor: true,),
                    ResetLogoSection(
                      image: Images.iconEmail,
                      title: "",
                      description: resetDescription,
                      iconColor: bluePrimary,
                      titleVisibility: false,
                      iconVisibility: true,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller.resetPasswordController,
                              hintText: hintEmail,
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return Validation.emailValidation(value);
                              },
                            ),
                            20.height,
                            controller.isResetPasswordLoading
                              ? const Center(child: CircularProgressIndicator(color: whitePrimary,),)
                              : CustomButton(
                                buttonName: btnResetPassword,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    controller.resetPassword(context, controller.resetPasswordController.text, true);
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
