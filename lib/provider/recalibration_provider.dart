import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dripx/data/model/alerts/alert_model.dart';
import 'package:dripx/data/model/device_model/devices.dart';
import 'package:dripx/data/repository/api_repo.dart';
import 'package:dripx/helper/routes_helper.dart';
import 'package:dripx/provider/authentication_provider.dart';
import 'package:dripx/utils/api_url.dart';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/utils/string.dart';
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class ReCalibrationProvider extends ChangeNotifier {
  ApiRepo apiRepo = ApiRepo();
  Alerts alerts = Alerts();
  bool goToNextScreen = true;

  DevicesData? searchingDevice;

  ScrollController alertScrollController = ScrollController();
  TextEditingController nameYourDeviceController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();

  bool isDeviceConnectedValue = false;
  bool isCalibratingStartLoading = false;

  int pageNumber = 0;

  bool isDeviceNameLoading = false;
  bool deleteLoader = false;

  bool isCancelRecalibrationProcess = false;

  String? recalibrationDeviceID;
  String? recalibrationDeviceMacAddress;
  String? recalibrationConnectedDeviceMacAddress;
  String? recalibrationDeviceFirmwareVersion;
  String? recalibrationDeviceName;
  String? recalibrationDeviceBattery;

  String? recalibrationDeviceAccX;
  String? recalibrationDeviceAccY;
  String? recalibrationDeviceAccZ;

  String? recalibrationDeviceGyroX;
  String? recalibrationDeviceGyroY;
  String? recalibrationDeviceGyroZ;

  bool isLoading = false;
  bool isPaginationLoading = false;
  bool isConnectingBleDevice = true;

  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> _connection;

  /// Recalibration Bluetooth integration
  // Connect to Bluetooth Device

  connectToDevice(device, context) async {
    isCancelRecalibrationProcess = false;
    recalibrationDeviceName = device.name;
    recalibrationDeviceID = device.id;
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
              if(string.contains("m:")) {
                recalibrationDeviceMacAddress = string;
                recalibrationDeviceMacAddress = recalibrationDeviceMacAddress!.replaceAll("m:", '');
                recalibrationConnectedDeviceMacAddress = '';
                if(recalibrationDeviceMacAddress != null) {
                  recalibrationConnectedDeviceMacAddress = recalibrationDeviceMacAddress!.replaceAll(":", "");
                  if(recalibrationConnectedDeviceMacAddress!.length > 6) {
                    recalibrationConnectedDeviceMacAddress = recalibrationConnectedDeviceMacAddress!.substring(recalibrationConnectedDeviceMacAddress!.length - 6);
                  }
                }
              }
              else if(string.contains("battery")) {
                recalibrationDeviceBattery = string;
                recalibrationDeviceBattery = recalibrationDeviceBattery!.replaceAll("battery:", '');
              }
              else if(string.contains("version_no")) {
                recalibrationDeviceFirmwareVersion = string;
                recalibrationDeviceFirmwareVersion = recalibrationDeviceFirmwareVersion!.replaceAll("version_no:", '');
              }

              else if(string.contains("acc_x")) {
                recalibrationDeviceAccX = string;
                recalibrationDeviceAccX = recalibrationDeviceAccX!.replaceAll("acc_x:", '');
              }
              else if(string.contains("acc_y")) {
                recalibrationDeviceAccY = string;
                recalibrationDeviceAccY = recalibrationDeviceAccY!.replaceAll("acc_y:", '');
              }
              else if(string.contains("acc_z")) {
                recalibrationDeviceAccZ = string;
                recalibrationDeviceAccZ = recalibrationDeviceAccZ!.replaceAll("acc_z:", '');
              }

              else if(string.contains("gyro_x")) {
                recalibrationDeviceGyroX = string;
                recalibrationDeviceGyroX = recalibrationDeviceGyroX!.replaceAll("gyro_x:", '');
              }
              else if(string.contains("gyro_y")) {
                recalibrationDeviceGyroY = string;
                recalibrationDeviceGyroY = recalibrationDeviceGyroY!.replaceAll("gyro_y:", '');
              }
              else if(string.contains("gyro_z")) {
                recalibrationDeviceGyroZ = string;
                recalibrationDeviceGyroZ = recalibrationDeviceGyroZ!.replaceAll("gyro_z:", '');
                isLoading = true;
                Navigator.pushNamed(AppKeys.mainNavigatorKey.currentContext!, RouterHelper.recalibratedCalibratedScreen);
                sendCalibratingValueInAPI(context);
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
              print("Connecting to device $recalibrationDeviceID resulted in error $e");
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
          Navigator.pushNamedAndRemoveUntil(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.homeScreen, (route) => false);
          showToast(message: "Bluetooth device disconnected");
        }

      }
    });


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

  // Disconnect bluetooth device
  disconnectDevice() {
    _connection.cancel();
  }

  //Register Bluetooth Device

  String? connectedDeviceID;
  bool isCalibratingLoading = false;

  final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
  startCalibratingThroughAPI(BuildContext context, String deviceMacAddress,) async {
    isCalibratingLoading = true;
    notifyListeners();
    try{
      dynamic data = {"": ""};
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deviceCalibrationStart + "/${deviceMacAddress}" + "/device-recalibrate", data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {
        isCalibratingLoading = false;
        notifyListeners();
        if(response.data['success']) {}
        else {
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isCalibratingLoading = false;
      notifyListeners();
      showToast(message: "Some error occurred please calibrate your device again");
      Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
      print(e);
    }
  }

  // Send calibration value in API

  CancelToken cancelToken = CancelToken();
  sendCalibratingValueInAPI(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        "acc_x": recalibrationDeviceAccX,
        "acc_y": recalibrationDeviceAccY,
        "acc_z": recalibrationDeviceAccZ,
        "gyro_x": recalibrationDeviceGyroX,
        "gyro_y": recalibrationDeviceGyroY,
        "gyro_z": recalibrationDeviceGyroZ,
        "mac_address": recalibrationDeviceMacAddress
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.deviceCalibration, data, bearerToken: authProvider.authModel.token, cancelToken : cancelToken);
      if(response.statusCode == 200 || response.statusCode == 201) {
        if(isDeviceConnectedValue) {
          isLoading = false;
          notifyListeners();
          if(response.data['success']) {
            showToast(message: "Device calibration successful");
            await sendData(context, 'complete', recalibrationDeviceID!);
            if(Platform.isIOS) {
              await Future.delayed(const Duration(seconds: 2));
            }
            disconnectDevice();
            isDeviceConnectedValue = false;
          }else {
            showToast(message: response.data['message']);
          }
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      showToast(message: "Some error occurred please calibrate your device again");
      isLoading = false;
      notifyListeners();
      Navigator.pop(context);
      print(e);
    }
  }

  bool isDeviceCalibratingStart = false;

  ///Start calibrating

  startCalibrating(BuildContext context) async {
    isDeviceCalibratingStart = true;
    notifyListeners();
    await sendData(context, 'calibrate', recalibrationDeviceID!);
    isDeviceCalibratingStart = false;
    notifyListeners();
  }

}
