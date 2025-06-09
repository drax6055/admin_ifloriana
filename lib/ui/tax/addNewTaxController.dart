import 'package:flutter/cupertino.dart';
import 'package:flutter_template/network/model/taxmodel.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

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

class Addnewtaxcontroller extends GetxController {
  var titleController = TextEditingController();
  var valueController = TextEditingController();
  var selectedDropdownType = "Percent".obs;
  var selectedDropdownModule = "Services".obs;
  var isActive = true.obs;
  var branchList = <Branch>[].obs;
  var selectedBranches = <Branch>[].obs;
  bool get allSelected => selectedBranches.length == branchList.length;

  final List<String> dropdownType = [
    'Percent',
    'Fixed',
  ];
  final List<String> dropdownModule = [
    'Product',
    'Services',
  ];

  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  Future onTaxadded() async {
    final loginUser = await prefs.getUser();

    Map<String, dynamic> taxData = {
      "salon_id": loginUser!.salonId,
      "branch_id": selectedBranches.map((e) => e.id).toList(),
      "title": titleController.text.trim(),
      "value": int.tryParse(valueController.text.trim()) ?? 0,
      "type": selectedDropdownType.value.toLowerCase(),
      "tax_type": selectedDropdownModule.value.toLowerCase(),
      "status": isActive.value ? 1 : 0,
    };
    print("==> $taxData");
    try {
      await dioClient.postData<AddTex>(
        '${Apis.baseUrl}${Endpoints.postTex}',
        taxData,
        (json) => AddTex.fromJson(json),
      );
      CustomSnackbar.showSuccess('Succcess', 'tax added');
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
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }
}
