import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/data/model/authentication/auth_model.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:dripx/view/widgets/loader_dialog.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  String countryCode = '+1';

  bool isCouponLoading = false;
  String couponValidationText = '';
  String couponText = '';
  bool couponValidation = false;

  bool isNewPasswordVisible = true;
  bool isCurrentPasswordVisible = true;
  bool isConfirmNewPasswordVisible = true;

  File? profileImage;
  String? profileImageBase64;

  bool? isPhoneValid = true;
  String? phoneValidText;

  ApiRepo apiRepo = ApiRepo();

  //change new password visibility
  changeNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  //change confirm password visibility
  changeNewConfirmPasswordVisibility() {
    isConfirmNewPasswordVisible = !isConfirmNewPasswordVisible;
    notifyListeners();
  }

  //change current password password visibility
  changeCurrentPasswordVisibility() {
    isCurrentPasswordVisible = !isCurrentPasswordVisible;
    notifyListeners();
  }

  //confirm password validation
  confirmPasswordValidation(String value) {
    if (value.isEmpty) {
      return "Enter your password";
    } else if (confirmPasswordController.text != newPasswordController.text) {
      return "Password doesn't matched";
    }
  }


  // Phone text field validation
  phoneValidation(String value) {
    String pattern = r'^(?:[+0][1-15])?[0-15]{10}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      phoneValidText = "Enter Your Phone Number";
      isPhoneValid = false;
      notifyListeners();
      return "Enter Your Phone Number";
    } else if (value.length<10) {
      phoneValidText = "Enter Valid Phone Number";
      isPhoneValid = false;
      notifyListeners();
      return "Enter Valid Phone Number";
    } else {
      isPhoneValid = true;
      phoneValidText = null;
      notifyListeners();
    }
  }

  //update profile api
  bool isUpdateProfileLoading = false;
  updateProfile(BuildContext context, bool goToHomeScreen) async {
    String countryCodeValue = countryCode;
    countryCodeValue = countryCodeValue.replaceAll('+', '');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    profileImageBase64 = profileImage != null ? convertToBase64(profileImage!) : '';
    try{
      isUpdateProfileLoading = true;
      notifyListeners();
      dynamic data = {
        'name' : nameController.text,
        'country_code' : countryCodeValue,
        'phone_number' : phoneController.text,
        'country' : countryController.text,
        if(couponController.text!='') 'coupan' : couponController.text,
        if(profileImage!=null)'photo' : "data:image/jpeg;base64,${profileImageBase64}",
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.updateProfile, data, bearerToken: authProvider.authModel.token);
      isUpdateProfileLoading = false;
      notifyListeners();
      if(response.statusCode == 200) {
        debugPrint("Response is ${response.data}");
        authProvider.authModel.data!.name = nameController.text;
        authProvider.authModel.data!.countryCode = countryCode;
        authProvider.authModel.data!.phoneNumber = phoneController.text;
        authProvider.authModel.data!.photo = response.data['data']['photo'];
        await LocalDb.storeUser(authProvider.authModel);
        authProvider.getUserProfile(context);
        var value = await LocalDb.getUser();
        if(authProvider.goToProductScreen) {
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.productScreen, (Route<dynamic> route) => false);
          authProvider.goToProductScreen = false;
        } else {
          if(goToHomeScreen) {
            if(authProvider.authModel.data!.phoneNumber == "") {
              showToast(message: "Please enter your number to complete the profile");
            } else {
              Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
              showToast(message: "Your profile has been completed");
              LocalDb.storeUserCompleteProfileValue(false);
            }
          } else {
            showToast(message: "Your profile has been updated successfully");
          }
        }

        print(value);
        debugPrint("Response is ${response.data}");

      }
    }
    catch(e) {
      isUpdateProfileLoading = false;
      notifyListeners();
      print(e);
    }

  }

  //change password api
  bool isChangePasswordLoading = false;
  changePassword(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try{
      isChangePasswordLoading = true;
      notifyListeners();
      dynamic data = {
        'current_password' : oldPasswordController.text,
        'password' : newPasswordController.text,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.changePassword, data, bearerToken: authProvider.authModel.token);
      isChangePasswordLoading = false;
      notifyListeners();
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");

        if(response.data['success'] == true) {
          showToast(message: "Your password has been change successfully");
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          Navigator.pop(context);
        }
        else {
          showToast(message: response.statusMessage);
        }
      }
    }
    catch(e) {
      isChangePasswordLoading = false;
      notifyListeners();
      print(e);
    }

  }

  //Coupon verification
  couponVerification(BuildContext context) async {
    try{
      isCouponLoading = true;
      notifyListeners();
      dynamic data = {
        'coupan' : couponController.text,
        'email' : emailController.text,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.couponVerification, data);
      if(response.statusCode == 200) {
        isCouponLoading = false;
        debugPrint("Response is ${response.data}");
        if(response.data['success'] == true) {
          if(response.data['data']) {
            couponValidationText = '';
            couponText = couponController.text;
            couponValidation = false;
          }
          else {
            couponValidationText = 'Invalid coupon';
            couponValidation = true;
            notifyListeners();
          }
        }
        else {
          couponValidationText = 'Invalid coupon';
          couponValidation = true;
        }
        notifyListeners();
      }
    }
    catch(e) {
      couponValidationText = '';
      couponValidation = true;
      isCouponLoading = false;
      notifyListeners();
      print(e);
    }
  }

  //camera
  camera(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);
    profileImage = File(image!.path);
    notifyListeners();
  }

  //gallery
  gallery(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    profileImage = File(image!.path);
    notifyListeners();
  }

  //convert image into base 64
  convertToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

}
