import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/overall_booking_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class OverallBookingController extends GetxController {
  final overallBookings = <OverallBookingData>[].obs;
  final filteredOverallBookings = <OverallBookingData>[].obs;
  final grandTotal = 0.0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getOverallBookings();
  }

  void applyDateFilter({DateTime? singleDate, DateTimeRange? dateRange}) {
    if (singleDate == null && dateRange == null) {
      filteredOverallBookings.value = overallBookings;
    } else if (singleDate != null) {
      filteredOverallBookings.value = overallBookings.where((booking) {
        if (booking.appointmentDate == null) return false;
        final bookingDate = DateTime.tryParse(booking.appointmentDate!);
        return bookingDate != null &&
            bookingDate.year == singleDate.year &&
            bookingDate.month == singleDate.month &&
            bookingDate.day == singleDate.day;
      }).toList();
    } else if (dateRange != null) {
      filteredOverallBookings.value = overallBookings.where((booking) {
        if (booking.appointmentDate == null) return false;
        final bookingDate = DateTime.tryParse(booking.appointmentDate!);
        return bookingDate != null &&
            !bookingDate.isBefore(dateRange.start) &&
            !bookingDate.isAfter(dateRange.end);
      }).toList();
    }
    calculateGrandTotal();
  }

  void clearFilter() {
    filteredOverallBookings.value = overallBookings;
    calculateGrandTotal();
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
        filteredOverallBookings.value = response.data!;
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
    for (var booking in filteredOverallBookings) {
      total += booking.totalAmount ?? 0;
    }
    grandTotal.value = total;
  }
}
