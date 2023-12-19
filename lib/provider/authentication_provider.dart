import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dripx/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dripx/data/db/shared-preferences.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import '../data/model/authentication/auth_model.dart';
import '../data/repository/api_repo.dart';
import '../utils/api_url.dart';
import '../utils/app_keys.dart';
import '../view/screens/Authentication_screen/components/user_block_dialoge.dart';

class AuthProvider extends ChangeNotifier {

  String countryCode = '+1';
  String appVersion = '';
  ApiRepo apiRepo = ApiRepo();
  AuthModel authModel = AuthModel();

  bool isLimitLoading = false;
  bool goToProductScreen = false;

  bool isIpad = false;

  //Internet Connection variable

  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  String connectionStatus = 'Unknown';

  // Sign up controller
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPhoneController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  // Sign in Controller

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  // Reset password controller
  TextEditingController resetPasswordController = TextEditingController();

  // new password controller
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Otp controller
  TextEditingController otpController = TextEditingController();
  TextEditingController signUpOtpController = TextEditingController();

  bool isCouponLoading = false;
  bool hideNotificationExpiryDialoge = false;
  String couponValidationText = '';
  bool couponValidation = false;
  String couponText = '';

  bool isShowCouponContainer = false;

  bool isVisible = true;
  bool isNewConfirmPasswordVisible = true;
  bool isConfirmPassword = true;
  bool? isPhoneValid;
  String? phoneValidText;
  bool? otpReceived;
  String? deviceId;
  String? androidVersion;

  String? timeZoneValue = '';

  AuthProvider() {
    getDeviceID();
    getTimeZone();
  }

  getTimeZone() async {
    try {
      final String timezone = await FlutterNativeTimezone.getLocalTimezone();
      timeZoneValue = timezone;
      print('Current Timezone: $timezone');
    } catch (e) {
      print('Failed to get the current timezone: $e');
    }
  }

