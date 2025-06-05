import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class GetStaffDetails {
  String? message;
  List<Data>? data;

  GetStaffDetails({this.message, this.data});

  GetStaffDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? fullName;
  String? email;
  BranchId? branchId;
  String? image;
  List<Service>? serviceId;
    int? status;

  Data({
    this.fullName,
    this.email,
    this.branchId,
    this.image,
    this.serviceId,
     this.status,
     
  });

  Data.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    branchId =
        json['branch_id'] != null ? BranchId.fromJson(json['branch_id']) : null;
    image = json['image'];
    status = json['status'];
    serviceId = [];
    if (json['service_id'] != null && json['service_id'] is List) {
      for (var item in json['service_id']) {
        if (item is String) {
          serviceId!.add(Service(id: item));
        } else if (item is Map<String, dynamic>) {
          serviceId!.add(Service.fromJson(item));
        }
      }
    }
  }
}

class BranchId {
  String? name;

  BranchId({this.name});

  BranchId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

// ✅ Full Service class updated to support all fields from API response
class Service {
  String? id;
  String? name;
  String? image;
  int? serviceDuration;
  String? categoryId;
  String? description;
  int? status;
  String? salonId;
  String? createdAt; 
  String? updatedAt;
  int? v;
  int? membersPrice;
  int? regularPrice;

  Service({
    this.id,
    this.name,
    this.image,
    this.serviceDuration,
    this.categoryId,
    this.description,
    this.status,
    this.salonId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.membersPrice,
    this.regularPrice,
  });

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? json['id']?.toString();
    name = json['name'];
    image = json['image'];
    serviceDuration = json['service_duration'];
    categoryId = json['category_id'];
    description = json['description'];
    status = json['status'] is int
        ? json['status']
        : int.tryParse(json['status']?.toString() ?? '');
    salonId = json['salon_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    membersPrice = json['members_price'];
    regularPrice = json['regular_price'];
  }
}

class Staffdetailscontroller extends GetxController {
  var staffList = <Data>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerDetails();
  }

  Future<void> getCustomerDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getStaffDetails}',
        (json) => GetStaffDetails.fromJson(json),
      );
      staffList.value = response.data ?? [];
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
