import 'package:dio/dio.dart';
import 'package:dripx/data/model/venue/venue_model.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/loader_dialog.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dripx/data/model/device_model/devices.dart';

class HomeProvider extends ChangeNotifier {
  //Search controller
  bool isLoading = true;
  bool isVenueLoading = true;
  bool isVenuePaginationLoading = true;
  String? bluetoothDeviceMacAddress;
  String searchDeviceByVenueID = '';
  ApiRepo apiRepo = ApiRepo();
  Devices devices = Devices();
  Devices singleDevice = Devices();
  Devices updateDevices = Devices();
  VenueModel venueModel = VenueModel();
  VenueData selectedVenue = VenueData();

  DevicesData? updatedDevice;

  DevicesData selectedDeviceForAlerts = DevicesData();

  bool preciseLocation = false;

  // dynamic devices;

  TextEditingController searchController = TextEditingController();
  TextEditingController venueNameController = TextEditingController();

  //Search controller
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();

  //Scroll controller 
  ScrollController venueListingScrollController = ScrollController();
  ScrollController venueHomeListingScrollController = ScrollController();

  bool isNotify = false;

  setNotify() {
    isNotify = !isNotify;
    notifyListeners();
  }

  int pageNumber = 0;
  getDevices(BuildContext context, String searchText, String page, {String? venueID, bool? isUpdate = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if(isUpdate == false) {
      isLoading = true;
      notifyListeners();
    }

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getDevices + "${venueID == null ? '' : "venue_id=${venueID}"}&search=${searchText}&limit=10&offet=${page}", bearerToken: authProvider.authModel.token, );
      isUpdate == false ? devices = Devices.fromJson(response.data) : updateDevices = Devices.fromJson(response.data);
      debugPrint(response.data);
      isLoading = false;
      notifyListeners();

    }
    catch(e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  getSingleDevices(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getDevices + "device_id=${updatedDevice!.id}", bearerToken: authProvider.authModel.token, );
      if(response.statusCode == 200 || response.statusCode == 201) {
        singleDevice = Devices.fromJson(response.data);
        debugPrint("response is ${singleDevice}");
      }
    }
    catch(e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }

  ///Venues APIS
  bool isVenueAddLoading = false;
  addVenues(BuildContext context, String venueName, String address, String city, String state, String postalCode, String country) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    isVenueAddLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        "name": venueName,
        "address": address,
        "city": city,
        "state": state,
        "zip_code": postalCode,
        "country": country,
        "status": "1",
      };
      FocusManager.instance.primaryFocus?.unfocus();
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.addVenues, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        isVenueAddLoading = false;
        if(response.data['success']) {
          showToast(message: response.data['message']);
          // getVenues(context, false, 1);
          // Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
        }else {
          isVenueAddLoading = false;
          showToast(message: response.data['message']);
        }
        notifyListeners();
        // resetPasswordController.clear();
      }
    } catch(e) {
      isVenueAddLoading = false;
      notifyListeners();
      // showToast(message: "Some error occurred");
      // Navigator.pop(context);
      print(e);
    }
  }

  bool isVenueEditLoading = false;
  editVenue(BuildContext context, String venueID, String venueName, String address, String city, String state, String postalCode, String country) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isVenueEditLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        "name": venueName,
        "status": "1",
        "address": address,
        "city": city,
        "state": state,
        "zip_code": postalCode,
        "country": country,
      };
      FocusManager.instance.primaryFocus?.unfocus();
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getVenues + "/${venueID}/edit" , data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        isVenueEditLoading = false;
        if(response.data['success']) {
          showToast(message: response.data['message']);
          // getVenues(context, false, 1);
          // Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (Route<dynamic> route) => false);
        }else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isVenueEditLoading = false;
      notifyListeners();
      print(e);
    }
  }

  getVenues(BuildContext context, bool isPaginate, int pageNumber) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    pageNumber == 1 ? isVenueLoading = true : isVenuePaginationLoading = true;
    notifyListeners();

    try{

      final data = {
        "limit" :"10",
        "offset": pageNumber
      };

      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getVenues, bearerToken: authProvider.authModel.token, data: data);
      if(isPaginate) {
        dynamic venuesPaginate = VenueModel.fromJson(response.data);
        venueModel.venueData!.addAll(venuesPaginate.venueData!);
      }
      else {
        venueModel = VenueModel.fromJson(response.data);
      }
      debugPrint(response.data);
      isVenuePaginationLoading = false;
      isVenueLoading = false;
      notifyListeners();

    }
    catch(e) {
      isVenuePaginationLoading = false;
      isVenueLoading = false;
      notifyListeners();
      print(e);
    }

    isVenuePaginationLoading = false;
    isLoading = false;
    notifyListeners();
  }

  bool isDeleteVenue = false;
  deleteVenue(String id, BuildContext context) async {
    isDeleteVenue = true;
    notifyListeners();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final url = ApiUrl.deleteVenue+ "/${id}";

    try{
      Response response = await apiRepo.deleteRequest(context, RouterHelper.noConnectionScreen, url, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        isDeleteVenue = false;
        notifyListeners();
        Navigator.pop(context);
        if(response.data['success'] == true) {
          showToast(message: "Venue has been deleted successfully");
          getVenues(context, false, 1);
        }
        else {
          showToast(message: response.data['message']);
        }
      }

    }
    catch(e) {
      isDeleteVenue = false;
      Navigator.pop(context);
      showToast(message: "Some error occurred");
      notifyListeners();
      print(e);
    }


    isLoading = false;
    notifyListeners();
  }

  /// Devices API

  deleteDevice(String id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final url = ApiUrl.deleteDevice+ "${id}/true";

    final data = {
      '' : ''
    };

    try{
      Response response = await apiRepo.deleteRequest(context, RouterHelper.noConnectionScreen, url, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        if(response.data['success'] == true) {
          Navigator.pop(context);
          showToast(message: "Device has been deleted successfully");
        }
      }

    }
    catch(e) {
      Navigator.pop(context);
      showToast(message: "Device has not been deleted");
      notifyListeners();
      print(e);
    }


    isLoading = false;
    notifyListeners();
  }

  bool isUpdateDeviceLoading = false;

  updateDevice(BuildContext context, String macAddress) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isUpdateDeviceLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        'name' : deviceNameController.text,
        'unit_number' : unitNumberController.text,
        'location' : locationController.text.trim().length == 0 ? "" : locationController.text,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.updateDevice + macAddress, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");
        isUpdateDeviceLoading = false;
        notifyListeners();
        showToast(message: "Device has been enabled successfully");
      }
    }
    catch(e) {
      isUpdateDeviceLoading = false;
      notifyListeners();
      print(e);
    }

  }

  updateDeviceAlertStatus(BuildContext context, String alertStatus, String macAddress) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    isUpdateDeviceLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        'alert_status' : alertStatus,
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.updateDevice + macAddress, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          isUpdateDeviceLoading = false;
          notifyListeners();
          alertStatus == "1"
            ? showToast(message: "Alerts have been enabled.")
            : showToast(message: "Alerts have been disabled.");
        }

      }
    }
    catch(e) {
      isUpdateDeviceLoading = false;
      notifyListeners();
      print(e);
    }

  }

}