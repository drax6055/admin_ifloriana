import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/order_report_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class OrderReportController extends GetxController {
  final orderReports = <OrderReportData>[].obs;
  final filteredOrderReports = <OrderReportData>[].obs;
  final grandTotal = 0.0.obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getOrderReports();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredOrderReports.value = orderReports;
    } else {
      filteredOrderReports.value = orderReports
          .where((report) =>
              report.customerId?.fullName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false)
          .toList();
    }
    calculateGrandTotal();
  }

  Future<void> getOrderReports() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.orderReport}?salon_id=${loginUser!.salonId}',
        (json) {
          final model = OrderReportModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        orderReports.value = response.data!;
        filteredOrderReports.value = response.data!;
        calculateGrandTotal();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch order reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateGrandTotal() {
    double total = 0;
    for (var report in filteredOrderReports) {
      total += report.totalPrice ?? 0;
    }
    grandTotal.value = total;
  }
}
