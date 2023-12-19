import 'package:country_code_picker/country_code_picker.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/profile_provider.dart';
import 'package:dripx/view/screens/home_screen/components/logout_dialoge.dart';
import 'package:dripx/view/screens/profile_screen/components/delete_account_dialoge.dart';
import 'package:dripx/view/screens/profile_screen/components/image_picker.dart';
import 'package:dripx/view/widgets/blue_gradient.dart';
import 'package:dripx/view/widgets/custom_button.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:dripx/view/widgets/gradient_status_bar.dart';
import 'package:dripx/view/widgets/shimmer_image.dart';
import 'package:dripx/view/widgets/white_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final controller = Provider.of<ProfileProvider>(context, listen: false);
    controller.nameController.text = authProvider.authModel.data!.name!;
    controller.emailController.text = authProvider.authModel.data!.email!;
    controller.phoneController.text = authProvider.authModel.data!.phoneNumber!;
    controller.countryController.text = authProvider.authModel.data!.countryCode!;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var controller = Provider.of<ProfileProvider>(context, listen: false);
    controller.profileImage = null;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool? goToHomeScreen = ModalRoute.of(context)!.settings.arguments as bool?;
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
                      SizedBox(
                          height: 840.h,
                          width: 390.w,
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  40.height,
                                  goToHomeScreen!
                                    ? Container()
                                    : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {Navigator.pop(context);},
                                          icon: Icon(
                                            Icons.arrow_back_ios_new,
                                            color: blackPrimary,
                                            size: 22.w,
                                          ),
                                        ),
                                        profile.toText(color: blackPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                                        SizedBox(width: 30.w,)
                                      ],
                                    ),
                                  10.height,
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100.w),
                                        // height: 100.w,
                                        // width: 100.w,
                                        // decoration: BoxDecoration(
                                        //   color: greenProfile,
                                        //   shape: BoxShape.circle,
                                        //   image: controller.profileImage == null && authProvider.authModel.data!.photo == ''
                                        //     ? const DecorationImage(image: AssetImage(Images.profileImage), fit: BoxFit.cover)
                                        //     : controller.profileImage != null
                                        //       ? DecorationImage(image: FileImage(controller.profileImage!,), fit: BoxFit.cover)
                                        //       : DecorationImage(image: NetworkImage(authProvider.authModel.data!.photo!), fit: BoxFit.cover,),
                                        //
                                        // ),
                                        child: controller.profileImage == null && (authProvider.authModel.data!.photo == null || authProvider.authModel.data!.photo == '')
                                          ? Image.asset(Images.profileImage, fit: BoxFit.cover,height: 100.w, width: 100.w,)
                                          : controller.profileImage != null
                                            ? Image.file(controller.profileImage!, fit: BoxFit.cover,height: 100.w, width: 100.w,)
                                            : ShimmerImage(imageUrl: authProvider.authModel.data!.photo!, width: 100.w, height: 100.w)
                                        // Image.network(authProvider.authModel.data!.photo!,
                                        //       height: 100.w, width: 100.w,
                                        //       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        //         if (loadingProgress == null) return child;
                                        //         return Center(
                                        //           child: Container(
                                        //             width: 50.w,height: 50.w,
                                        //             child: CircularProgressIndicator(
                                        //               color: bluePrimary,
                                        //               value: loadingProgress.expectedTotalBytes != null
                                        //                   ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        //                   : null,
                                        //             ),
                                        //           ),
                                        //         );
                                        //       },
                                        //       // placeholder: const AssetImage(Images.loading),
                                        //       // image: NetworkImage(authProvider.authModel.data!.photo!),
                                        //       fit: BoxFit.cover,
                                        //       errorBuilder: (BuildContext context, var child, var loadingProgress) {
                                        //         return Image.asset(Images.profileImage, fit: BoxFit.cover,height: 100.w, width: 100.w,);
                                        //       },
                                        //
                                        // ),

                                      ).center,
                                      Positioned(
                                        bottom: -3,
                                        left: 175.w,
                                        child: InkWell(
                                          onTap: () async {
                                            await showImagePicker(context: context);
                                            controller.notifyListeners();
                                          },
                                          child: CircleAvatar(
                                            radius: 18.w,
                                            backgroundColor: bluePrimary,
                                            child: Image.asset(
                                                Images.iconCamera,
                                                height: 18.w,
                                                width: 18.w),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  43.height,
                                  CustomTextField(
                                    height: 70.h,
                                    width: 340.w,
                                    controller: controller.nameController,
                                    hintText: "Profile name",
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    radius: 8,
                                    fillColor: whitePrimary,
                                    iconColor: bluePrimary,
                                    validator: (name) {
                                      if(name!.length == 0) {
                                        return 'Please enter name.';
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                  ),
                                  5.height,
                                  CustomTextField(
                                    height: 70.h,
                                    width: 340.w,
                                    controller: controller.emailController,
                                    hintText: hintProfileEmail,
                                    textInputType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    radius: 8,
                                    isReadOnly: true,
                                    fillColor: whitePrimary,
                                  ),
                                  5.height,
                                  CustomTextField(
                                    height: 70.h,
                                    width: 340.w,
                                    isReadOnly: true,
                                    controller: controller.passwordController,
                                    hintText: "*********",
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    radius: 8,
                                    fillColor: whitePrimary,
                                    iconColor: bluePrimary,
                                    onTap: () {
                                      controller.isCurrentPasswordVisible = true;
                                      controller.isConfirmNewPasswordVisible = true;
                                      controller.isNewPasswordVisible = true;
                                      controller.oldPasswordController.clear();
                                      controller.newPasswordController.clear();
                                      controller.confirmPasswordController.clear();
                                      Navigator.pushNamed(context, RouterHelper.createNewPasswordScreen);
                                    },
                                  ),
                                  10.height,
                                  personalInformation
                                      .toText(
                                      fontSize: 20,
                                      fontFamily: sofiaSemiBold,
                                      color: blackDark)
                                      .center,
                                  20.height,
                                  // "Phone number*".toText(
                                  //     fontSize: 16,
                                  //     fontFamily: sofiaSemiBold,
                                  //     color: blackDark),
                                  // 10.height,
                                  // CustomTextField(
                                  //   height: 70.h,
                                  //   width: 340.w,
                                  //   controller: controller.phoneController,
                                  //   hintText: hintProfilePhone,
                                  //   textInputType: TextInputType.phone,
                                  //   textInputAction: TextInputAction.next,
                                  //   validator: (phone) {
                                  //     if(phone!.length == 0) {
                                  //       return 'Please enter phone number.';
                                  //     }
                                  //     else {
                                  //       return null;
                                  //     }
                                  //   },
                                  //   radius: 8,
                                  //   fillColor: whitePrimary,
                                  // ),
                                  // 5.height,
                                  // "Country code*".toText(
                                  //     fontSize: 16,
                                  //     fontFamily: sofiaSemiBold,
                                  //     color: blackDark),
                                  // 10.height,
                                  // CustomTextField(
                                  //   height: 70.h,
                                  //   width: 340.w,
                                  //   controller: controller.countryController,
                                  //   hintText: hintProfileCountry,
                                  //   textInputType: TextInputType.text,
                                  //   textInputAction: TextInputAction.done,
                                  //   radius: 8,
                                  //   fillColor: whitePrimary,
                                  //   validator: (countryCode) {
                                  //     if(countryCode!.length == 0) {
                                  //       return 'Please enter country code.';
                                  //     }
                                  //     else {
                                  //       return null;
                                  //     }
                                  //   },
                                  // ),
                                  // 15.height,
                                  "Phone number*".toText(
                                    fontSize: 16,
                                    fontFamily: sofiaSemiBold,
                                    color: blackDark
                                  ),
                                  10.height,
                                  Container(
                                    height: 50.h,
                                    width: 330.w,
                                    decoration: BoxDecoration(
                                      color: whitePrimary,
                                      border: Border.all(
                                          color: greyLight
                                      ),
                                      borderRadius: borderRadiusCircular(8)
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          //  color: Colors.red,
                                          width: 100.w,
                                          child: CountryCodePicker(
                                            padding: EdgeInsets.zero,
                                            onChanged: (value) {
                                              controller.countryCode = value.dialCode!;
                                              print(controller.countryCode);
                                              print(value.name);
                                            },
                                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                            initialSelection: controller.countryCode == "+1" ? "US" : controller.countryCode,
                                            backgroundColor: whitePrimary,
                                            // optional. Shows only country name and flag
                                            showCountryOnly: false,
                                            // optional. Shows only country name and flag when popup is closed.
                                            showOnlyCountryWhenClosed: false,
                                            // optional. aligns the flag and the Text left
                                            alignLeft: false,

                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: blackDark,
                                              fontFamily: sofiaRegular
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1.w,
                                          color: blackPrimary,
                                        ).paddingOnly(
                                          left: 0,
                                          right: 10.w,
                                          top: 10.h,
                                          bottom: 10.h
                                        ),
                                        SizedBox(
                                          width: 200.w,
                                          height: 50,
                                          child: CustomTextField(
                                            controller: controller.phoneController,
                                            hintText: hintPhone,
                                            isBorder: false,
                                            inputFormatter: 15,
                                            fillColor: whitePrimary,
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
                                    ? controller.phoneValidText == null
                                      ? ''.toText(
                                        fontSize: 12,
                                        color: redPrimary,
                                        fontFamily: sofiaRegular
                                      ).paddingOnly(left: 16.w)
                                      : controller.phoneValidText!
                                      .toText(
                                        fontSize: 12,
                                        color: redPrimary,
                                        fontFamily: sofiaRegular
                                      ).paddingOnly(left: 16.w)
                                      : const SizedBox(),

                                  15.height,
                                  "Coupon".toText(
                                      fontSize: 16,
                                      fontFamily: sofiaSemiBold,
                                      color: blackDark),
                                  10.height,
                                  CustomTextField(
                                    height: 55.h,
                                    width: 340.w,
                                    controller: controller.couponController,
                                    hintText: "Coupon",
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    radius: 8,
                                    fillColor: whitePrimary,
                                    iconColor: bluePrimary,
                                    validator: (value) {
                                      // RegExp(r'[A-Z0-9]{6}')
                                    },
                                    onChanged: (value) {
                                      if(value!.length == 0) {
                                        controller.couponText = '';
                                        controller.couponValidationText = '';
                                        controller.couponValidation = false;
                                        controller.notifyListeners();
                                      }
                                      else if(controller.emailController.text.isEmpty) {
                                        controller.couponValidationText = 'Please enter email first.';
                                        controller.couponValidation = true;
                                        controller.notifyListeners();
                                      }
                                      else if(value.length == 6) {
                                        controller.couponText = '';
                                        controller.couponValidationText = '';
                                        controller.couponValidation = false;
                                        controller.notifyListeners();
                                        verifyCoupon(value, controller,);
                                      }
                                      else {
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
                                  controller.couponValidation
                                    ? controller.couponValidationText.toText(color: redPrimary, maxLine: 2)
                                    : Container(),


                                  // 15.height,
                                  //
                                  // CustomTextField(
                                  //   height: 48.h,
                                  //   width: 340.w,
                                  //   controller: controller.couponController,
                                  //   hintText: hintCoupon,
                                  //   textInputType: TextInputType.text,
                                  //   textInputAction: TextInputAction.done,
                                  //   radius: 8,
                                  //   fillColor: whitePrimary,
                                  //   onChanged: (value) {
                                  //     if(value!.length>5) {
                                  //       verifyCoupon(value, controller);
                                  //     }
                                  //     else {
                                  //       controller.couponText = '';
                                  //       controller.couponValidation = false;
                                  //       controller.notifyListeners();
                                  //     }
                                  //   },
                                  // ),
                                  // 7.height,
                                  // controller.couponValidation
                                  //   ? controller.couponValidationText.toText(color: redPrimary)
                                  //   : Container(),
                                  15.height,
                                  controller.isUpdateProfileLoading ? const Center(child: CircularProgressIndicator(),) : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      goToHomeScreen
                                        ? Container()
                                        : CustomButton(
                                          height: 40.h,
                                          width: 162.h,
                                          buttonColor: whitePrimary,
                                          buttonTextColor: bluePrimary,
                                          borderColor: bluePrimary,
                                          buttonName: btnCancel,
                                          onPressed: () {Navigator.pop(context);}
                                      ),
                                      CustomButton(
                                        height: 40.h,
                                        width: goToHomeScreen ? 318.w : 162.h,
                                        buttonName: btnSave,
                                        onPressed: () {
                                          if(formKey.currentState!.validate()) {
                                            print(controller.isPhoneValid);
                                            if(controller.isPhoneValid!) {

                                              if(controller.couponValidation) {
                                                controller.couponController.clear();
                                                controller.couponText = '';
                                                controller.couponValidation = false;
                                                controller.notifyListeners();
                                                // Fluttertoast.showToast(msg: 'Please enter valid coupon');
                                              } else {
                                                FocusManager.instance.primaryFocus!.unfocus();
                                                controller.updateProfile(context, goToHomeScreen);
                                              }
                                            }
                                            else {
                                              controller.isPhoneValid = false;
                                              controller.phoneValidText = "Enter valid phone number.";
                                              controller.notifyListeners();
                                            }
                                          }
                                        }
                                      ),
                                    ],
                                  ),
                                  10.height,
                                  goToHomeScreen
                                    ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(),
                                        CustomButton(
                                          height: 40.h,
                                          width: 318.w,
                                          buttonColor: whitePrimary,
                                          buttonTextColor: bluePrimary,
                                          borderColor: bluePrimary,
                                          buttonName: btnLogout,
                                          onPressed: () {logoutDialog(context: context);}
                                        )
                                      ],
                                    )
                                    : Container(),
                                  10.height,
                                  CustomButton(
                                    height: 40.h,
                                    buttonColor: redPrimary,
                                    buttonTextColor: whitePrimary,
                                    borderColor: redPrimary,
                                    buttonName: btnDeleteYourAccount,
                                    onPressed: () {
                                      deleteAccountDialog(context: context);
                                    }
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 20.w),
                            ),
                          )).paddingSymmetric(horizontal: 10),
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

  verifyCoupon(String couponValue, ProfileProvider controller) async {
    await controller.couponVerification(context);
  }

}