class Sigm_up_model {
  String? fullName;
  String? salonName;
  String? phoneNumber;
  String? email;
  String? address;
  String? packageId;
  SalonDetails? salonDetails;
  String? adminId;
  String? salonId;

  Sigm_up_model(
      {this.fullName,
      this.salonName,
      this.phoneNumber,
      this.email,
      this.address,
      this.packageId,
      this.salonDetails,
      this.adminId,
      this.salonId});

  Sigm_up_model.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    salonName = json['salon_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    address = json['address'];
    packageId = json['package_id'];
    salonDetails = json['salonDetails'] != null
        ? new SalonDetails.fromJson(json['salonDetails'])
        : null;
    adminId = json['admin_id'];
    salonId = json['salon_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['salon_name'] = this.salonName;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['package_id'] = this.packageId;
    if (this.salonDetails != null) {
      data['salonDetails'] = this.salonDetails!.toJson();
    }
    data['admin_id'] = this.adminId;
    data['salon_id'] = this.salonId;
    return data;
  }
}

class SalonDetails {
  String? name;
  String? email;
  String? phoneNumber;
  String? description;
  String? image;
  String? openingTime;
  String? closingTime;
  String? category;

  SalonDetails(
      {this.name,
      this.email,
      this.phoneNumber,
      this.description,
      this.image,
      this.openingTime,
      this.closingTime,
      this.category});

  SalonDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    description = json['description'];
    image = json['image'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['description'] = this.description;
    data['image'] = this.image;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    data['category'] = this.category;
    return data;
  }
}
