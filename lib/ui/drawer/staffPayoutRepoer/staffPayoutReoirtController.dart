import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../wiget/custome_snackbar.dart';
import 'staff_payout_model.dart';

class StatffearningReportcontroller extends GetxController {
  var payouts = <StaffPayout>[].obs;
  var isLoading = true.obs;
  var filterText = ''.obs;

  List<StaffPayout> get filteredPayouts {
    if (filterText.value.isEmpty) return payouts;
    return payouts
        .where((p) =>
            p.staffName.toLowerCase().contains(filterText.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    getStaffEarningDataReport();
  }

  Future<void> getStaffEarningDataReport() async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}/staff-payouts?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response['success'] == true && response['data'] != null) {
        payouts.value = List<StaffPayout>.from(
          response['data'].map((x) => StaffPayout.fromJson(x)),
        );
      } else {
        payouts.clear();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', ': $e');
    } finally {
      isLoading.value = false;
    }
  }
}
