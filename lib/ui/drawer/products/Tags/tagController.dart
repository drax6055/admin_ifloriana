import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../../main.dart';
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


class Tagcontroller extends GetxController {
  var isActive = true.obs;
  var branchList = <Branch1>[].obs;
  var selectedBranches = <Branch1>[].obs;
  var nameController = TextEditingController();
  final branchController = MultiSelectController<Branch1>();

  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  @override
  void onClose() {
    nameController.dispose();
    branchController.dispose();
    super.onClose();
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

    final loginUser = await prefs.getUser();
    Map<String, dynamic> subCategoryData = {
    
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
    };

    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.postTags}',
        subCategoryData,
        (json) => json,
      );

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
