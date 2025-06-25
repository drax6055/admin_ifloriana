import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/staff_service_report_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class StaffServiceReportController extends GetxController {
  final staffServiceReports = <StaffServiceReportData>[].obs;
  final filteredStaffServiceReports = <StaffServiceReportData>[].obs;
  final grandTotal = 0.0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getStaffServiceReports();
  }

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      filteredStaffServiceReports.value = staffServiceReports;
    } else {
      filteredStaffServiceReports.value = staffServiceReports
          .where((report) =>
              report.staffName?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
    calculateGrandTotal();
  }

  Future<void> getStaffServiceReports() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.staffServiceReport}?salon_id=${loginUser!.salonId}',
        (json) {
          final model = StaffServiceReportModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        staffServiceReports.value = response.data!;
        filteredStaffServiceReports.value = response.data!;
        calculateGrandTotal();
      }
    } catch (e) {
      CustomSnackbar.showError(
          'Error', 'Failed to fetch staff service reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateGrandTotal() {
    double total = 0;
    for (var report in filteredStaffServiceReports) {
      total += report.totalAmount ?? 0;
    }
    grandTotal.value = total;
  }
}
