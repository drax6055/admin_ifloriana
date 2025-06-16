import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/BranchMembership.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class BranchMembershipListController extends GetxController {
  var memberships = <BranchMemberShip>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMemberships();
  }

  Future<void> fetchMemberships() async {
    final loginUser = await prefs.getUser();
    try {
      isLoading.value = true;
      final response = await dioClient.getData<Map<String, dynamic>>(
        '${Apis.baseUrl}/branch-memberships?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        memberships.value =
            data.map((json) => BranchMemberShip.fromJson(json)).toList();
      }
    } catch (e) {
      print('==> Error fetching memberships: $e');
      CustomSnackbar.showError('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMembership(String membershipId) async {
    try {
      final loginUser = await prefs.getUser();
      isLoading.value = true;
      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.postBranchMembership}/$membershipId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null) {
        memberships.removeWhere((m) => m.id == membershipId);
        CustomSnackbar.showSuccess(
            'Success', 'Membership deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete membership: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
