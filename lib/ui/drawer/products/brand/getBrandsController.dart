import 'package:flutter/widgets.dart';
import 'package:flutter_template/network/model/brand.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../main.dart';

import '../../../../network/model/addBrand.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class Branch1 {
  final String? id;
  final String? name;

  Branch1({this.id, this.name});

  factory Branch1.fromJson(Map<String, dynamic> json) {
    return Branch1(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Getbrandscontroller extends GetxController {
  final brands = <Brand>[].obs;
  final isLoading = false.obs;
  var isActive = true.obs;
  var branchList = <Branch1>[].obs;
  var selectedBranches = <Branch1>[].obs;
  var nameController = TextEditingController();
  final branchController = MultiSelectController<Branch1>();

  @override
  void onInit() {
    super.onInit();
    getBrands();
    getBranches();
  }

  @override
  void onClose() {
    nameController.dispose();
    branchController.dispose();
    super.onClose();
  }

  Future<void> getBrands() async {
    final loginUser = await prefs.getUser();
    try {
      isLoading.value = true;
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBrands}${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        brands.value = data.map((json) => Brand.fromJson(json)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();

      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.postBrands}/$brandId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        // Remove the deleted brand from the list
        brands.removeWhere((brand) => brand.id == brandId);
        getBrands();
        CustomSnackbar.showSuccess('Success', 'Brand deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete brand: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch1.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onAddBranch() async {
    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter brand name');
      return;
    }

    if (selectedBranches.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one branch');
      return;
    }

    final loginUser = await prefs.getUser();

    // Create brand data with multiple branch IDs
    Map<String, dynamic> brandData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId
    };

    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.postBrands}',
        brandData,
        (json) => AddBrand.fromJson(json),
      );
      getBrands();
      Get.back(); // Close the bottom sheet
      resetForm();
      CustomSnackbar.showSuccess(
          'Success', 'Brand Added Successfully'); // Reset the form
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> updateBrand(String brandId) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> brandData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.postBrands}/$brandId',
        brandData,
        (json) => AddBrand.fromJson(json),
      );
      await getBrands();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Brand updated successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  void resetForm() {
    nameController.clear();
    isActive.value = true;
    selectedBranches.clear();
  }
}
