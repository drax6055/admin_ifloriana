class AddsalonDetails {
  String? message;
  Data? data;

  AddsalonDetails({this.message, this.data});

  AddsalonDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? slug;
  String? name;
  String? description;
  String? address;
  String? contactNumber;
  String? contactEmail;
  String? openingTime;
  String? closingTime;
  String? category;
  int? status;
  int? packageId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.slug,
      this.name,
      this.description,
      this.address,
      this.contactNumber,
      this.contactEmail,
      this.openingTime,
      this.closingTime,
      this.category,
      this.status,
      this.packageId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    contactNumber = json['contact_number'];
    contactEmail = json['contact_email'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    category = json['Category'];
    status = json['status'];
    packageId = json['package_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['name'] = this.name;
    data['description'] = this.description;
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['contact_email'] = this.contactEmail;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    data['Category'] = this.category;
    data['status'] = this.status;
    data['package_id'] = this.packageId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
