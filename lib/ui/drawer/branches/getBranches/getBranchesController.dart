import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';
import '../../../../network/model/branch_model.dart';

class Getbranchescontroller extends GetxController {
  final RxList<BranchModel> branches = <BranchModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  Future<void> getBranches() async {
    isLoading.value = true;
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranches}${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> branchesData = response['data'];
        branches.value =
            branchesData.map((branch) => BranchModel.fromJson(branch)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch branches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
       final loginUser = await prefs.getUser();
      isLoading.value = true;
      final response = await dioClient.deleteData(
           '${Apis.baseUrl}${Endpoints.postBranchs}/$branchId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        // Remove the branch from the local list
        branches.removeWhere((branch) => branch.id == branchId);
        CustomSnackbar.showSuccess('Success', 'Branch deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete branch: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
