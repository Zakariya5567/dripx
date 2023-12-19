import 'package:dio/dio.dart';
import 'package:dripx/data/model/system_checks/system_checks_model.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingProvider extends ChangeNotifier {
  bool isNotify = false;
  ApiRepo apiRepo = ApiRepo();
  SystemCheckModel systemCheckModel = SystemCheckModel();

  setNotify() {
    isNotify = !isNotify;
    notifyListeners();
  }

  // System check api
  bool isSystemCheckLoading = false;
  getSystemCheckValue(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isSystemCheckLoading = true;
    notifyListeners();

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getSystemCheck, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success']) {
          systemCheckModel = SystemCheckModel.fromJson(response.data);
          print(systemCheckModel);
        }
      }

      debugPrint(response.data);
      isSystemCheckLoading = false;
      notifyListeners();

    }
    catch(e) {
      isSystemCheckLoading = false;
      notifyListeners();
      print(e);
    }
  }


}
