class UpdateSalonDetails {
  String message;
  Salon salon;

  UpdateSalonDetails({required this.message, required this.salon});

  factory UpdateSalonDetails.fromJson(Map<String, dynamic> json) {
    return UpdateSalonDetails(
      message: json['message'],
      salon: Salon.fromJson(json['salon']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'salon': salon.toJson(),
    };
  }
}

class Salon {
  int id;
  String name;
  String description;
  String address;
  String contactNumber;
  String contactEmail;
  String openingTime;
  String closingTime;
  String category;
  int status;
  int packageId;
  int signupId;
  String createdAt;
  String updatedAt;

  Salon({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.contactNumber,
    required this.contactEmail,
    required this.openingTime,
    required this.closingTime,
    required this.category,
    required this.status,
    required this.packageId,
    required this.signupId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      contactNumber: json['contact_number'],
      contactEmail: json['contact_email'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      category: json['Category'],
      status: json['status'],
      packageId: json['package_id'],
      signupId: json['signup_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'contact_number': contactNumber,
      'contact_email': contactEmail,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'Category': category,
      'status': status,
      'package_id': packageId,
      'signup_id': signupId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
