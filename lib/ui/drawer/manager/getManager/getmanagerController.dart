import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../wiget/custome_snackbar.dart';

class Manager {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String branchName;
  final String? branchId;

  Manager({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.branchName,
    this.branchId,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      branchName: json['branch_id']?['name'] ?? '',
      branchId: json['branch_id']?['_id'],
    );
  }
}

class Getmanagercontroller extends GetxController {
  RxList<Manager> managers = <Manager>[].obs;

  @override
  void onInit() {
    super.onInit();
    getManagers();
  }

  Future<void> getManagers() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getManager}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      managers.value = data.map((e) => Manager.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> deleteManager(String? managerId) async {
    final loginUser = await prefs.getUser();
    if (managerId == null) return;
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.addManager}/$managerId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      managers.removeWhere((m) => m.id == managerId);
      CustomSnackbar.showSuccess('Deleted', 'Manager deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete manager: $e');
    }
  }
}
