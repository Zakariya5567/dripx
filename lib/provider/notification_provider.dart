import 'package:dio/dio.dart';
import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/data/model/notification/notification_model.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:dripx/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier {
  ApiRepo apiRepo = ApiRepo();
  ScrollController notificationsScrollController = ScrollController();

  int pageNumber = 0;

  bool isLoading = false;
  bool isPaginationLoading = false;

  NotificationsModel notificationsModel = NotificationsModel();

  getNotifications(BuildContext context, int page, {bool paginationLoading = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    paginationLoading ? isPaginationLoading = true : isLoading = true;
    notifyListeners();
    final data = {
      "limit" :"10",
      "offset": page.toString()
    };

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getNotifications, bearerToken: authProvider.authModel.token, data: data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success']) {

          if(paginationLoading) {
            dynamic notificationsData = NotificationsModel.fromJson(response.data);
            notificationsModel.notificationData!.addAll(notificationsData.notificationData!);
          }
          else {
            notificationsModel = NotificationsModel.fromJson(response.data);
          }
        }
      }

      print(notificationsModel);
      paginationLoading ? isPaginationLoading = false : isLoading = false;
      notifyListeners();

    }
    catch(e) {
      paginationLoading ? isPaginationLoading = false : isLoading = false;
      notifyListeners();
      print(e);
    }

    paginationLoading ? isPaginationLoading = false : isLoading = false;
    notifyListeners();
  }

  readSingleNotification(BuildContext context, String id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try{
      dynamic data = {
        'notification_id' : id,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.notificationRead, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {

        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      print(e);
    }
  }

  bool isReadAllNotificationDataLoading = false;
  markReadAllNotification(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isReadAllNotificationDataLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        '' : '',
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.notificationRead + "/true", data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint("Response is ${response.data}");
        isReadAllNotificationDataLoading = false;
        notifyListeners();
        if(response.data['success']) {
          for(int i = 0 ; i<notificationsModel.notificationData!.length; i++) {
            notificationsModel.notificationData![i].readAt = DateTime.now().toString();
          }
          notifyListeners();
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isReadAllNotificationDataLoading = false;
      notifyListeners();
      print(e);
    }
  }

}
