import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/widgets/extention/object_extension.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/connectivity_helper.dart';
import '../db/shared-preferences.dart';
import 'api_exception.dart';

class ApiRepo {
  /*
********** TimeOut ************
    sendTimeout: const Duration(milliseconds:300000),
    receiveTimeout: const Duration(milliseconds:300000),
     connectTimeout: const Duration(milliseconds: 300000),

******** For Error Response ***********
    receiveDataWhenStatusError: true,

********** Headers ************
    HttpHeaders.authorizationHeader : "Bearer $token"
    HttpHeaders.contentTypeHeader : "application/json"
    HttpHeaders.acceptEncodingHeader: "*"
*/

  // Dio Initialization
  Dio dio = Dio();

  // Set BaseOption for Api Request
  Future<void> dioOption({required Map<String, dynamic> headers}) async {
    try {
      dio.options = BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          receiveDataWhenStatusError: true,
          headers: headers);
    } catch (e) {
      "Error $e".printLog;
    }
  }

  // ======================================================================
  //POST REQUEST
  // Getting four parameters
  // context => use for loader and navigation
  // screen =>  router name
  // url => url of the api
  // Map data => json data for api

  postRequest(BuildContext navigatorContext, String screen, String url,
      Map<String, dynamic> data, {String? bearerToken, bool? formDataValue = true, CancelToken? cancelToken}) async {
    bool isConnected = await ConnectivityService.isConnected();
    if(!isConnected) {
      showToast(message: 'Please make sure you have active internet connection.');
      return '';
    }
    debugPrint(
        "Post Request=====================>>> \n URl : $url \n Sending data : $data");

    // Get the bearer token which we have stored in sharedPreferences before
    // String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // Convert json (Map) to form data
    var formData = FormData.fromMap(data);

    // calling dioOption method to set base options
    await dioOption(headers: {
      if(bearerToken!=null) HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.acceptEncodingHeader: "*",
    });

    try {
      // Calling Api
      final response = await dio.post(url, data: formData,);

      // return response back
      return response;
    } on DioError catch (exception) {
      // If Exception Occur calling dioError method to Handle the Exception
      // if(exception.response!.statusCode == 500) {
      //   showToast(message: "Internal Server Error");
      // }

      return dioError(exception, navigatorContext, screen);
    }
  }

  // ======================================================================
  // GET REQUEST
  getRequest(BuildContext navigatorContext, String screen, String url,
      {String? bearerToken, Map<String, dynamic>? data}) async {
    debugPrint(
        "Get Request=====================>>> \n URl : $url \n Sending data : $data");

    // Get the bearer token which we have stored in sharedPreferences before
    // String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // calling dioOption method to set base options
    await dioOption(headers: {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.acceptEncodingHeader: "*"
    });

    var response;
    try {
      // Calling Api

      if(data!=null) {
        response = await dio.get(url, queryParameters: data);
      }else {
        response = await dio.get(url,);
      }


      // return response back
      return response;
    } on DioError catch (exception) {
      response = exception;
      if(exception.message == "The request returned an invalid status code of 500.") {
        showToast(message: "Internal server error");
      }
      //If Exception Occur calling dioError method to Handle the Exception
      return response;
    }
  }

  // ======================================================================
  // PUT REQUEST
  putRequest(BuildContext navigatorContext, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint(
        "Put Request=====================>>> \n URl : $url \n Sending data : $data");

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // calling dioOption method to set base options
    await dioOption(headers: {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptEncodingHeader: "*"
    });

    try {
      // Calling Api
      final response = await dio.put(url, queryParameters: data);
      // return response back
      return response;
    } on DioError catch (exception) {
      // If Exception Occur calling dioError method to Handle the Exception
      if(exception.message == "The request returned an invalid status code of 500.") {
        showToast(message: "Internal server error");
      }
      return dioError(exception, navigatorContext, screen);
    }
  }

  // ======================================================================
  // DELETE REQUEST
  deleteRequest(BuildContext navigatorContext, String screen, String url,
      {String? bearerToken}) async {
    // debugPrint("Delete Request=====================>>> \n URl : $url \n Sending data : $data");

    // Get the bearer token which we have stored in sharedPreferences before
    // String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // calling dioOption method to set base options
    await dioOption(headers: {
      if(bearerToken!=null) HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      // HttpHeaders.acceptEncodingHeader: "*",
    });

    try {
      // Calling Api
      final response = await dio.delete(url);

      // return response back
      return response;
    } on DioError catch (exception) {
      // If Exception Occur calling dioError method to Handle the Exception
      return dioError(exception, navigatorContext, screen);
    }
  }

  // ======================================================================
  // POST MULTIPART REQUEST
  //POST MULTIPART REQUEST
  //When we are uploading Media  like (image,file,video,audio,etc)
  //then we are using multipart request

  multipartRequest(BuildContext navigatorContext, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint(
        "Multipart Request=====================>>> \n URl : $url \n Sending data : $data");

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // Convert json (Map) to form data
    var formData = FormData.fromMap(data);

    // calling dioOption method to set base options
    await dioOption(headers: {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "multipart/form-data",
      HttpHeaders.acceptEncodingHeader: "*"
    });

    try {
      // Calling Api
      final response = await dio.post(url, data: formData);

      // return response back
      return response;
    } on DioError catch (exception) {
      // If Exception Occur calling dioError method to Handle the Exception
      return dioError(exception, navigatorContext, screen);
    }
  }

  // ======================================================================
  // DOWNLOAD REQUEST
  downloadRequest(BuildContext navigatorContext, String screen, String url,
      String savePath) async {
    debugPrint("Download Request=====================>>> \n URl : $url");

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = await LocalDb.getBearerToken;
    debugPrint("Bearer token=====================>>>\n Token:$bearerToken");

    // calling dioOption method to set base options
    await dioOption(headers: {
      HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptEncodingHeader: "*"
    });

    int? percentage;
    try {
      // Calling Api
      final response = await Dio().download(
        url,
        savePath,
        onReceiveProgress: (rec, total) {
          // set progress to percentage variable
          percentage = ((rec / total) * 100).floor();
          "Percentage : $percentage".printLog;
        },
      );

      // return response back
      return response;
    } on DioError catch (exception) {
      // If Exception Occur calling dioError method to Handle the Exception
      return dioError(exception, navigatorContext, screen);
    }
  }

  // ======================================================================
  // Error Handling

  Future<dynamic> dioError(DioError exception, BuildContext navigatorContext, String screen) async {
    final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
    print(exception.error is SocketException);
    if(exception.response!.statusCode==422) {
      if(exception.response!.data['data'] == 'is_block') {
        const snackBar = SnackBar(
          content: Text('You have been logged out due to too many unauthorized attempts.',),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(AppKeys.mainNavigatorKey.currentState!.context).showSnackBar(snackBar);
        authProvider.logout(AppKeys.mainNavigatorKey.currentState!.context);
      }
      else {
        showToast(message: exception.response!.data['message']);
      }
    }
    else if(exception.response!.statusCode==404) {
      showToast(message: exception.response!.data['message']);
    }
    else if(exception.response!.statusCode==401) {
      showToast(message: exception.response!.data['message']);
    }
    else if(exception.type == DioErrorType.receiveTimeout) {
      showToast(message: 'Request timed out. You can retry or use fallback response.');
    }
    else if(exception.error is SocketException){
      showToast(message: 'Please check your internet connection.');
    }
    else if(exception.type == DioErrorType.receiveTimeout) {
      showToast(message: 'Request timed out. You can retry or use fallback response.');
    }
    else if(exception.error is SocketException){
      showToast(message: 'Please check your internet connection.');
    }
    else {
      showToast(message: '${exception.response!.data['message']}');
    }

    // if response is 400 OR 401 then we will return back API response otherwise we will navigate to  Error Screen
    // if (exception.type == DioErrorType.badResponse) {
    //   if (exception.response!.statusCode == 400 || exception.response!.statusCode == 401) {
    //     return exception.response;
    //   }
    // }
    // await Future.delayed(Duration.zero, () {
    //   apiException(exception, navigatorContext, screen);
    // });
  }
}