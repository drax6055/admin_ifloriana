import 'package:flutter/widgets.dart';
import 'package:flutter_template/network/model/productSubCategory.dart';
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

class Subcategorycontroller extends GetxController {
  final subCategories = <ProductSubCategory>[].obs;
  final isLoading = false.obs;
  var isActive = true.obs;
  var branchList = <Branch1>[].obs;
  var selectedBranches = <Branch1>[].obs;
  var nameController = TextEditingController();
  final branchController = MultiSelectController<Branch1>();

  @override
  void onInit() {
    super.onInit();
    getSubCategories();
    getBranches();
  }

  @override
  void onClose() {
    nameController.dispose();
    branchController.dispose();
    super.onClose();
  }

  Future<void> getSubCategories() async {
    final loginUser = await prefs.getUser();
    try {
      isLoading.value = true;
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getProductSubCategories}${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        subCategories.value =
            data.map((json) => ProductSubCategory.fromJson(json)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSubCategory(String subCategoryId) async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();

      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.productSubcategory}/$subCategoryId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        // Remove the deleted subcategory from the list
        subCategories
            .removeWhere((subCategory) => subCategory.id == subCategoryId);
        getSubCategories();
        CustomSnackbar.showSuccess(
            'Success', 'SubCategory deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete subcategory: $e');
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

  Future onAddSubCategory() async {
    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter subcategory name');
      return;
    }

    if (selectedBranches.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one branch');
      return;
    }

    final loginUser = await prefs.getUser();

    // Create subcategory data with multiple branch IDs
    Map<String, dynamic> subCategoryData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId
    };

    try {
      // await dioClient.postData(
      //   '${Apis.baseUrl}${Endpoints.postProductSubCategory}',
      //   subCategoryData,
      //   (json) => json,
      // );
      getSubCategories();
      CustomSnackbar.showSuccess('Success', 'SubCategory Added Successfully');
      Get.back(); // Close the bottom sheet
      resetForm(); // Reset the form
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
