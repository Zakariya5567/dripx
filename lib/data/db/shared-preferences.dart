import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static String bearerTokenKey = "BearerToken";
  static String isLoginKey = "isLogin";
  static String userEmailKey = "userEmail";
  static String userNameKey = "userName";
  static String userPhoneKey = "userName";
  static String userKey = "user";
  static String userIdKey = "userId";
  static String fcmTokenKey = "fcmToken";
  static String showTokenValue = "showTokenValue";
  static String notificationExpiryDialoge = "notificationExpiryDialoge";
  static String userCompleteProfileValue = "userCompleteProfileValue";
  static String productSelection = "productSelection";

  //=============================================================================

  // Store show container value
  static Future<void> storeShowCouponContainerValue(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setBool(showTokenValue, value);
  }

  //get show container value
  static Future<bool> getShowCouponContainerValue() async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    bool? value = sharedPreferences.getBool(showTokenValue)??false;
    return value;
  }

  // Set bearer token
  static Future<void> storeBearerToken(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setString(bearerTokenKey, value);
  }

  // Get bearer token
  static Future<String?> get getBearerToken async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(bearerTokenKey);
    return bearerToken;
  }

  //=============================================================================
  // Set FCM token
  static Future<void> storeFcmToken(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store fcm token in shared preferences
    sharedPreferences.setString(fcmTokenKey, value);
  }

  // Get FCM token
  static Future<String?> get getFcmToken async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the fcm token which we have stored in sharedPreferences before
    String? fcmToken = sharedPreferences.getString(fcmTokenKey);
    return fcmToken;
  }

  //=============================================================================
  // Set user is Login
  static Future<void> storeLogin(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store bearer token in shared preferences
    sharedPreferences.setBool(isLoginKey, value);
  }

  // Get user login Status
  static Future<bool?> get getLogin async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the bearer token which we have stored in sharedPreferences before
    bool? isLogin = sharedPreferences.getBool(isLoginKey);
    return isLogin;
  }

  //=============================================================================
  // Store email of user
  static Future<void> storeUserEmail(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store email in shared preferences
    sharedPreferences.setString(userEmailKey, value);
  }

  // Get user email
  static Future<String?> get getUserEmail async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the email which we have stored in sharedPreferences before
    String? userEmail = sharedPreferences.getString(userEmailKey);
    return userEmail;
  }

  //=============================================================================
  // Store Id of user
  static Future<void> storeUserId(int value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store user id in shared preferences
    sharedPreferences.setInt(userIdKey, value);
  }

  // Get user id
  static Future<int?> get getUserId async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the user id which we have stored in sharedPreferences before
    int? userId = sharedPreferences.getInt(userIdKey);
    return userId;
  }

  //=============================================================================
  // Store name of user
  static Future<void> storeUserName(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store name in shared preferences
    sharedPreferences.setString(userNameKey, value);
  }

  // Get user email
  static Future<String?> get getUserName async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the name which we have stored in sharedPreferences before
    String? userEmail = sharedPreferences.getString(userNameKey);
    return userEmail;
  }

  //=============================================================================
  // Store Phone number of user
  static Future<void> storeUserPhone(String value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store user phone number in shared preferences
    sharedPreferences.setString(userPhoneKey, value);
  }

  // Get user phone number
  static Future<String?> getUserPhone() async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the user phone number which we have stored in sharedPreferences before
    String? userEmail = sharedPreferences.getString(userPhoneKey);
    return userEmail;
  }

  //=============================================================================
  // Store product selection value
  static Future<void> storeProductSelection(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store product selection value
    sharedPreferences.setBool(productSelection, value);
  }

  // Get user phone number
  static Future<bool?> getProductSelection() async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get product selection value
    bool? productSelectionValue = sharedPreferences.getBool(productSelection)??false;
    return productSelectionValue;
  }

  //=============================================================================
  // Store user complete profile value
  static Future<void> storeUserCompleteProfileValue(bool value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store user phone number in shared preferences
    sharedPreferences.setBool(userCompleteProfileValue, value);
  }

  // Get user complete profile value
  static Future<bool> getUserCompleteProfileValue() async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store user phone number in shared preferences
    bool? value = sharedPreferences.getBool(userCompleteProfileValue)??false;
    return value;
  }


  //=============================================================================
  // Store user record
  static Future<void> storeUser(dynamic value) async {
    // initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Store user phone number in shared preferences
    sharedPreferences.setString(userKey, jsonEncode(value));
  }

  // Get user record
  static Future<dynamic?> getUser() async {
    // Initialized shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Get the user phone number which we have stored in sharedPreferences before
    var myData = sharedPreferences.getString(userKey);
    var token;
    if(myData != null) {
      token = jsonDecode(myData);
    }
    return token;
  }

  static clearSharedPreferenceValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
  }

}
