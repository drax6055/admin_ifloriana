class Sigm_up_model {
  String? message;
  Admin? admin;

  Sigm_up_model({this.message, this.admin});

  Sigm_up_model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    return data;
  }
}

class Admin {
  String? fullName;
  String? salonName;
  String? phoneNumber;
  String? email;
  String? address;
  String? packageId;

  Admin(
      {this.fullName,
      this.salonName,
      this.phoneNumber,
      this.email,
      this.address,
      this.packageId});

  Admin.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    salonName = json['salon_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    address = json['address'];
    packageId = json['package_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['salon_name'] = this.salonName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['package_id'] = this.packageId;
    return data;
  }
}
  