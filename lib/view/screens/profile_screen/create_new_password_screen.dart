import 'package:dripx/helper/validation.dart';
import 'package:dripx/provider/alert_provider.dart';
import 'package:dripx/view/screens/alert_screen/components/alert_list.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../provider/profile_provider.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_text_field.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        body: Consumer<ProfileProvider>(builder: (context, controller, child) {
          return SizedBox(
            height: 844.h,
            width: 390.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const GradientStatusBar(),
                      const BlueGradient(),
                      const WhiteGradient(),
                      CustomAppBar(title: "Update Password"),
                      SizedBox(
                              height: 840.h,
                              width: 390.w,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    160.height,
                                    currentPassword.toText(
                                        fontSize: 16,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      obscureText: controller.isCurrentPasswordVisible,
                                      isVisible: controller.isCurrentPasswordVisible,
                                      isPassword: true,
                                      controller:
                                          controller.oldPasswordController,
                                      hintText: hintCurrentPassword,
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return Validation.passwordValidation(
                                            value);
                                      },
                                      onEyeTap: () {
                                        controller.changeCurrentPasswordVisibility();
                                      },
                                    ),
                                    15.height,
                                    newPassword.toText(
                                        fontSize: 16,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      obscureText: controller.isNewPasswordVisible,
                                      isVisible: controller.isNewPasswordVisible,
                                      isPassword: true,
                                      controller: controller.newPasswordController,
                                      hintText: hintNewPassword,
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter your password";
                                        } else if (value!.length < 8) {
                                          return "Password at least 8 Characters";
                                        } else if(controller.newPasswordController.text == controller.oldPasswordController.text) {
                                          return 'New password must be different from current password';
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
                                      onEyeTap: () {
                                        controller.changeNewPasswordVisibility();
                                      },
                                    ),
                                    15.height,
                                    confirmPassword.toText(
                                        fontSize: 16,
                                        fontFamily: sofiaSemiBold,
                                        color: blackDark),
                                    10.height,
                                    CustomTextField(
                                      obscureText: controller.isConfirmNewPasswordVisible,
                                      isVisible: controller.isConfirmNewPasswordVisible,
                                      isPassword: true,
                                      controller: controller.confirmPasswordController,
                                      hintText: hintConfirmPassword,
                                      textInputType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      radius: 8,
                                      fillColor: whitePrimary,
                                      validator: (value) {
                                        return controller.confirmPasswordValidation(value!);
                                      },
                                      onEyeTap: () {
                                        controller.changeNewConfirmPasswordVisibility();
                                      },
                                    ),
                                    230.height,
                                    controller.isChangePasswordLoading ? const Center(child: CircularProgressIndicator(),) :  CustomButton(
                                        buttonName: btnChangePassword,
                                        onPressed: () {
                                          if(formKey.currentState!.validate()) {
                                            controller.changePassword(context);
                                          }
                                        }),
                                    15.height,
                                    CustomButton(
                                        buttonColor: whitePrimary,
                                        buttonName: btnCancel,
                                        buttonTextColor: bluePrimary,
                                        borderColor: skyBlueBorder,
                                        onPressed: () {Navigator.pop(context);})
                                  ],
                                ).paddingSymmetric(horizontal: 20.w),
                              ))
                          .paddingSymmetric(horizontal: 10),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
