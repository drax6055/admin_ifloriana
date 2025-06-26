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

class Category {
  final String? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Tag {
  final String? id;
  final String? name;

  Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Unit {
  final String? id;
  final String? name;

  Unit({this.id, this.name});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Getallproductscontroller extends GetxController {
  var branchList = <Branch>[].obs;
  var selectedBranch = Rx<Branch?>(null);
  var selectedCategory = Rx<Category?>(null);
  var categoryList = <Category>[].obs;
  var tagList = <Tag>[].obs;
  var selectedTag = Rx<Tag?>(null);
  var unitList = <Unit>[].obs;
  var selectedUnit = Rx<Unit?>(null);

  @override
  void onInit() {
    super.onInit();
    getBranches();
    getCatedory();
    getTags();
    getUnits();
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

  Future<void> getCatedory() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getproductName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      categoryList.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getTags() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getTagsName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      tagList.value = data.map((e) => Tag.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get tags: $e');
    }
  }

  Future<void> getUnits() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getUnitNames}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      unitList.value = data.map((e) => Unit.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get units: $e');
    }
  }
}
