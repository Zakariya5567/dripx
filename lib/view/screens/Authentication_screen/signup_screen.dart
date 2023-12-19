import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/screens/Authentication_screen/components/apple_signin_section.dart';
import 'package:dripx/view/screens/Authentication_screen/components/logo_section.dart';
import 'package:dripx/view/screens/setup_screen/component/enable_alert_dialoge.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/validation.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'components/google_signin_section.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.countryCode = '+1';
    super.initState();
  }

  void _onCountryChange(CountryCode countryCode) {
    print("New Country selected: " + countryCode.toString());
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
                        image: Images.logoImage, title: signUpWithDripX),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.w, vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller.signUpNameController,
                              hintText: hintFullName,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return Validation.nameValidation(value);
                              },
                            ),
                            15.height,
                            CustomTextField(
                              controller: controller.signUpEmailController,
                              hintText: hintEmail,
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return Validation.emailValidation(value);
                              },
                            ),
                            15.height,
                            Container(
                              height: 50.h,
                              width: 330.w,
                              decoration: BoxDecoration(
                                  color: whiteLight,
                                  border: Border.all(
                                      color: controller.isPhoneValid == false
                                          ? redPrimary
                                          : whiteLight),
                                  borderRadius: borderRadiusCircular(30)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    //  color: Colors.red,
                                    width: 100.w,
                                    child: CountryCodePicker(
                                      padding: EdgeInsets.zero,
                                      onChanged: (value) {
                                        controller.countryCode = value.dialCode!;
                                        print(controller.countryCode);
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'US',

                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: blackDark,
                                          fontFamily: sofiaRegular),
                                    ),
                                  ),
                                  Container(
                                    width: 1.w,
                                    color: blackPrimary,
                                  ).paddingOnly(
                                      left: 0,
                                      right: 10.w,
                                      top: 10.h,
                                      bottom: 10.h),
                                  SizedBox(
                                    width: 200.w,
                                    height: 50,
                                    child: CustomTextField(
                                      controller: controller.signUpPhoneController,
                                      hintText: hintPhone,
                                      isBorder: false,
                                      inputFormatter: 15,
                                      textInputType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) {
                                        return controller.phoneValidation(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.height,
                            controller.isPhoneValid == false
                                ? controller.phoneValidText!
                                .toText(
                                fontSize: 12,
                                color: redPrimary,
                                fontFamily: sofiaRegular)
                                .paddingOnly(left: 16.w)
                                : const SizedBox(),
                            15.height,
                            CustomTextField(
                              controller: controller.signUpPasswordController,
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
                                if (value!.isEmpty) {
                                  return "Enter your password";
                                }
                                RegExp lowercaseRegex = RegExp(r'[a-z]');
                                RegExp uppercaseRegex = RegExp(r'[A-Z]');
                                RegExp numberRegex = RegExp(r'[0-9]');

                                bool hasLowercaseLetter = lowercaseRegex.hasMatch(value);
                                bool hasUppercaseLetter = uppercaseRegex.hasMatch(value);
                                bool hasNumber = numberRegex.hasMatch(value);

                                if(!hasLowercaseLetter) {
                                  return "Password must contain at least one lowercase letter.";
                                }
                                if(!hasUppercaseLetter) {
                                  return "Password must contain at least one uppercase letter.";
                                }
                                if(!hasNumber) {
                                  return "Password must contain at least one number.";
                                }
                                if (value.length < 8) {
                                  return "Password at least 8 Characters";
                                }

                              },
                            ),
                            15.height,
                            CustomTextField(
                              controller: controller.signUpConfirmPasswordController,
                              hintText: hintConfirmPassword,
                              isPassword: true,
                              isVisible: controller.isConfirmPassword,
                              obscureText: controller.isConfirmPassword,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onEyeTap: () {
                                controller.confirmPasswordVisibility();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your confirm password";
                                } else if (value != controller.signUpPasswordController.text) {
                                  return "Passwords must match";
                                }
                              },
                            ),

                            15.height,
                            CustomTextField(
                              controller: controller.couponController,
                              hintText: hintCoupon,
                              inputFormatter: 6,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                // RegExp(r'[A-Z0-9]{6}')
                              },
                              onChanged: (value) {
                                if(value!.length == 0) {
                                  controller.couponText = '';
                                  controller.couponValidationText = '';
                                  controller.couponValidation = false;
                                  controller.notifyListeners();
                                } else if(controller.signUpEmailController.text.isEmpty) {
                                  controller.couponValidationText = 'Please enter email first.';
                                  controller.couponValidation = true;
                                  controller.notifyListeners();
                                } else if(value.length == 6) {
                                  controller.couponText = '';
                                  controller.couponValidationText = '';
                                  controller.couponValidation = false;
                                  controller.notifyListeners();
                                  verifyCoupon(value, controller, controller.signUpEmailController.text);
                                } else {
                                  RegExp couponRegex = RegExp(r'[A-Z0-9]{6}');
                                  bool hasCoupon = couponRegex.hasMatch(value);
                                  if(!hasCoupon) {
                                    controller.couponValidationText = 'Coupon code must be 6 characters with capital letters and numbers only.';
                                    controller.couponValidation = true;
                                    controller.notifyListeners();
                                  }
                                }

                              },
                            ),
                            7.height,
                            controller.couponValidation
                              ? controller.couponValidationText.toText(color: redPrimary, maxLine: 2).paddingSymmetric(horizontal: 20.w)
                              : Container(),
                            20.height,
                            controller.isSignUpLoading ? const Center(child: CircularProgressIndicator(color: whitePrimary,),): CustomButton(
                              buttonName: btnSignUp,
                              onPressed: () async {
                                controller.phoneValidator();
                                print(controller.countryCode);
                                if (formKey.currentState!.validate()) {
                                  // controller.couponValidation = false;
                                  if(controller.couponValidation) {
                                    controller.couponController.clear();
                                    controller.couponText = '';
                                    controller.couponValidation = false;
                                    // Fluttertoast.showToast(msg: 'Please enter valid coupon');
                                  } else {
                                    controller.userSignUp(context);
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  }
                                }
                              },
                            ),
                            15.height,
                            GoogleSignInSection(false),
                            15.height,
                            Visibility(visible: Platform.isIOS, child: AppleSignInSection(true)),
                            Visibility(visible: Platform.isIOS, child: 18.height,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                alreadyHaveAnAccount.toText(
                                    fontSize: controller.isIpad ? 22 : 16,
                                    color: whitePrimary,
                                    fontFamily: sofiaLight),
                                btnSignIn
                                    .toText(
                                    fontSize: controller.isIpad ? 22 : 16,
                                    color: purplePrimary,
                                    fontFamily: sofiaRegular)
                                    .onPress(() {
                                  Navigator.pushNamed(
                                      context, RouterHelper.signInScreen);
                                })
                              ],
                            ),
                            20.height,
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
  verifyCoupon(String couponValue, AuthProvider controller, String email) async {
    await controller.couponVerification(context, email);
  }
}
