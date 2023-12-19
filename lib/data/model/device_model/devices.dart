class Devices {
  bool? success;
  String? message;
  List<DevicesData>? data;
  int? total;

  Devices({this.success, this.message, this.data, this.total});

  Devices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DevicesData>[];
      json['data'].forEach((v) {
        data!.add(new DevicesData.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class DevicesData {
  int? id;
  String? name;
  String? macAddress;
  String? publicIp;
  String? address;
  String? location;
  String? sdCard;
  String? currentState;
  String? createdAt;
  String? deletedAt;
  String? battery;
  String? unitNumber;
  String? alertStatus;
  String? calibrationStatus;
  String? isActive;
  String? firmwareVersion;
  User? user;
  AssignTo? assignTo;
  User? createdBy;
  int? alertsCount;

  DevicesData(
      {this.id,
        this.name,
        this.macAddress,
        this.publicIp,
        this.address,
        this.battery,
        this.unitNumber,
        this.location,
        this.sdCard,
        this.currentState,
        this.createdAt,
        this.deletedAt,
        this.alertStatus,
        this.firmwareVersion,
        this.calibrationStatus,
        this.isActive,
        this.user,
        this.assignTo,
        this.createdBy,
        this.alertsCount});

  DevicesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??"";
    macAddress = json['mac_address']??"";
    battery = json['battery']??"";
    unitNumber = json['unit_number']??"";
    publicIp = json['public_ip']??"";
    address = json['address']??"";
    location = json['location']??"";
    sdCard = json['sd_card']??"";
    currentState = json['current_state']??"";
    createdAt = json['created_at']??"";
    deletedAt = json['deleted_at']??"";
    alertStatus = json['alert_status']??"";
    calibrationStatus = json['calibration_status']??"";
    firmwareVersion = json['firmware_version']??"";
    isActive = json['is_active'].toString();
    user = json['user'] != null ? new User.fromJson(json['user']) : User();
    assignTo = json['assign_to'] != null
        ? new AssignTo.fromJson(json['assign_to'])
        : AssignTo();
    createdBy = json['created_by'] != null
        ? new User.fromJson(json['created_by'])
        : User();
    alertsCount = json['alerts_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mac_address'] = this.macAddress;
    data['public_ip'] = this.publicIp;
    data['battery'] = this.battery;
    data['unit_number'] = this.unitNumber;
    data['address'] = this.address;
    data['location'] = this.location;
    data['sd_card'] = this.sdCard;
    data['current_state'] = this.currentState;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['alert_status'] = this.alertStatus;
    data['calibration_status'] = this.calibrationStatus;
    data['firmware_version'] = this.firmwareVersion;
    data['is_active'] = this.isActive;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.assignTo != null) {
      data['assign_to'] = this.assignTo!.toJson();
    }
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    data['alerts_count'] = this.alertsCount;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? photo;

  User(
      {this.id,
        this.name,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.photo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??""??"";
    email = json['email']??"";
    countryCode = json['country_code']??"";
    phoneNumber = json['phone_number']??"";
    photo = json['photo']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['photo'] = this.photo;
    return data;
  }
}

class AssignTo {
  int? id;
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? photo;

  AssignTo(
      {this.id,
        this.name,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.photo});

  AssignTo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']??"";
    email = json['email']??"";
    countryCode = json['country_code']??"";
    phoneNumber = json['phone_number']??"";
    photo = json['photo']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['photo'] = this.photo;
    return data;
  }
}
