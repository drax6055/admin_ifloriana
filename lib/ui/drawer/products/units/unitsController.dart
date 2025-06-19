import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../main.dart';
import '../../../../network/model/postUnits.dart';
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

class Unitscontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  var nameController = TextEditingController();
  var isActive = true.obs;
  var selectedBranches = <Branch1>[].obs;
  final branchController = MultiSelectController<Branch1>();
  var branchList = <Branch1>[].obs;

  Future onUniteAdd() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> unitsData = {
      'name': nameController.text,
      'status': isActive.value ? 1 : 0,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'salon_id': loginUser!.salonId,
    };

    try {
      await dioClient.postData<PostUnits>(
        '${Apis.baseUrl}${Endpoints.postUnits}',
        unitsData,
        (json) => PostUnits.fromJson(json),
      );
      CustomSnackbar.showSuccess('Succcess', 'Units Added');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
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
}
