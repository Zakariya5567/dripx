// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// import 'api_exception.dart';
//
// class FirebaseRepo {
//   static Future<String?> getFcmToken(
//       NavigatorState navigator, String screen) async {
//     String? fcmToken;
//     try {
//       await FirebaseMessaging.instance.getToken().then((token) async {
//         fcmToken = token;
//       });
//     } on DioError catch (exception) {
//       await Future.delayed(Duration.zero, () {
//         apiException(exception, navigator, screen);
//       });
//     }
//     return fcmToken;
//   }
// }
