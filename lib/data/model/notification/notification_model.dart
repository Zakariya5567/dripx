class NotificationsModel {
  bool? success;
  String? message;
  List<NotificationData>? notificationData;

  NotificationsModel({this.success, this.message, this.notificationData});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      notificationData = <NotificationData>[];
      json['data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.notificationData != null) {
      data['data'] = this.notificationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  bool? isRead = false;
  String? type;
  String? notifiableType;
  String? notifiableId;
  Data? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.id,
        this.isRead,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.readAt,
        this.createdAt,
        this.updatedAt,});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    notifiableType = json['notifiable_type'].toString();
    notifiableId = json['notifiable_id'].toString();
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    readAt = json['read_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiable_type'] = this.notifiableType;
    data['notifiable_id'] = this.notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Data {
  Alert? alert;
  String? userId;
  String? message;
  String? url;

  Data({this.alert, this.userId, this.message, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    alert = json['alert'] != null ? new Alert.fromJson(json['alert']) : Alert();
    userId = json['user_id'].toString();
    message = json['message'].toString();
    url = json['url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alert != null) {
      data['alert'] = this.alert!.toJson();
    }
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['url'] = this.url;
    return data;
  }
}

class Alert {
  String? id;
  String? userId;
  String? deviceId;
  String? alertUuid;
  String? status;
  String? workorderId;
  String? leakType;
  String? leakDate;
  String? alertType;
  String? detail;
  String? sensitivityCount;
  String? sendAlert;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? expectedAlerts;
  String? alertCount;
  Device? device;
  String? name;
  String? macAddress;
  String? publicIp;
  String? address;
  String? location;
  String? battery;
  String? sdCard;
  String? currentState;
  String? firmwareVersion;
  String? calibrationStatus;
  String? alertStatus;
  String? assignTo;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? createdBy;
  User? user;

  Alert(
      {this.id,
        this.userId,
        this.deviceId,
        this.alertUuid,
        this.status,
        this.workorderId,
        this.leakType,
        this.leakDate,
        this.alertType,
        this.detail,
        this.sensitivityCount,
        this.sendAlert,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.expectedAlerts,
        this.alertCount,
        this.device,
        this.name,
        this.macAddress,
        this.publicIp,
        this.address,
        this.location,
        this.battery,
        this.sdCard,
        this.currentState,
        this.firmwareVersion,
        this.calibrationStatus,
        this.alertStatus,
        this.assignTo,
        this.country,
        this.state,
        this.city,
        this.zipCode,
        this.createdBy,
        this.user});

  Alert.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    deviceId = json['device_id'].toString();
    alertUuid = json['alert_uuid'].toString();
    status = json['status'].toString();
    workorderId = json['workorder_id'].toString();
    leakType = json['leak_type'].toString();
    leakDate = json['leak_date'].toString();
    alertType = json['alert_type'].toString();
    detail = json['detail'].toString();
    sensitivityCount = json['sensitivity_count'].toString();
    sendAlert = json['send_alert'].toString();
    deletedAt = json['deleted_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    expectedAlerts = json['expected_alerts'].toString();
    alertCount = json['alert_count'].toString();
    device =
    json['device'] != null ? new Device.fromJson(json['device']) : null;
    name = json['name'].toString();
    macAddress = json['mac_address'].toString();
    publicIp = json['public_ip'].toString();
    address = json['address'].toString();
    location = json['location'].toString();
    battery = json['battery'].toString();
    sdCard = json['sd_card'].toString();
    currentState = json['current_state'].toString();
    firmwareVersion = json['firmware_version'].toString();
    calibrationStatus = json['calibration_status'].toString();
    alertStatus = json['alert_status'].toString();
    assignTo = json['assign_to'].toString();
    country = json['country'].toString();
    state = json['state'].toString();
    city = json['city'].toString();
    zipCode = json['zip_code'].toString();
    createdBy = json['created_by'].toString();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['device_id'] = this.deviceId;
    data['alert_uuid'] = this.alertUuid;
    data['status'] = this.status;
    data['workorder_id'] = this.workorderId;
    data['leak_type'] = this.leakType;
    data['leak_date'] = this.leakDate;
    data['alert_type'] = this.alertType;
    data['detail'] = this.detail;
    data['sensitivity_count'] = this.sensitivityCount;
    data['send_alert'] = this.sendAlert;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['expected_alerts'] = this.expectedAlerts;
    data['alert_count'] = this.alertCount;
    if (this.device != null) {
      data['device'] = this.device!.toJson();
    }
    data['name'] = this.name;
    data['mac_address'] = this.macAddress;
    data['public_ip'] = this.publicIp;
    data['address'] = this.address;
    data['location'] = this.location;
    data['battery'] = this.battery;
    data['sd_card'] = this.sdCard;
    data['current_state'] = this.currentState;
    data['firmware_version'] = this.firmwareVersion;
    data['calibration_status'] = this.calibrationStatus;
    data['alert_status'] = this.alertStatus;
    data['assign_to'] = this.assignTo;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['created_by'] = this.createdBy;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Device {
  String? id;
  String? name;
  String? macAddress;
  String? publicIp;
  String? address;
  String? location;
  String? battery;
  String? sdCard;
  String? currentState;
  String? firmwareVersion;
  String? calibrationStatus;
  String? status;
  String? alertStatus;
  String? userId;
  String? assignTo;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? createdBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? lastActive;

  Device(
      {this.id,
        this.name,
        this.macAddress,
        this.publicIp,
        this.address,
        this.location,
        this.battery,
        this.sdCard,
        this.currentState,
        this.firmwareVersion,
        this.calibrationStatus,
        this.status,
        this.alertStatus,
        this.userId,
        this.assignTo,
        this.country,
        this.state,
        this.city,
        this.zipCode,
        this.createdBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.lastActive});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    macAddress = json['mac_address'].toString();
    publicIp = json['public_ip'].toString();
    address = json['address'].toString();
    location = json['location'].toString();
    battery = json['battery'].toString();
    sdCard = json['sd_card'].toString();
    currentState = json['current_state'].toString();
    firmwareVersion = json['firmware_version'].toString();
    calibrationStatus = json['calibration_status'].toString();
    status = json['status'].toString();
    alertStatus = json['alert_status'].toString();
    userId = json['user_id'].toString();
    assignTo = json['assign_to'].toString();
    country = json['country'].toString();
    state = json['state'].toString();
    city = json['city'].toString();
    zipCode = json['zip_code'].toString();
    createdBy = json['created_by'].toString();
    deletedAt = json['deleted_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    lastActive = json['last_active'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mac_address'] = this.macAddress;
    data['public_ip'] = this.publicIp;
    data['address'] = this.address;
    data['location'] = this.location;
    data['battery'] = this.battery;
    data['sd_card'] = this.sdCard;
    data['current_state'] = this.currentState;
    data['firmware_version'] = this.firmwareVersion;
    data['calibration_status'] = this.calibrationStatus;
    data['status'] = this.status;
    data['alert_status'] = this.alertStatus;
    data['user_id'] = this.userId;
    data['assign_to'] = this.assignTo;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['created_by'] = this.createdBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['last_active'] = this.lastActive;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? lastName;
  String? googleId;
  String? email;
  String? phoneNumber;
  String? secondaryPhoneNumber;
  String? photo;
  String? country;
  String? timezone;
  String? emailVerifiedAt;
  String? emailOptIn;
  String? twoFactorConfirmedAt;
  String? adminId;
  String? currentTeamId;
  String? membershipId;
  String? profilePhotoPath;
  String? active;
  String? createdBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? stripeId;
  String? pmType;
  String? pmLastFour;
  String? trialEndsAt;
  String? onesignalUuid;
  String? deviceUuid;
  String? countryCode;

  User(
      {this.id,
        this.name,
        this.lastName,
        this.googleId,
        this.email,
        this.phoneNumber,
        this.secondaryPhoneNumber,
        this.photo,
        this.country,
        this.timezone,
        this.emailVerifiedAt,
        this.emailOptIn,
        this.twoFactorConfirmedAt,
        this.adminId,
        this.currentTeamId,
        this.membershipId,
        this.profilePhotoPath,
        this.active,
        this.createdBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.stripeId,
        this.pmType,
        this.pmLastFour,
        this.trialEndsAt,
        this.onesignalUuid,
        this.deviceUuid,
        this.countryCode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    lastName = json['last_name'].toString();
    googleId = json['google_id'].toString();
    email = json['email'].toString();
    phoneNumber = json['phone_number'].toString();
    secondaryPhoneNumber = json['secondary_phone_number'].toString();
    photo = json['photo'].toString();
    country = json['country'].toString();
    timezone = json['timezone'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    emailOptIn = json['email_opt_in'].toString();
    twoFactorConfirmedAt = json['two_factor_confirmed_at'].toString();
    adminId = json['admin_id'].toString();
    currentTeamId = json['current_team_id'].toString();
    membershipId = json['membership_id'].toString();
    profilePhotoPath = json['profile_photo_path'].toString();
    active = json['active'].toString();
    createdBy = json['created_by'].toString();
    deletedAt = json['deleted_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    stripeId = json['stripe_id'].toString();
    pmType = json['pm_type'].toString();
    pmLastFour = json['pm_last_four'].toString();
    trialEndsAt = json['trial_ends_at'].toString();
    onesignalUuid = json['onesignal_uuid'].toString();
    deviceUuid = json['device_uuid'].toString();
    countryCode = json['country_code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['google_id'] = this.googleId;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['secondary_phone_number'] = this.secondaryPhoneNumber;
    data['photo'] = this.photo;
    data['country'] = this.country;
    data['timezone'] = this.timezone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['email_opt_in'] = this.emailOptIn;
    data['two_factor_confirmed_at'] = this.twoFactorConfirmedAt;
    data['admin_id'] = this.adminId;
    data['current_team_id'] = this.currentTeamId;
    data['membership_id'] = this.membershipId;
    data['profile_photo_path'] = this.profilePhotoPath;
    data['active'] = this.active;
    data['created_by'] = this.createdBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['stripe_id'] = this.stripeId;
    data['pm_type'] = this.pmType;
    data['pm_last_four'] = this.pmLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['onesignal_uuid'] = this.onesignalUuid;
    data['device_uuid'] = this.deviceUuid;
    data['country_code'] = this.countryCode;
    return data;
  }
}