  //Get android device version and one signal player id
  getDeviceID() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      // deviceId = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      androidVersion = androidInfo.version.release;
      // deviceId = androidInfo.id;
    }
    var deviceState = await OneSignal.shared.getDeviceState();
    print("One signal player id is ${deviceState!.userId!}");
    deviceId = deviceState.userId!;
    print(deviceId);
  }

  //otp validation
  setOtpValidation(bool value) {
    otpReceived = value;
    notifyListeners();
  }

  //Password validation
  passwordVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  //Confirm Password validation
  confirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  //New Confirm Password validation
  newConfirmPasswordVisibility() {
    isNewConfirmPasswordVisible = !isNewConfirmPasswordVisible;
    notifyListeners();
  }

  //Phone validation
  phoneValidator() {
    if (signUpPhoneController.text.isEmpty) {
      phoneValidText = "Enter Your Phone Number";
      isPhoneValid = false;
      notifyListeners();
    } else {
      isPhoneValid = true;
      phoneValidText = null;
      notifyListeners();
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

  // confirm password  validation
  confirmPasswordValidation(String value) {
    if (value.isEmpty) {
      return "Enter your password";
    } else if (confirmPasswordController.text != newPasswordController.text) {
      return "Password doesn't matched";
    }
  }

  // Sign In User API
  bool isSignInLoading = false;
  userSignIn(BuildContext context) async {
    isSignInLoading = true;
    notifyListeners();
    await getDeviceID();
    try{

      print("Device UUID ${deviceId}");
      dynamic data = {
        'email' : signInEmailController.text,
        'password' : signInPasswordController.text,
        'device_uuid' : deviceId,
        'timezone' : timeZoneValue,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.signInUrl, data);
      if(response.statusCode == 200) {
        debugPrint("Response is ${response.data}");
        isSignInLoading = false;
        notifyListeners();
        if(response.data['success'] == true) {
          authModel = AuthModel.fromJson(response.data);
          // Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.productScreen, (Route<dynamic> route) => false);
          showToast(message: "You have successfully logged into DripX");
          debugPrint("Response is ${response.data}");
          LocalDb.storeUser(response.data);
          response.data['data']['couponExist'] == true && authModel.data!.coupon!.id == null ? isShowCouponContainer = true : isShowCouponContainer = false;
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          signInPasswordController.clear();
          signInEmailController.clear();
          isVisible = true;
        }else if(response.data['success'] == false && response.data['message'] == "Please verify your account") {
          authModel = AuthModel.fromJson(response.data);
          Navigator.pushNamed(context, RouterHelper.signUpOtpVerificationScreen, arguments: signInEmailController.text);
          showToast(message: response.data['message']);
          debugPrint("Response is ${response.data}");
          response.data['data']['couponExist'] == true && authModel.data!.coupon!.id == null ? isShowCouponContainer = true : isShowCouponContainer = false;
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          signInPasswordController.clear();
          signInEmailController.clear();
          isVisible = true;
        }else if(response.data['success'] == false && response.data['is_block'] == true) {
          userBlockDialoge(context: context,);
        }
        else {
          showToast(message: response.data['message']);
        }
      }
    }
    catch(e) {
      isSignInLoading = false;
      notifyListeners();
    }
  }

  //get user prrofile
  getUserProfile(BuildContext context) async {
    try{
      dynamic data = {
        '' : ''
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getUserProfile, data, bearerToken: authModel.token);
      if(response.statusCode == 200) {
        debugPrint("Response is ${response.data}");
        isSignInLoading = false;
        notifyListeners();
        if(response.data['success'] == true) {
          dynamic token = authModel.token;
          authModel = AuthModel.fromJson(response.data);
          authModel.token = token;
          LocalDb.storeUser(authModel);
          print(response.data['couponExist']);
          response.data['data']['couponExist'] == true && response.data['data']['coupon'] == null? isShowCouponContainer = true : isShowCouponContainer = false;
          notifyListeners();
        }
        else {
          showToast(message: response.data['message']);
        }
      }
    }
    catch(e) {
      notifyListeners();
    }
  }

  // Sign Up User API
  bool isSignUpLoading = false;
  userSignUp(BuildContext context) async {
    countryCode = countryCode.replaceAll('+', '');
    isSignUpLoading = true;
    notifyListeners();
    await getDeviceID();
    try{

      dynamic data = {
        'name' : signUpNameController.text,
        'email' : signUpEmailController.text,
        'password' : signUpPasswordController.text,
        'phone_number' : signUpPhoneController.text,
        'country_code' : countryCode,
        'coupon' : couponText,
        'timezone' : timeZoneValue,
        'device_uuid' : deviceId
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.signUpUrl, data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");
        isSignUpLoading = false;
        notifyListeners();
        if(response.data['success'] == true) {
          authModel = AuthModel.fromJson(response.data);
          Navigator.pushReplacementNamed(context, RouterHelper.signUpOtpVerificationScreen, arguments: signUpEmailController.text);
          showToast(message: response.data['message']);
          response.data['data']['couponExist'] == true && authModel.data!.coupon!.id == null ? isShowCouponContainer = true : isShowCouponContainer = false;
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          signUpOtpController.clear();
          signUpNameController.clear();
          signUpEmailController.clear();
          signUpPhoneController.clear();
          signUpPasswordController.clear();
          signUpConfirmPasswordController.clear();
        }
        else {
          showToast(message: response.data['message']);
        }
      }
    }
    catch(e) {
      isSignUpLoading = false;
      notifyListeners();
    }

  }


  // Sign in with apple
  Future<dynamic> signInWithApple (BuildContext context) async  {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]
    );

    if(credential.email!=null) {
      print("Email is present");
      print(credential.email);
      print(credential.givenName);
      print("Identity token ${credential.identityToken}");
      print("Authorization Code ${credential.authorizationCode}");
      await googleUserSignIn(context, credential.email!, "${credential.givenName} ${credential.familyName}", credential.userIdentifier!, '', "apple");
    } else {
      print("Email is not present");
      print(credential.email);
      print(credential.givenName);
      print(credential.userIdentifier);
      await googleUserSignIn(context, "", "", credential.userIdentifier!, '', "apple");
    }
    return credential;

    // final appleProvider = AppleAuthProvider();
    // return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  // Google Sign In through API
  bool isGoogleUserSignIn = false;
  googleUserSignIn(BuildContext context, String email, String name, String authCode, String photoUrl, String authType) async {
    authType == "apple" ? isAppleUserSignIn = true : isGoogleUserSignIn = true;
    notifyListeners();
    await getDeviceID();
    try{

      dynamic data = {
        if(name != '') 'displayName' : name,
        if(email != '') 'email' : email,
        'serverAuthCode' : authCode,
        'device_uuid' : deviceId,
        "auth_type" : authType,
        // 'photo' : photoUrl,
        'timezone' : timeZoneValue,
      };

      print("Send data to api is");
      print(data);

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.signInGoogleUrl, data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");
        authType == "apple" ? isAppleUserSignIn = false : isGoogleUserSignIn = false;
        notifyListeners();
        if(response.data['success'] == true) {
          print('apple id response is ');
          print('apple id response is ${response.data}');
          authModel = AuthModel.fromJson(response.data);
          response.data['couponExist'] == true && authModel.data!.coupon!.id == null ? isShowCouponContainer = true : isShowCouponContainer = false;
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          // authModel.data!.photo = photoUrl;
          LocalDb.storeUser(authModel);
          isVisible = true;
          if(authModel.data!.phoneNumber == "") {
            LocalDb.storeUserCompleteProfileValue(true);
            final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
            profileProvider.countryCode =  '+1';
            if(!profileProvider.countryCode.contains('+')) {
              profileProvider.countryCode = "+${profileProvider.countryCode}";
            }
            Navigator.pushNamedAndRemoveUntil(context, RouterHelper.profileScreen, (Route<dynamic> route) => false, arguments: true);
            showToast(message: "Please complete your profile.");
            goToProductScreen = true;
          }
          else {
            LocalDb.storeUserCompleteProfileValue(false);
            // Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
            Navigator.pushNamedAndRemoveUntil(context, RouterHelper.productScreen, (Route<dynamic> route) => false);
            showToast(message: "You have successfully logged into DripX.");
          }

        }
        else {
          showToast(message: response.data['message']);
        }
      }
    }
    catch(e) {
      authType == "apple" ? isAppleUserSignIn = false : isGoogleUserSignIn = false;
      notifyListeners();
    }

  }

  bool isAppleUserSignIn = false;
  appleUserSignIn(BuildContext context, String email, String name, String authCode, String photoUrl) async {
    print("Hitting api call");
    isAppleUserSignIn = true;
    notifyListeners();
    await getDeviceID();
    try{

      dynamic data = {
        if(name == '') 'displayName' : name,
        if(email == '') 'email' : email,
        'serverAuthCode' : authCode,
        'device_uuid' : deviceId,
        'auth_type' : "apple",
        // 'photo' : photoUrl,
        'timezone' : timeZoneValue,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.signInGoogleUrl, data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");
        isAppleUserSignIn = false;
        notifyListeners();
        if(response.data['success'] == true) {
          authModel = AuthModel.fromJson(response.data);
          response.data['couponExist'] == true && authModel.data!.coupon!.id == null ? isShowCouponContainer = true : isShowCouponContainer = false;
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          // authModel.data!.photo = photoUrl;
          LocalDb.storeUser(authModel);
          isVisible = true;
          if(authModel.data!.phoneNumber == "") {
            LocalDb.storeUserCompleteProfileValue(true);
            final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
            profileProvider.countryCode =  authModel.data!.countryCode!;
            if(!profileProvider.countryCode.contains('+')) {
              profileProvider.countryCode = "+${profileProvider.countryCode}";
            }
            Navigator.pushNamedAndRemoveUntil(context, RouterHelper.profileScreen, (Route<dynamic> route) => false, arguments: true);
            showToast(message: "Please complete your profile.");
            goToProductScreen = true;
          }
          else {
            LocalDb.storeUserCompleteProfileValue(false);
            Navigator.pushNamedAndRemoveUntil(context, RouterHelper.productScreen, (Route<dynamic> route) => false);
            // Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
            showToast(message: "You have successfully logged into DripX.");
          }

        }
        else {
          showToast(message: response.data['message']);
        }
      }
    }
    catch(e) {
      isAppleUserSignIn = false;
      notifyListeners();
    }

  }


  bool isSignUpOtpVerification = false;
  sigUpOtpVerification(BuildContext context, String email) async {
    isSignUpOtpVerification = true;
    notifyListeners();
    try{
      dynamic data = {
        'email' : email,
        'verification_otp' : signUpOtpController.text,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.signUpOtpVerification, data);
      isSignUpOtpVerification = false;
      notifyListeners();
      if(response.statusCode == 200) {
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          LocalDb.storeUser(authModel);
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.productScreen, (Route<dynamic> route) => false);
          // Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
          showToast(message: "You have successfully register into DripX");
          signUpOtpController.clear();
        } else {
          showToast(message: response.data['message']);
        }
      }
    } catch(e) {
      isSignUpOtpVerification = false;
      notifyListeners();
    }
  }

  // Forgot Password API
  bool isResetPasswordLoading = false;
  resetPassword(BuildContext context, String email, bool goToOtpVerificationScreen) async {

    isResetPasswordLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        'email' : email,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.forgotPasswordUrl, data);
      if(response.statusCode == 200) {
        isResetPasswordLoading = false;
        notifyListeners();
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          if(goToOtpVerificationScreen) {
            Navigator.pushNamed(context, RouterHelper.optVerificationScreen, arguments: email);
          }
          otpController.clear();
          resetPasswordController.clear();
          showToast(message: response.data['message']);
          notifyListeners();
        } else {
          if(response.data['message'] == "Something went wrong") {
            showToast(message: "This email doesn't exist.");
          } else {
            showToast(message: response.data['message']);
          }
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isResetPasswordLoading = false;
      notifyListeners();
    }
  }

  bool isResendSignUpOtp = false;
  resendSignUpOtp(BuildContext context, String email) async {

    isResetPasswordLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        'email' : email,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.resendSignUpOtp, data);
      if(response.statusCode == 200) {
        isResetPasswordLoading = false;
        notifyListeners();
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          signUpOtpController.clear();
          showToast(message: 'Otp resend successfully');
        } else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isResetPasswordLoading = false;
      notifyListeners();
    }
  }

  // New Password API
  bool isNewPasswordLoading = false;
  newPassword(BuildContext context, String email) async {
    isNewPasswordLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        'email' : email,
        'password' : newPasswordController.text,
        'password_confirmation' : confirmPasswordController.text,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.newPasswordUrl, data);
      isNewPasswordLoading = false;
      notifyListeners();
      if(response.statusCode == 200) {
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.signInScreen, (Route<dynamic> route) => false);
          showToast(message: response.data['message']);
          // Navigator.pop(context);
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else {
          showToast(message: response.data['message']);
        }

      }
    } catch(e) {
      isNewPasswordLoading = false;
      notifyListeners();
    }
  }

  // OTP Verification API
  bool isOtpVerification = false;
  otpVerification(BuildContext context, String email) async {
    isOtpVerification = true;
    notifyListeners();
    try{
      dynamic data = {
        'email' : email,
        'email_opt_in' : otpController.text,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.otpVerification, data);
      isOtpVerification = false;

      notifyListeners();
      if(response.statusCode == 200) {
        resetPasswordController.clear();
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          Navigator.pushNamed(context, RouterHelper.newPasswordScreen, arguments: email);
          showToast(message: response.data['message']);
          otpController.clear();
        } else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isOtpVerification = false;
      notifyListeners();
    }
  }

  bool isAddCouponValidation = false;
  submitCoupon(BuildContext context) async {
    try{
      isAddCouponValidation = true;
      notifyListeners();
      dynamic data = {
        'coupan': couponController.text
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.updateProfile, data, bearerToken: authModel.token);
      notifyListeners();
      if(response.statusCode == 200) {
        if(response.data['success']) {
          print(response.data);
          isAddCouponValidation = false;
          isShowCouponContainer = false;
          getUserProfile(context);
          LocalDb.storeShowCouponContainerValue(isShowCouponContainer);
          showToast(message: "Coupon has been added successfully");
          Navigator.pop(context);
          notifyListeners();
        } else {
          isAddCouponValidation = false;
          showToast(message: response.data['message']);
          notifyListeners();
        }
      }
    }
    catch(e) {
      isAddCouponValidation = false;
      Navigator.pop(context);
      notifyListeners();
    }

  }

  //Coupon verification
  couponVerification(BuildContext context, String email) async {
    try{
      isCouponLoading = true;
      notifyListeners();
      dynamic data = {
        'coupan' : couponController.text,
        'email' : email,
      };

      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.couponVerification, data);
      if(response.statusCode == 200) {
        isCouponLoading = false;
        debugPrint("Response is ${response.data}");
        if(response.data['success'] == true) {
          if(response.data['data']) {
            couponText = couponController.text;
            couponValidationText = '';
            couponValidation = false;
            notifyListeners();
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
        if(couponController.text == '') {
          couponText = '';
          couponValidation = false;
        }
        notifyListeners();
      }
    }
    catch(e) {
      couponValidationText = 'Invalid coupon';
      couponValidation = true;
      isCouponLoading = false;
      notifyListeners();
    }
  }

  //Delete User
  bool deleteUserLoading = false;
  deleteUser(BuildContext context,) async {
    print("url");
    print(ApiUrl.deleteUserUrl + authModel.data!.id!);
    try{
      deleteUserLoading = true;
      notifyListeners();

      Response response = await apiRepo.deleteRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deleteUserUrl + authModel.data!.id!, bearerToken: authModel.token!);
      if(response.statusCode == 200) {
        deleteUserLoading = false;
        debugPrint("Response is ${response.data}");
        if(response.data['success'] == true) {
          showToast(message: "Your account has been deleted successfully");
          await LocalDb.clearSharedPreferenceValue();
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.signInScreen, (route) => false);
        }
        else {
          showToast(message: response.data['message']);
        }
        notifyListeners();
      }
    }
    catch(e) {
      deleteUserLoading = false;
      notifyListeners();
    }
  }

  String? firmwareVersion;
  String? androidAppVersion = '';
  String? iosAppVersion = '';
  //Get versions
  getVersions(BuildContext context) async {

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getVersions);
      if(response.statusCode == 200 || response.statusCode == 201) {
        // debugPrint(response.data);
        firmwareVersion = response.data['data']['device_firmware_version'] == null ? "" : response.data['data']['device_firmware_version'].toString();
        androidAppVersion = response.data['data']['android_version'] == null ? "" : response.data['data']['android_version'].toString();
        iosAppVersion = response.data['data']['ios_version'] == null ? "" : response.data['data']['ios_version'].toString();
        debugPrint("Firmware Version: ${firmwareVersion}");
        debugPrint("Android App Version: ${androidAppVersion}");
        debugPrint("IOS App Version: ${iosAppVersion}");
        notifyListeners();
      }

    }
    catch(e) {
      notifyListeners();
      print(e);
    }
  }



  String formatTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final pacificTimeZone = tz.getLocation(timeZoneValue!);
    DateTime pacificCurrentDateTime = tz.TZDateTime.from(now, pacificTimeZone);
    final difference = pacificCurrentDateTime.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'sec' : 'secs'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hr' : 'hrs'} ${difference.inMinutes.remainder(60)} ${difference.inMinutes.remainder(60) == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // Logout
  logout(BuildContext context) async {
    await LocalDb.clearSharedPreferenceValue();
    Navigator.pushNamedAndRemoveUntil(context, RouterHelper.signInScreen, (route) => false);
  }

//=================================================================================
}
