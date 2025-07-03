import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/dashboard_model.dart';
import '../../../wiget/custome_snackbar.dart';

class DashboardController extends GetxController {
  var dashboardModel = Dashboard_model().obs;

  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  Future<void> getBranches() async {
    try {
      final loginUser = await prefs.getUser();
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      final response = await dioClient.getData(
        '${Apis.baseUrl}/dashboard?salon_id=${loginUser!.salonId}&month=$currentMonth&year=$currentYear',
        (json) => json,
      );
      if (response != null) {
        dashboardModel.value = Dashboard_model.fromJson(response);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch branches: $e');
    }
  }
}
