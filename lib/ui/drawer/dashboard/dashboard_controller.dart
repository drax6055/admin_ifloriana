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
    CalllApis();
  }

  void CalllApis() {
    getChartData();
    getDashbordData();
  }

  Future<void> getDashbordData() async {
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
        dashboardModel.value =
            Dashboard_model.fromJson(response['data'] ?? response);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch branches: $e');
    }
  }

  Future<void> getChartData() async {
    try {
      final loginUser = await prefs.getUser();

      final today = DateTime.now();
      final oneWeekAgo = today.subtract(Duration(days: 7));

      final String endDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final String startDate =
          "${oneWeekAgo.year}-${oneWeekAgo.month.toString().padLeft(2, '0')}-${oneWeekAgo.day.toString().padLeft(2, '0')}";

      final response = await dioClient.getData(
        '${Apis.baseUrl}/dashboard/dashboard-summary?salon_id=${loginUser!.salonId}&startDate=$startDate&endDate=$endDate',
        (json) => json,
      );
      if (response != null) {
        // Only update the chart fields, keep the rest of the dashboard data
        final data = response['data'] ?? response;
        dashboardModel.update((model) {
          model?.lineChart = (data['lineChart'] as List?)
              ?.map((e) => LineChartDataPoint.fromJson(e))
              .toList();
          model?.barChart = (data['barChart'] as List?)
              ?.map((e) => BarChartDataPoint.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch chart data: $e');
    }
  }
}
