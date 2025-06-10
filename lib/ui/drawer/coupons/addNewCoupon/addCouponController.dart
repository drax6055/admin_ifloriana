import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/addCoupons.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsController.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class CouponModel {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? type;
  final String? discountType;
  final int? discountAmount;
  final int? useLimit;
  final int? status;

  CouponModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.type,
    this.discountType,
    this.discountAmount,
    this.useLimit,
    this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'],
      name: json['name'],
      code: json['coupon_code'],
      description: json['description'],
      type: json['coupon_type'],
      discountType: json['discount_type'],
      discountAmount: json['discount_amount'],
      useLimit: json['use_limit'],
      status: json['status'],
    );
  }
}

class Branch {
  final String? id;
  final String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Addcouponcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var coponCodeController = TextEditingController();
  var discountAmtController = TextEditingController();
  var userLimitController = TextEditingController();
  var isActive = true.obs;
  var selectedCouponType = "Custom".obs;
  var couponList = <CouponModel>[].obs;
  var StarttimeController = TextEditingController();
  var EndtimeController = TextEditingController();
  var branchList = <Branch>[].obs;
  var selectedBranches = <Branch>[].obs;
  bool get allSelected => selectedBranches.length == branchList.length;

  var selectedDiscountType = "Percent".obs;
  final List<String> dropdownCouponTypeItem = [
    'Custom',
    'Bulk',
    'Seasonal',
    'Event'
  ];

  final List<String> dropdownDiscountTypeItem = ['Percent', 'Fixed'];
  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onCoupons() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> couponData = {
      "image": null,
      "name": nameController.text,
      "description": descriptionController.text,
      "start_date": StarttimeController.text,
      "end_date": EndtimeController.text,
      "coupon_type": selectedCouponType.value.toLowerCase(),
      "coupon_code": coponCodeController.text,
      "discount_type": selectedDiscountType.value.toLowerCase(),
      "discount_amount": discountAmtController.text,
      "use_limit": userLimitController.text,
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      "branch_id": selectedBranches.map((e) => e.id).toList(),
    };
    try {
      await dioClient.postData<AddCoupons>(
        '${Apis.baseUrl}${Endpoints.coupons}',
        couponData,
        (json) => AddCoupons.fromJson(json),
      );
      var updateList = Get.put(CouponsController());
      updateList.getCoupons();
      Get.back();
      CustomSnackbar.showSuccess('success', 'Login Successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
