class ApiUrl {
  //BASE URl
  static String baseUrl = "https://staging-waterx.revolveai.com/api"; //staging url
  // static String baseUrl = "https://app.iottechnologies.io/api"; //Production url

  ///AUTHENTICATION APIS
  static String signUpUrl = "$baseUrl/auth/register";
  static String signInUrl = "$baseUrl/auth/login";
  static String getUserProfile = "$baseUrl/users/userProfile";
  static String couponVerification = "$baseUrl/coupon_valid";
  static String signInGoogleUrl = "$baseUrl/auth/login/google";
  static String signUpGoogleUrl = "$baseUrl/auth/register/google";
  static String changePassword = "$baseUrl/users/change_password";
  static String updateProfile = "$baseUrl/users/update";
  static String forgotPasswordUrl = "$baseUrl/auth/forgot-password";
  static String resendSignUpOtp = "$baseUrl/auth/resend-code";
  static String newPasswordUrl = "$baseUrl/auth/reset-password";
  static String otpVerification = "$baseUrl/auth/verify-code";
  static String signUpOtpVerification = "$baseUrl/auth/verify-user";
  static String logOutUrl = "$baseUrl/users/logout";
  static String deleteUserUrl = "$baseUrl/users/";

  ///VENUES APIS
  static String getVenues = "$baseUrl/venues";
  static String deleteVenue = "$baseUrl/venues";
  static String addVenues = "$baseUrl/venues/create";

  ///DEVICES APIS
  static String getDevices = "$baseUrl/devices?";
  static String updateDevice = "$baseUrl/devices/update-device/";
  static String deleteDevice = "$baseUrl/devices/";
  static String deviceRegister = "$baseUrl/devices";
  static String deviceCalibrationStart = "$baseUrl/device";
  static String deviceCalibration = "$baseUrl/device/calibration";
  static String wifiSwitching = "$baseUrl/device/";

  ///ALERTS APIS
  static String getAlert = "$baseUrl/alerts/search?";
  static String getAlertDetail = "$baseUrl/alerts/detail/";

  ///Notifications APIs
  static String getNotifications = "$baseUrl/notifications?";
  static String notificationRead = "$baseUrl/notifications/mark_as_read";

  ///SYSTEM CHECK API
  static String getSystemCheck = "$baseUrl/system/check";

  ///Get VERSIONS
  static String getVersions = "$baseUrl/setting/get_versions";

}