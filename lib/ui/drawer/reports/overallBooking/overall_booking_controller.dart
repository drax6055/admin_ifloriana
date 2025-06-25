import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/overall_booking_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class OverallBookingController extends GetxController {
  final overallBookings = <OverallBookingData>[].obs;
  final grandTotal = 0.0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getOverallBookings();
  }

  Future<void> getOverallBookings() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.overallBookings}?salon_id=${loginUser!.salonId}',
        (json) {
          final model = OverallBookingModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        overallBookings.value = response.data!;
        calculateGrandTotal();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch overall bookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateGrandTotal() {
    double total = 0;
    for (var booking in overallBookings) {
      total += booking.totalAmount ?? 0;
    }
    grandTotal.value = total;
  }
}
