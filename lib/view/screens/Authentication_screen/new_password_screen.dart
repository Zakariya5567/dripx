import 'dart:async';
import 'dart:io';
import 'package:dripx/view/widgets/extention/int_extension.dart';
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
import 'components/reset_logo_section.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
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
    String? email = ModalRoute.of(context)!.settings.arguments as String?;
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
                    ResetLogoSection(
                      image: Images.iconLock,
                      title: enterNewPassword,
                      description: newPasswordDescription,
                      iconColor: redPrimary,
                      titleVisibility: true,
                      iconVisibility: false,
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
                              controller: controller.newPasswordController,
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
                              controller: controller.confirmPasswordController,
                              hintText: hintConfirmPassword,
                              isPassword: true,
                              isVisible: controller.isNewConfirmPasswordVisible,
                              obscureText: controller.isNewConfirmPasswordVisible,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onEyeTap: () {
                                controller.newConfirmPasswordVisibility();
                              },
                              validator: (value) {
                                return controller.confirmPasswordValidation(value!);
                              },
                            ),
                            20.height,
                            controller.isNewPasswordLoading ? const Center(child: CircularProgressIndicator(color: whitePrimary,),) :  CustomButton(
                              buttonName: btnContinue,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  controller.newPassword(context, email!);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                            ),
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
