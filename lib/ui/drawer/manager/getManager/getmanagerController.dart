
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

  Manager({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.branchName,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      branchName: json['branch_id']?['name'] ?? '',
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
        'http://192.168.1.4:5000/api/managers?salon_id=684011271ee646f27873fddc',
        (json) => json,
      );
      final data = response['data'] as List;
      managers.value = data.map((e) => Manager.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }
}
