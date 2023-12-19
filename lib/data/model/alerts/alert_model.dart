class Alerts {
  bool? success;
  String? message;
  List<AlertsData>? alertsData;

  Alerts({this.success, this.message, this.alertsData});

  Alerts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      alertsData = <AlertsData>[];
      json['data'].forEach((v) {
        alertsData!.add(new AlertsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.alertsData != null) {
      data['data'] = this.alertsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlertsData {
  int? id;
  String? leakType;
  String? leakDate;
  String? alertType;
  int? deviceId;
  String? createdAt;
  AlertDevice? device;

  AlertsData(
      {this.id,
        this.leakType,
        this.leakDate,
        this.alertType,
        this.deviceId,
        this.createdAt,
        this.device});

  AlertsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leakType = json['leak_type'].toString();
    leakDate = json['leak_date'].toString();
    alertType = json['alert_type'].toString();
    deviceId = json['device_id'];
    createdAt = json['created_at'].toString();
    device =
    json['device'] != null ? new AlertDevice.fromJson(json['device']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leak_type'] = this.leakType;
    data['leak_date'] = this.leakDate;
    data['alert_type'] = this.alertType;
    data['device_id'] = this.deviceId;
    data['created_at'] = this.createdAt;
    if (this.device != null) {
      data['device'] = this.device!.toJson();
    }
    return data;
  }
}

class AlertDevice {
  int? id;
  String? name;
  String? macAddress;
  String? publicIp;
  String? address;
  String? location;
  String? sdCard;
  String? currentState;

  AlertDevice(
      {this.id,
        this.name,
        this.macAddress,
        this.publicIp,
        this.address,
        this.location,
        this.sdCard,
        this.currentState});

  AlertDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    macAddress = json['mac_address'].toString();
    publicIp = json['public_ip'].toString();
    address = json['address'].toString();
    location = json['location'].toString();
    sdCard = json['sd_card'].toString();
    currentState = json['current_state'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mac_address'] = this.macAddress;
    data['public_ip'] = this.publicIp;
    data['address'] = this.address;
    data['location'] = this.location;
    data['sd_card'] = this.sdCard;
    data['current_state'] = this.currentState;
    return data;
  }
}