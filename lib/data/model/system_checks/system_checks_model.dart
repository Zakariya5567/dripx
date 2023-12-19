class SystemCheckModel {
  bool? success;
  int? status;
  List<SystemCheck>? systemCheck;

  SystemCheckModel({this.success, this.status, this.systemCheck});

  SystemCheckModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['result'] != null) {
      systemCheck = <SystemCheck>[];
      json['result'].forEach((v) {
        systemCheck!.add(new SystemCheck.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    if (this.systemCheck != null) {
      data['result'] = this.systemCheck!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SystemCheck {
  String? text;
  bool? value;
  String? key;
  bool? required;

  SystemCheck({this.text, this.value, this.key, this.required});

  SystemCheck.fromJson(Map<String, dynamic> json) {
    text = json['text']??"";
    value = json['value']??false;
    key = json['key']??"";
    required = json['required']??false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    data['key'] = this.key;
    data['required'] = this.required;
    return data;
  }
}
