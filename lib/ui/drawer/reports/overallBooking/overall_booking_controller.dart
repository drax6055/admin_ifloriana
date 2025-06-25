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

  final searchQuery = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<DateTimeRange?> selectedDateRange = Rx<DateTimeRange?>(null);

  @override
  void onInit() {
    super.onInit();
    getOverallBookings();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedDateRange.value = null;
    _applyFilters();
  }

  void selectDateRange(DateTimeRange range) {
    selectedDateRange.value = range;
    selectedDate.value = null;
    _applyFilters();
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedDate.value = null;
    selectedDateRange.value = null;
    _applyFilters();
  }

  void _applyFilters() {
    List<OverallBookingData> filtered = List.from(overallBookings);

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((booking) =>
              booking.staffName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false)
          .toList();
    }

    if (selectedDate.value != null) {
      filtered = filtered.where((booking) {
        if (booking.appointmentDate == null) return false;
        final bookingDate = DateTime.tryParse(booking.appointmentDate!);
        final filterDate = selectedDate.value!;
        return bookingDate != null &&
            bookingDate.year == filterDate.year &&
            bookingDate.month == filterDate.month &&
            bookingDate.day == filterDate.day;
      }).toList();
    }

    if (selectedDateRange.value != null) {
      filtered = filtered.where((booking) {
        if (booking.appointmentDate == null) return false;
        final bookingDate = DateTime.tryParse(booking.appointmentDate!);
        final filterRange = selectedDateRange.value!;
        return bookingDate != null &&
            !bookingDate.isBefore(filterRange.start) &&
            !bookingDate.isAfter(filterRange.end);
      }).toList();
    }

    filteredOverallBookings.value = filtered;
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
