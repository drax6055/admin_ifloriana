import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'addCustomer/addCustomerController.dart'; // For BranchPackage

class Customer {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String gender;
  final List<String> branchPackage;
  final String branchMembership;
  final int status;
  final String branchMembershipId;
  final Map<String, dynamic>? branchMembershipObj;

  Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    this.branchPackage = const [],
    this.branchMembership = '',
    this.status = 1,
    this.branchMembershipId = '',
    this.branchMembershipObj,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      branchPackage: (json['branch_package'] as List?)
              ?.map((e) => e is Map ? e['_id']?.toString() ?? '' : e.toString())
              .toList() ??
          [],
      branchMembership: json['branch_membership'] is Map
          ? json['branch_membership']['_id']?.toString() ?? ''
          : json['branch_membership']?.toString() ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '1') ?? 1,
      branchMembershipId: json['branchMembership_id']?.toString() ?? '',
      branchMembershipObj: json['branch_membership'] is Map<String, dynamic>
          ? json['branch_membership'] as Map<String, dynamic>
          : null,
    );
  }
}

class CustomerController extends GetxController {
  var isLoading = false.obs;

  // Add these for add/edit flows
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var selectedGender = 'Male'.obs;
  var isActive = true.obs;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Package/Membership support
  var showPackageFields = false.obs;
  final packageController = MultiSelectController<BranchPackage>();
  var selectedPackages = <BranchPackage>[].obs;
  var selectedBranchMembership = ''.obs;
  var branchPackageList = <BranchPackage>[].obs;
  var branchMembershipList = <dynamic>[].obs;

  RxList<Customer> customerList = <Customer>[].obs;

  // Flags to track loading
  var packagesLoaded = false.obs;
  var membershipsLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
    getBranchPackages();
    getBranchMemberships();
  }

  Future<void> fetchCustomers() async {
    try {
      final loginUser = await prefs.getUser();

      final Map<String, dynamic> response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCustomersDetails}?salon_id=${loginUser!.salonId}',
        (json) => json as Map<String, dynamic>,
      );

      final List<dynamic> data = response['data'];
      customerList.value = data.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch customers: $e');
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      final loginUser = await prefs.getUser();
      isLoading.value = true;
      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.customers}/$customerId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        customerList.removeWhere((customer) => customer.id == customerId);
        CustomSnackbar.showSuccess('Success', 'Customer deleted successfully');
        await fetchCustomers();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete customer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCustomer(String customerId) async {
    try {
      final loginUser = await prefs.getUser();
      Map<String, dynamic> customerData = {
        'full_name': fullNameController.text,
        'email': emailController.text,
        'phone_number': phoneController.text,
        'gender': selectedGender.value.toLowerCase(),
        'status': isActive.value ? 1 : 0,
        'salon_id': loginUser!.salonId
      };
      if (showPackageFields.value) {
        final packageIds = selectedPackages
            .map((p) => p.id)
            .where((id) => id != null && id.toString().isNotEmpty)
            .toList();
        if (packageIds.isNotEmpty) {
          customerData['branch_package'] = packageIds;
        }
        customerData['branch_membership'] = selectedBranchMembership.value;
      }
      final response = await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.customers}/$customerId?salon_id=${loginUser!.salonId}',
        customerData,
        (json) => json,
      );
      // Update in list
      int index = customerList.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        customerList[index] = Customer(
          id: customerId,
          fullName: fullNameController.text,
          phoneNumber: phoneController.text,
          email: emailController.text,
          gender: selectedGender.value,
        );
        customerList.refresh();
      }
      Get.back();
      CustomSnackbar.showSuccess('Success', 'Customer updated successfully');
      await fetchCustomers();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to update customer: $e');
    }
  }

  Future<void> getBranchPackages() async {
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchpackagesNames}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      branchPackageList.value =
          data.map((e) => BranchPackage.fromJson(e)).toList();
      packagesLoaded.value = true;
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branch packages: $e');
      packagesLoaded.value = true;
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
      membershipsLoaded.value = true;
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branch memberships: $e');
      membershipsLoaded.value = true;
    }
  }
}
