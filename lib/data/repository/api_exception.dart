import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../helper/routes_helper.dart';
import '../model/connection_model/connection_model.dart';

void apiException(DioError exception, BuildContext navigatorContext, String screen) {
  ConnectionModel? connectionModel;

  void navigateToNoConnectionScreen() {
    Navigator.of(navigatorContext).pushReplacementNamed(
      RouterHelper.noConnectionScreen,
      arguments: connectionModel,
    );
  }

  switch (exception.type) {
    case DioErrorType.connectionError:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Check your internet connection",
      );
      navigateToNoConnectionScreen();
      break;
    case DioErrorType.cancel:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Request to API server was cancelled",
      );
      navigateToNoConnectionScreen();
      break;
    case DioErrorType.receiveTimeout:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Receive timeout error",
      );
      navigateToNoConnectionScreen();
      break;
    case DioErrorType.sendTimeout:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Send timeout error",
      );
      navigateToNoConnectionScreen();
      break;
    case DioErrorType.connectionTimeout:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Connection timeout error",
      );
      navigateToNoConnectionScreen();
      break;
    case DioErrorType.badResponse:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Something went Wrong",
      );
      switch (exception.response!.statusCode) {
        case 302:
          connectionModel.message = "Error 302 Bad Request";
          break;
        case 400:
          connectionModel.message = "Error 400 Bad Request";
          break;
        case 403:
          connectionModel.message = "Error 403 Forbidden";
          break;
        case 404:
          connectionModel.message = "Error 404 Not Found";
          break;
        case 500:
          connectionModel.message = "500 Server Error";
          break;
        default:
          break;
      }
      navigateToNoConnectionScreen();
      break;
    default:
      connectionModel = ConnectionModel(
        currentScreen: screen,
        message: "Something went Wrong",
      );
      navigateToNoConnectionScreen();
      break;
  }
}
