class AuthModel {
  bool? success;
  String? message;
  Data? data;
  String? token;

  AuthModel({this.success, this.message, this.data, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? photo;
  String? authType;
  String? userRole;
  String? verificationOtp;
  String? activeDevices;
  Coupon? coupon;
  Subscription? subscription;

  Data(
      {this.id,
        this.name,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.photo,
        this.authType,
        this.userRole,
        this.verificationOtp,
        this.activeDevices,
        this.coupon,
        this.subscription
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name']??'';
    email = json['email']??'';
    countryCode = json['country_code']??'';
    phoneNumber = json['phone_number']??'';
    photo = json['photo']??'';
    authType = json['auth_type']??'';
    userRole = json['user_role']??'';
    activeDevices = json['active_devices'].toString();
    verificationOtp = json['verification_otp'].toString();
    coupon = json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : Coupon();
    subscription = json['subscription'] != null ? new Subscription.fromJson(json['subscription']) : Subscription();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['photo'] = this.photo;
    data['auth_type'] = this.authType;
    data['user_role'] = this.userRole;
    data['active_devices'] = this.activeDevices;
    data['verification_otp'] = this.verificationOtp;
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.toJson();
    }
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    return data;
  }
}

class Coupon {
  String? id;
  String? name;
  String? status;
  String? allowedDevices;
  String? expiry;

  Coupon({this.id, this.name, this.status, this.expiry, this.allowedDevices});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name']??'';
    allowedDevices = json['allowed_devices'].toString();
    name = json['name']??'';
    status = json['status'].toString();
    expiry = json['expiry']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['allowed_devices'] = this.allowedDevices;
    data['expiry'] = this.expiry;
    return data;
  }
}

class Subscription {
  String? id;
  String? name;
  String? stripeId;
  String? stripeStatus;
  String? trialEndAt;
  String? endAt;

  Subscription({this.id, this.name, this.stripeId, this.stripeStatus, this.endAt, this.trialEndAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name']??'';
    stripeId = json['stripe_id'].toString();
    stripeStatus = json['stripe_status']??'';
    trialEndAt = json['trial_ends_at']??'';
    endAt = json['ends_at']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['stripe_id'] = this.stripeId;
    data['stripe_status'] = this.stripeStatus;
    data['trial_ends_at'] = this.trialEndAt;
    data['ends_at'] = this.endAt;
    return data;
  }
}
