import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';

import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class Appointment {
  final String appointmentId;
  final String date;
  final String time;
  final String clientName;
  final String? clientImage;
  final int amount;
  final String staffName;
  final String? staffImage;
  final String serviceName;
  final String? membership;
  final String? package;
  final String status;
  final String paymentStatus;

  Appointment({
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.clientName,
    this.clientImage,
    required this.amount,
    required this.staffName,
    this.staffImage,
    required this.serviceName,
    this.membership,
    this.package,
    required this.status,
    required this.paymentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] ?? {};
    final services = (json['services'] as List?) ?? [];
    final firstService = services.isNotEmpty ? services[0] : {};
    final service = firstService['service'] ?? {};
    final staff = firstService['staff'] ?? {};
    return Appointment(
      appointmentId: json['appointment_id'] ?? '',
      date: (json['appointment_date'] ?? '').toString().split('T')[0],
      time: json['appointment_time'] ?? '',
      clientName: customer['full_name'] ?? '-',
      clientImage: customer['image'],
      amount: (json['total_payment'] ?? 0) is int
          ? json['total_payment']
          : int.tryParse(json['total_payment'].toString()) ?? 0,
      staffName: staff['full_name'] ?? '-',
      staffImage: staff['image'],
      serviceName: service['name'] ?? '-',
      membership: customer['branch_membership'] != null ? 'Yes' : '-',
      package: (customer['branch_package'] != null &&
              (customer['branch_package'] is List
                  ? customer['branch_package'].isNotEmpty
                  : true))
          ? 'Yes'
          : '-',
      status: json['status'] ?? '-',
      paymentStatus: json['payment_status'] ?? '-',
    );
  }
}

class TaxModel {
  final String id;
  final String title;
  final double value;

  TaxModel({required this.id, required this.title, required this.value});

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      value: (json['value'] is int)
          ? (json['value'] as int).toDouble()
          : (json['value'] ?? 0).toDouble(),
    );
  }
}

class CouponModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String discountType;
  final double discountAmount;
  final int status;

  CouponModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.discountType,
    required this.discountAmount,
    required this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] ?? '',
      code: json['coupon_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountAmount: (json['discount_amount'] is int)
          ? (json['discount_amount'] as int).toDouble()
          : (json['discount_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
    );
  }
}

class PaymentSummaryState {
  Rx<TaxModel?> selectedTax = Rx<TaxModel?>(null);
  RxString tips = '0'.obs;
  RxString paymentMethod = ''.obs;
  RxString couponCode = ''.obs;
  Rx<CouponModel?> appliedCoupon = Rx<CouponModel?>(null);
  RxBool addAdditionalDiscount = false.obs;
  RxString discountType = 'percentage'.obs;
  RxString discountValue = '0'.obs;
  RxDouble grandTotal = 0.0.obs;
}

class AppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = false.obs;
  var taxes = <TaxModel>[].obs;
  var coupons = <CouponModel>[].obs;
  var paymentSummaryState = PaymentSummaryState();

  @override
  void onInit() {
    super.onInit();
    getTax();
    getCoupons();
    getAppointment();
  }

  Future<void> getAppointment() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}/appointments?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['success'] == true) {
        final List data = response['data'] ?? [];
        appointments.value = data.map((e) => Appointment.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTax() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getTex}${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['data'] != null) {
        final List data = response['data'] ?? [];
        taxes.value = data.map((e) => TaxModel.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCoupons() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCoupons}${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['data'] != null) {
        final List data = response['data'] ?? [];
        coupons.value = data.map((e) => CouponModel.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyCoupon(String code) {
    final now = DateTime.now();
    final coupon = coupons.firstWhereOrNull((c) {
      final start = DateTime.tryParse(c.startDate);
      final end = DateTime.tryParse(c.endDate);
      return c.code.toLowerCase() == code.toLowerCase() &&
          c.status == 1 &&
          start != null &&
          end != null &&
          now.isAfter(start) &&
          now.isBefore(end.add(const Duration(days: 1)));
    });
    if (coupon != null) {
      paymentSummaryState.appliedCoupon.value = coupon;
      CustomSnackbar.showSuccess('Coupon Applied', coupon.code);
    } else {
      paymentSummaryState.appliedCoupon.value = null;
      CustomSnackbar.showError(
          'Invalid Coupon', 'Coupon is not active or does not exist');
    }
  }

  void calculateGrandTotal(double serviceAmount) {
    double total = serviceAmount;
    // Apply coupon discount
    final coupon = paymentSummaryState.appliedCoupon.value;
    if (coupon != null) {
      if (coupon.discountType == 'percent') {
        total -= (total * coupon.discountAmount / 100);
      } else {
        total -= coupon.discountAmount;
      }
    }
    // Apply additional discount
    if (paymentSummaryState.addAdditionalDiscount.value) {
      final discountType = paymentSummaryState.discountType.value;
      final discountValue =
          double.tryParse(paymentSummaryState.discountValue.value) ?? 0;
      if (discountType == 'percentage') {
        total -= (total * discountValue / 100);
      } else {
        total -= discountValue;
      }
    }
    // Apply tax
    final tax = paymentSummaryState.selectedTax.value;
    if (tax != null) {
      total += (total * tax.value / 100);
    }
    // Add tips
    final tips = double.tryParse(paymentSummaryState.tips.value) ?? 0;
    total += tips;
    paymentSummaryState.grandTotal.value = total < 0 ? 0 : total;
  }
}
