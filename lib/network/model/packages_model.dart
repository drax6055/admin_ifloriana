class Package_model {
  int? id;
  String? name;
  double? price; 
  String? description;
  List<String>? servicesIncluded;
  String? expirationDate;
  String? subscriptionPlan;
  String? createdAt;
  String? updatedAt;

  Package_model(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.servicesIncluded,
      this.expirationDate,
      this.subscriptionPlan,
      this.createdAt,
      this.updatedAt});

  Package_model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];

    description = json['description'];
    servicesIncluded = json['services_included'].cast<String>();
    expirationDate = json['expiration_date'];
    subscriptionPlan = json['subscription_plan'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price; 
    data['description'] = this.description;
    data['services_included'] = this.servicesIncluded;
    data['expiration_date'] = this.expirationDate;
    data['subscription_plan'] = this.subscriptionPlan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
