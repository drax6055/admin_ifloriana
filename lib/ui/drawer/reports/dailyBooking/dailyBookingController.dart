import 'package:flutter_template/network/model/daily_booking_model.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class Dailybookingcontroller extends GetxController {
  final dailyReports = <DailyBookingData>[].obs;
  final grandTotal = 0.0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getDailyReport();
  }

  Future<void> getDailyReport() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.dailyBookings}/?salon_id=${loginUser!.salonId}',
        (json) {
          final model = DailyBookingModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        dailyReports.value = response.data!;
        calculateGrandTotal();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch daily reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateGrandTotal() {
    double total = 0;
    for (var report in dailyReports) {
      total += report.finalAmount ?? 0;
    }
    grandTotal.value = total;
  }
}
