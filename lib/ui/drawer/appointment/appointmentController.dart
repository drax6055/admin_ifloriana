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
      membership: json['branch_membership'] != null ? 'Yes' : '-',
      package: json['branch_package'] != null ? 'Yes' : '-',
      status: json['status'] ?? '-',
      paymentStatus: json['payment_status'] ?? '-',
    );
  }
}

class AppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
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
}
