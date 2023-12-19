class VenueModel {
  bool? success;
  String? message;
  List<VenueData>? venueData;
  String? total;

  VenueModel({this.success, this.message, this.venueData, this.total});

  VenueModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      venueData = <VenueData>[];
      json['data'].forEach((v) {
        venueData!.add(new VenueData.fromJson(v));
      });
    }
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.venueData != null) {
      data['data'] = this.venueData!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class VenueData {
  String? id;
  String? name;
  String? country;
  String? city;
  String? zipCode;
  String? state;
  String? address;
  String? totalDevices;

  VenueData(
      {this.id,
        this.name,
        this.country,
        this.city,
        this.zipCode,
        this.state,
        this.address,
        this.totalDevices});

  VenueData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name']??"";
    country = json['country']??"";
    city = json['city']??"";
    zipCode = json['zip_code']??"";
    state = json['state']??"";
    address = json['address']??"";
    totalDevices = json['total_devices'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['state'] = this.state;
    data['address'] = this.address;
    data['total_devices'] = this.totalDevices;
    return data;
  }
}
