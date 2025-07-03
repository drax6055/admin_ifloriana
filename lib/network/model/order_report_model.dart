class OrderReportModel {
  bool? success;
  List<OrderReportData>? data;

  OrderReportModel({this.success, this.data});

  OrderReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderReportData>[];
      json['data'].forEach((v) {
        data!.add(OrderReportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderReportData {
  CustomerId? customerId;
  num? totalPrice;
  String? paymentMethod;
  String? order_code;
  String? createdAt;
  int? productCount;

  OrderReportData(
      {this.customerId,
      this.totalPrice,
      this.paymentMethod,
      this.order_code,
      this.createdAt,
      this.productCount});

  OrderReportData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'] != null
        ? CustomerId.fromJson(json['customer_id'])
        : null;
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    order_code = json['order_code'];
    createdAt = json['createdAt'];
    productCount = json['productCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customerId != null) {
      data['customer_id'] = customerId!.toJson();
    }
    data['total_price'] = totalPrice;
    data['payment_method'] = paymentMethod;
    data['order_code'] = order_code;
    data['createdAt'] = createdAt;
    data['productCount'] = productCount;
    return data;
  }
}

class CustomerId {
  String? fullName;
  String? email;
  String? phoneNumber;

  CustomerId({this.fullName, this.email, this.phoneNumber});

  CustomerId.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    return data;
  }
}
