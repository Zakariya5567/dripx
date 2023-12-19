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
import 'package:dripx/view/widgets/show_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiSwitchingProvider extends ChangeNotifier {
  ApiRepo apiRepo = ApiRepo();
  Alerts alerts = Alerts();
  bool goToNextScreen = true;

  DevicesData? searchingDevice;

  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();

  ScrollController alertScrollController = ScrollController();
  TextEditingController nameYourDeviceController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();

  int pageNumber = 0;

  bool isDeviceNameLoading = false;
  bool deleteLoader = false;

  String? wifiSwitchingDeviceID;
  String? wifiSwitchingDeviceMacAddress;
  String? wifiSwitchingDeviceName;

  bool isLoading = false;
  bool isConnectingBleDevice = true;
  bool isDeviceConnectedValue = false;

  bool isVisible = true;
  passwordVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<ConnectionStateUpdate> _connection;

  /// Wifi Switching Bluetooth integration
  // Connect to Bluetooth Device
  List<String> wifiNetworks = [];
  bool addValueInWifiList = false;
  bool getWifiLoading = false;

  connectToDevice(device, context) async {
    wifiSwitchingDeviceName = device.name;
    wifiSwitchingDeviceID = device.id;
    final Uuid _myServiceUuid = Uuid.parse("6cea3832-fa18-11ed-be56-0242ac120002");
    final Uuid _myCharacteristicUuid = Uuid.parse("95bc5f56-fa18-11ed-be56-0242ac120002");
    _connection = flutterReactiveBle.connectToDevice(id: device.id).listen((event) async {
      if(event.connectionState == DeviceConnectionState.connected) {
        print("Wifi Device Connection Successful");
        if(Platform.isIOS) {
          print("Navigate to IOS network screen");
          Navigator.pushReplacementNamed(context, RouterHelper.wifiSwitchingIosNetworkScreen);
        }
        isDeviceConnectedValue = true;
        isConnectingBleDevice = true;
        var chars = QualifiedCharacteristic(characteristicId: _myCharacteristicUuid, serviceId: _myServiceUuid, deviceId: device.id);
        flutterReactiveBle.subscribeToCharacteristic(chars).listen(
          (data) {
            Uint8List bytes = Uint8List.fromList(data);
            String string = String.fromCharCodes(bytes);
            print('data is $string');
            if(string.contains("wifi_link")) {
              wifiNetworks = [];
              print("Add value true");
              addValueInWifiList = true;
            }
            else if(string.contains("wifi_end")) {
              print("Add value false");
              getWifiLoading = false;
              addValueInWifiList = false;
              // Navigator.pushNamed(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.wifiSwitchingIosNetworkScreen,);
            }
            else if(addValueInWifiList) {
              wifiNetworks.add(string);
              print("Wifi Network List is ${wifiNetworks}");
            }
            notifyListeners();
          },
          onError: (Object e) {
            isConnectingBleDevice = false;
            notifyListeners();
            print("Connecting to device $wifiSwitchingDeviceID resulted in error $e");
          }
        );
      } else if(event.connectionState == DeviceConnectionState.disconnected) {
        if(isDeviceConnectedValue) {
          Navigator.pushNamedAndRemoveUntil(AppKeys.mainNavigatorKey.currentState!.context, RouterHelper.homeScreen, (route) => false);
          showToast(message: "Bluetooth device disconnected");
        }

      }
    });

  }

  // Send data to bluetooth device

  sendData(String value, String deviceID) async {
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

  String? connectedDeviceID;
  bool isSendingDataOnApiLoading = false;

  final authProvider = Provider.of<AuthProvider>(AppKeys.mainNavigatorKey.currentState!.context, listen: false);
  wifiSwitchingApi(BuildContext context, String deviceMacAddress, String state, bool sendDataToDevice) async {
    isSendingDataOnApiLoading = true;
    notifyListeners();
    try{
      dynamic data = {
        "current_state": state
      };
      Response response = await apiRepo.postRequest(context, RouterHelper.noConnectionScreen, ApiUrl.wifiSwitching + "${deviceMacAddress}" + "/wifi-switch", data, bearerToken: authProvider.authModel.token);
      if(response.statusCode == 200) {

        notifyListeners();
        if(response.data['success']) {
          if(sendDataToDevice) {
            if(Platform.isAndroid) {
              await sendData('ssid', wifiSwitchingDeviceID!);
              await sendData(wifiNameController.text, wifiSwitchingDeviceID!);
              await sendData('password', wifiSwitchingDeviceID!);
              await sendData(wifiPasswordController.text, wifiSwitchingDeviceID!);
              isSendingDataOnApiLoading = false;
              notifyListeners();
              isDeviceConnectedValue = false;
              disconnectDevice();
              showToast(message: "Wifi switching has been completed successfully");
              Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
              // dispose();
            }
            else {
              isSendingDataOnApiLoading = false;
              notifyListeners();
              sendDataOnIOS(context, wifiNameController.text, wifiPasswordController.text);
              showToast(message: "Wifi switching has been completed successfully");
              Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
              WiFiForIoTPlugin.disconnect();
            }
          }
        }
        else {
          isSendingDataOnApiLoading = false;
          notifyListeners();
          showToast(message: response.data['message']);
        }

        // resetPasswordController.clear();
      }
    } catch(e) {
      isSendingDataOnApiLoading = false;
      notifyListeners();
      showToast(message: "Some error occurred please switch your device wifi again");
      Navigator.pushNamedAndRemoveUntil(context, RouterHelper.homeScreen, (route) => false);
      print(e);
    }
  }


  sendDataOnIOS(context, String wifiName, String wifiPassword) async {
    await sendData('ssid', wifiSwitchingDeviceID!);
    print("ssid");
    await sendData(wifiName, wifiSwitchingDeviceID!);
    print(wifiName);
    await sendData('password', wifiSwitchingDeviceID!);
    print("Password");
    await sendData(wifiPassword, wifiSwitchingDeviceID!);
    print(wifiPassword);
    isDeviceConnectedValue = false;
    disconnectDevice();
  }

}
