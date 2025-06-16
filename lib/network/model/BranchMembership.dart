class BranchMemberShip {
  final String id;
  final String salonId;
  final String membershipName;
  final String description;
  final String subscriptionPlan;
  final int status;
  final int discount;
  final String discountType;
  final int membershipAmount;
  final SalonInfo? salonInfo;

  BranchMemberShip({
    required this.id,
    required this.salonId,
    required this.membershipName,
    required this.description,
    required this.subscriptionPlan,
    required this.status,
    required this.discount,
    required this.discountType,
    required this.membershipAmount,
    this.salonInfo,
  });

  factory BranchMemberShip.fromJson(Map<String, dynamic> json) {
    return BranchMemberShip(
      id: json['_id'] ?? '',
      salonId:
          json['salon_id'] is Map ? json['salon_id']['_id'] : json['salon_id'],
      membershipName: json['membership_name'] ?? '',
      description: json['description'] ?? '',
      subscriptionPlan: json['subscription_plan'] ?? '',
      status: json['status'] ?? 0,
      discount: json['discount'] ?? 0,
      discountType: json['discount_type'] ?? '',
      membershipAmount: json['membership_amount'] ?? 0,
      salonInfo:
          json['salon_id'] is Map ? SalonInfo.fromJson(json['salon_id']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['salon_id'] = this.salonId;
    data['membership_name'] = this.membershipName;
    data['description'] = this.description;
    data['subscription_plan'] = this.subscriptionPlan;
    data['status'] = this.status;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['membership_amount'] = this.membershipAmount;
    if (this.salonInfo != null) {
      data['salon_id'] = this.salonInfo!.toJson();
    }
    return data;
  }
}

class SalonInfo {
  final String id;
  final String salonName;
  final String description;
  final String address;
  final String contactNumber;
  final String contactEmail;
  final String openingTime;
  final String closingTime;
  final String category;
  final int status;
  final String image;

  SalonInfo({
    required this.id,
    required this.salonName,
    required this.description,
    required this.address,
    required this.contactNumber,
    required this.contactEmail,
    required this.openingTime,
    required this.closingTime,
    required this.category,
    required this.status,
    required this.image,
  });

  factory SalonInfo.fromJson(Map<String, dynamic> json) {
    return SalonInfo(
      id: json['_id'] ?? '',
      salonName: json['salon_name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['salon_name'] = this.salonName;
    data['description'] = this.description;
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['contact_email'] = this.contactEmail;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    data['category'] = this.category;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
