import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';



class Salon {
  final String? id;
  final String? salonName;
  final String? description;
  final String? address;
  final String? contactNumber;
  final String? contactEmail;
  final String? openingTime;
  final String? closingTime;
  final String? category;
  final int? status;
  final String? packageId;
  final String? signupId;
  final String? createdAt;
  final String? updatedAt;
  final String? image;

  Salon({
    this.id,
    this.salonName,
    this.description,
    this.address,
    this.contactNumber,
    this.contactEmail,
    this.openingTime,
    this.closingTime,
    this.category,
    this.status,
    this.packageId,
    this.signupId,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['_id'],
      salonName: json['salon_name'],
      description: json['description'],
      address: json['address'],
      contactNumber: json['contact_number'],
      contactEmail: json['contact_email'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      category: json['category'],
      status: json['status'],
      packageId: json['package_id'],
      signupId: json['signup_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      image: json['image'],
    );
  }
}

class BranchPackage {
  final String? id;
  final String? packageName;

  BranchPackage({this.id, this.packageName});

  factory BranchPackage.fromJson(Map<String, dynamic> json) {
    return BranchPackage(
      id: json['_id'],
      packageName: json['package_name'],
    );
  }
}

class BranchMembership {
  final String? id;
  final String? membershipName;

  BranchMembership({this.id, this.membershipName});

  factory BranchMembership.fromJson(Map<String, dynamic> json) {
    return BranchMembership(
      id: json['_id'],
      membershipName: json['membership_name'],
    );
  }
}

class CustomerController extends GetxController {

  var isLoading = false.obs;
  var isActive = true.obs;
  var showPackageFields = false.obs;

  // Controllers
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  // Dropdown values
  var selectedGender = ''.obs;
  var selectedBranchPackage = ''.obs;
  var selectedBranchMembership = ''.obs;

  // Lists for dropdowns
  var branchPackageList = <BranchPackage>[].obs;
  var branchMembershipList = <BranchMembership>[].obs;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void onInit() {
    super.onInit();

    getBranchPackages();
    getBranchMemberships();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }



  Future<void> getBranchPackages() async {
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchpackagesNames}?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchPackageList.value =
          data.map((e) => BranchPackage.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branch packages: $e');
    }
  }

  Future<void> getBranchMemberships() async {
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchMembershipNames}?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchMembershipList.value =
          data.map((e) => BranchMembership.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branch memberships: $e');
    }
  }

  Future<void> addCustomer() async {
    try {
      final loginUser = await prefs.getUser();
      Map<String, dynamic> customerData = {
        'salon_id': loginUser!.salonId,
        'full_name': fullNameController.text,
        'email': emailController.text,
        'gender': selectedGender.value.toLowerCase(),
        'password': passwordController.text,
        'phone_number': phoneController.text,
        'status': isActive.value ? 1 : 0,
      };

      if (showPackageFields.value) {
        customerData['branch_package'] = selectedBranchPackage.value;
        customerData['branch_membership'] = selectedBranchMembership.value;
      }

      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.customers}',
        customerData,
        (json) => json,
      );

      // Clear form
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      selectedGender.value = '';
      selectedBranchPackage.value = '';
      selectedBranchMembership.value = '';
      isActive.value = true;
      showPackageFields.value = false;

      CustomSnackbar.showSuccess('Success', 'Customer added successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to add customer: $e');
    }
  }

  
}
