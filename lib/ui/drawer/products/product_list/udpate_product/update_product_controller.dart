import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../../network/network_const.dart';
import '../../../../../wiget/custome_snackbar.dart';

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

class UpdateProductController extends GetxController {
  var branchList = <Branch>[].obs;
  var selectedBranch = Rx<Branch?>(null);

  @override
  void onInit() {
    getBranches();
    super.onInit();
  }

  Future<void> getBranches() async {
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
          '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
          (json) => json);
      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get branches: $e');
    }
  }
}
