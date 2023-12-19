import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/data/model/notification/notification_model.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/provider/home_provider.dart';
import 'package:dripx/provider/setup_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AlertProvider extends ChangeNotifier {
  ApiRepo apiRepo = ApiRepo();
  Alerts alerts = Alerts();
  Alerts alertsDetail = Alerts();
  bool goToNextScreen = true;
  ScrollController alertScrollController = ScrollController();
  TextEditingController nameYourDeviceController = TextEditingController();

  TextEditingController venueNameController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController deviceLocationController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController venueController = TextEditingController();

  TextEditingController editCountryController = TextEditingController();
  TextEditingController editPostalCodeController = TextEditingController();
  TextEditingController editStateController = TextEditingController();
  TextEditingController editCityController = TextEditingController();
  TextEditingController editVenueController = TextEditingController();
  TextEditingController editAddressController = TextEditingController();

  int pageNumber = 0;

  bool isDeviceNameLoading = false;
  bool deleteLoader = false;
  bool isDeviceInWaterTank = false;
  bool readyToUseLoading = false;
  bool collectionStarted = false;
  bool isDeviceConnectedValue = false;

  String? deviceID;
  String? deviceMacAddress;
  String? connectedDeviceMacAddress;
  String? deviceFirmwareVersion;
  String? deviceName;
  String? deviceBattery;

  String? deviceAccX;
  String? deviceAccY;
  String? deviceAccZ;

  String? deviceGyroX;
  String? deviceGyroY;
  String? dataCollection;
  String? deviceGyroZ;

  String? selectedEditVenueID;

  bool isLoading = false;
  bool isPaginationLoading = false;
  bool isConnectingBleDevice = true;

  File? dataCollectionFile;

  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> _connection;

  // Get Alerts

  getAlert(BuildContext context, int page, String searchDeviceID, {bool paginationLoading = false}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    paginationLoading ? isPaginationLoading = true : isLoading = true;
    notifyListeners();
    final data = {
      "device_id": searchDeviceID,
      "search": "",
      "limit" :"10",
      "offset": page.toString()
    };

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getAlert, bearerToken: authProvider.authModel.token, data: data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success']) {

          if(paginationLoading) {
            dynamic alertsData = Alerts.fromJson(response.data);
            alerts.alertsData!.addAll(alertsData.alertsData!);
          }
          else {
            alerts = Alerts.fromJson(response.data);
          }
        }
      }

      debugPrint(response.data);
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

  // Get Alerts Details

  getAlertDetails(BuildContext context, String alertID) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final data = {
      '' : '',
    };

    try{
      Response response = await apiRepo.getRequest(context, RouterHelper.noConnectionScreen, ApiUrl.getAlertDetail + alertID, bearerToken: authProvider.authModel.token, data: data);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success']) {
          var data = response.data;
          return data;
        }
      }
    }
    catch(e) {
      print(e);
      return null;
    }
  }

  // //check bluetooth status

  List<String> wifiNetworks = [];
  bool addValueInWifiList = false;
  // Connect to Bluetooth Device

  connectToDevice(device, context) async {
    deviceName = device.name;
    deviceID = device.id;
    final Uuid _myServiceUuid = Uuid.parse("6cea3832-fa18-11ed-be56-0242ac120002");
    final Uuid _myCharacteristicUuid = Uuid.parse("95bc5f56-fa18-11ed-be56-0242ac120002");
    _connection = flutterReactiveBle.connectToDevice(id: device.id).listen((event) async {
      if(event.connectionState == DeviceConnectionState.connected) {
        isDeviceConnectedValue = true;
        isConnectingBleDevice = true;
        print("Device Connection Successful");
        var chars = QualifiedCharacteristic(characteristicId: _myCharacteristicUuid, serviceId: _myServiceUuid, deviceId: device.id);
        flutterReactiveBle.subscribeToCharacteristic(chars).listen(
          (data) {
            Uint8List bytes = Uint8List.fromList(data);
            String string = String.fromCharCodes(bytes);
            print('data is $string');
            if(string.contains("m:"))
            {
              deviceMacAddress = string;
              deviceMacAddress = deviceMacAddress!.replaceAll("m:", '');
              connectedDeviceMacAddress = '';
              if(deviceMacAddress != null) {
                connectedDeviceMacAddress = deviceMacAddress!.replaceAll(":", "");
                if(connectedDeviceMacAddress!.length > 6) {
                  connectedDeviceMacAddress = connectedDeviceMacAddress!.substring(connectedDeviceMacAddress!.length - 6);
                }
              }
            }
            else if(string.contains("battery")) {
              deviceBattery = string;
              deviceBattery = deviceBattery!.replaceAll("battery:", '');
            }
            else if(string.contains("version_no")) {
              deviceFirmwareVersion = string;
              deviceFirmwareVersion = deviceFirmwareVersion!.replaceAll("version_no:", '');
            }

            else if(string.contains("acc_x")) {
              deviceAccX = string;
              deviceAccX = deviceAccX!.replaceAll("acc_x:", '');
            }
            else if(string.contains("acc_y")) {
              deviceAccY = string;
              deviceAccY = deviceAccY!.replaceAll("acc_y:", '');
            }
            else if(string.contains("acc_z")) {
              deviceAccZ = string;
              deviceAccZ = deviceAccZ!.replaceAll("acc_z:", '');
            }

            else if(string.contains("gyro_x")) {
              deviceGyroX = string;
              deviceGyroX = deviceGyroX!.replaceAll("gyro_x:", '');
            }
            else if(string.contains("gyro_y")) {
              deviceGyroY = string;
              deviceGyroY = deviceGyroY!.replaceAll("gyro_y:", '');
            }
            else if(string.contains("gyro_z")) {
              deviceGyroZ = string;
              deviceGyroZ = deviceGyroZ!.replaceAll("gyro_z:", '');
              startCalibratingThroughAPI(context);
            }
            else if(string.contains("wifi_link")) {
              print("Add value true");
              addValueInWifiList = true;
            }
            else if(string.contains("wifi_end")) {
              print("Add value false");
              addValueInWifiList = false;
              Navigator.pushNamed(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.iosNetworkScreen,);
            }
            else if(string.contains("stable:")) {
              if(string.contains("true")) {
                Navigator.of(AppKeys.mainNavigatorKey.currentState!.context, rootNavigator: false).pop('dialog');
              }
            }
            else if(string.contains("collection_started:")) {
              if(string.contains("true")) {
                collectionStarted = true;
                notifyListeners();
              }
            }
            else if(string.contains("file_start:")) {
              if(string.contains("true")) {
                creteDirectoryForFile();
              }
            }
            else if(string.contains("data:")) {
              dataCollection = string;
              dataCollection = dataCollection!.replaceAll("gyro_y:", '');

            }
            else if(string.contains("file_end:")) {
              if(string.contains("true")) {

              }
            }
            else if(string.contains("next_collection:")) {
              if(string.contains("true")) {
                Navigator.of(AppKeys.mainNavigatorKey.currentState!.context, rootNavigator: false).pop('dialog');
              }
            }
            else if(addValueInWifiList) {
              wifiNetworks.add(string);
              print("Wifi Network List is ${wifiNetworks}");
            }
            notifyListeners();
            // if(controller.goToNextScreen) {
            //   Navigator.pushNamed(context, RouterHelper.deviceFoundScreen);
            // }
            goToNextScreen= false;
          },
          onError: (Object e) {
            isConnectingBleDevice = false;
            notifyListeners();
            print("Connecting to device $deviceID resulted in error $e");
          }

        );
        print("Subscribe Successful");
        print("1 Second wait start");
        await Future.delayed(const Duration(seconds: 1));
        print("1 Second wait completed");
        sendData(context, "device_info", device.id);
      }
      else if(event.connectionState == DeviceConnectionState.disconnected) {
        if(isDeviceConnectedValue) {
          isDeviceConnectedValue = false;
          Navigator.pushNamedAndRemoveUntil(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.homeScreen, (route) => false);
          showToast(message: "Bluetooth device disconnected");
        }

      }
    });
  }

  creteDirectoryForFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    DateTime now = DateTime.now();
    String filePathName = now.toString();
    dataCollectionFile = File('${directory.path}/${filePathName}.txt');
  }

  // Send data to bluetooth device

  sendData(BuildContext context, String value, String deviceID) async {
    try{
      final characteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse("6cea3832-fa18-11ed-be56-0242ac120002"),
          characteristicId: Uuid.parse("9dde527a-fa18-11ed-be56-0242ac120002"),
          deviceId: deviceID
      );

      ///With flutterReactiveBle.writeCharacteristicWithResponse work for IOS
      /// flutterReactiveBle.writeCharacteristicWithoutResponse work for Android

      final response = await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: utf8.encode(value));
      print("response");
    } catch(e) {
      print(e);
    }
  }

  //Register Bluetooth Device

  String? connectedDeviceID;

  registerDevice(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    try{
      dynamic data = {
        "public_ip": "",
        "sd_card": "no",
        "battery": deviceBattery,
        "current_state": "connected",
        "firmware_version": deviceFirmwareVersion,
        "mac_address": deviceMacAddress,
        "name": nameYourDeviceController.text,
        // "country": countryController.text,
        // "address": addressController.text,
        // "state": stateController.text,
        // "city": cityController.text,
        "location": deviceLocationController.text,
        "unit_number": unitNumberController.text,
        "venue_id" : homeProvider.selectedVenue.id.toString()
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deviceRegister, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        isDeviceNameLoading = false;
        notifyListeners();
        FocusManager.instance.primaryFocus?.unfocus();
        debugPrint("Response is ${response.data}");
        if(response.data['success']) {
          connectedDeviceID = response.data['data']['id'].toString();
          Navigator.pushNamed(context, RouterHelper.calibrateDeviceScreen);
          showToast(message: 'Device has been register successfully');
          nameYourDeviceController.clear();
        }else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isDeviceNameLoading = false;
      notifyListeners();
      print(e);
    }
  }

  // Start Calibration through API

  final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
  startCalibratingThroughAPI(context) async {
    isLoading = true;
    notifyListeners();
    try{
      dynamic data = {"": ""};
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deviceCalibrationStart + "/${deviceMacAddress}" + "/device-recalibrate", data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        if(response.data['success']) {
          sendCalibratingValueInAPI(context);
        }else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      showToast(message: "Some error occurred please calibrate your device again");
      Navigator.pop(context);
      print(e);
    }
  }

  // Send calibration value in API

  sendCalibratingValueInAPI(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        "acc_x": deviceAccX,
        "acc_y": deviceAccY,
        "acc_z": deviceAccZ,
        "gyro_x": deviceGyroX,
        "gyro_y": deviceGyroY,
        "gyro_z": deviceGyroZ,
        "mac_address": deviceMacAddress
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deviceCalibration, data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success']) {
          showToast(message: "Device calibration successful");
          isDeviceConnectedValue = false;
          Navigator.pushNamed(AppKeys.mainNavigatorKey.currentContext!, RouterHelper.calibratedScreen);
        }else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      showToast(message: "Some error occurred please calibrate your device again");
      Navigator.pop(context);
      print(e);
    }
  }

  sendDataOnIOS(context, String wifiName, String wifiPassword) async {
    await sendData(context, 'ssid', deviceID!);
    print("ssid");
    await sendData(context, wifiName, deviceID!);
    print(wifiName);
    await sendData(context, 'password', deviceID!);
    print("Password");
    Future.delayed(const Duration(seconds: 2));
    print("2 Seconds wait start");
    await sendData(context, wifiPassword, deviceID!);
    print(wifiPassword);
  }

  bool isDeviceCalibratingStart = false;

  // Start calibrating

  startCalibrating(BuildContext context) async {
    isDeviceCalibratingStart = true;
    notifyListeners();
    await sendData(context, 'calibrate', deviceID!);
    isDeviceCalibratingStart = false;
    notifyListeners();
  }

  disconnectDevice() {
    _connection.cancel();
  }

}
