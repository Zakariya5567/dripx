import 'dart:io';
import 'package:dripx/view/screens/Authentication_screen/components/apple_signin_section.dart';
import 'package:dripx/view/screens/Authentication_screen/components/google_signin_section.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
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
import '../../../utils/style.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'components/logo_section.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            return Container(
              height: 844.h,
              width: 390.w,
              decoration: BoxDecoration(gradient: gradientBlue),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LogoSection(
                        image: Images.logoImage, title: signInWithDripX),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller.signInEmailController,
                              hintText: hintEmail,
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return Validation.emailValidation(value);
                              },
                            ),
                            17.height,
                            CustomTextField(
                              controller: controller.signInPasswordController,
                              hintText: hintPassword,
                              isPassword: true,
                              isVisible: controller.isVisible,
                              obscureText: controller.isVisible,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onEyeTap: () {
                                controller.passwordVisibility();
                              },
                              validator: (value) {
                                return Validation.passwordValidation(value);
                              },
                            ),
                            20.height,
                            textBtnForgotPassword
                                .toText(
                                fontSize: controller.isIpad ? 22 : 14,
                                color: whiteSecondary,
                                fontFamily: sofiaRegular)
                                .align(Alignment.centerRight)
                                .onPress(() {
                              controller.isVisible = true;
                              controller.notifyListeners();
                              Navigator.pushNamed(
                                  context, RouterHelper.forgotPasswordScreen);
                            }),
                            27.height,
                            controller.isSignInLoading ? const Center(child: CircularProgressIndicator(color: whitePrimary,),) : CustomButton(
                              buttonName: btnSignIn,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  controller.userSignIn(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                            ),
                            25.height,
                            GoogleSignInSection(true),
                            Visibility(visible: Platform.isIOS, child: 15.height),
                            Visibility(visible: Platform.isIOS, child: AppleSignInSection(true)),
                            15.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                doNotHaveAnAccount.toText(
                                    fontSize: controller.isIpad ? 22 : 16,
                                    color: whitePrimary,
                                    fontFamily: sofiaLight),
                                btnSignUp
                                  .toText(
                                    fontSize: controller.isIpad ? 22 : 16,
                                    color: purplePrimary,
                                    fontFamily: sofiaRegular)
                                    .onPress(() {
                                      controller.isVisible = true;
                                      controller.isPhoneValid = true;
                                      controller.signUpEmailController.clear();
                                      controller.signUpOtpController.clear();
                                      controller.signUpNameController.clear();
                                      controller.signUpPhoneController.clear();
                                      controller.signUpPasswordController.clear();
                                      controller.signUpConfirmPasswordController.clear();
                                      controller.couponController.clear();
                                      controller.countryCode = '+1';
                                      controller.couponText = '';
                                      controller.couponValidation = false;
                                      Navigator.pushNamed(context, RouterHelper.signUpScreen);
                                  }
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
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
