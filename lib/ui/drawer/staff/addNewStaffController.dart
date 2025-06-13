import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Service {
  String? id;
  String? name;

  Service({this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}

class Branch {
  final String? id;
  final String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Commition {
  final String? id;
  final String? name;

  Commition({this.id, this.name});

  factory Commition.fromJson(Map<String, dynamic> json) {
    return Commition(
      id: json['_id'],
      name: json['commission_name'],
    );
  }
}

class Addnewstaffcontroller extends GetxController {
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  var phoneController = TextEditingController();
  var shiftStarttimeController = TextEditingController();
  var shiftEndtimeController = TextEditingController();
  var selectedGender = "Male".obs;
  var salaryController = TextEditingController();
  var durationController = TextEditingController();
  var LunchStarttimeController = TextEditingController();

  var showPass = false.obs;
  var showPass2 = false.obs;

  RxList<Service> serviceList = <Service>[].obs;
  Rx<Service?> selectedService = Rx<Service?>(null);
  RxList<Service> selectedServices = <Service>[].obs;
  var branchList = <Branch>[].obs;
  var commitionList = <Commition>[].obs;
  var selectedBranch = Rx<Branch?>(null);
  var selectedCommition = Rx<Commition?>(null);

  void toggleShowPass() {
    showPass.value = !showPass.value;
  }

  void toggleShowPass2() {
    showPass2.value = !showPass2.value;
  }

  var singleImage = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    getBranches();
    getCommition();
    getServices();
  }

  final List<String> dropdownItems = [
    'Male',
    'Female',
    'Other',
  ];

  var currentStep = 0.obs;

  void goToStep(int step) {
    currentStep.value = step;
  }

  void nextStep() {
    if (currentStep.value < 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // String formatTimeToString(TimeOfDay timeOfDay) {
  //   final now = DateTime.now();
  //   final time = DateTime(
  //       now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  //   return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  // }

  Future<void> getServices() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceNames}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      serviceList.value = data.map((e) => Service.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getCommition() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getcommisionForStaff}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      commitionList.value = data.map((e) => Commition.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onAddStaffPress() async {
    Map<String, dynamic> staffData = {
      'full_name': fullnameController.text,
      'email': emailController.text,
      'phone_number': phoneController.text,
      'password': passwordController.text,
      'confirm_password': confirmpasswordController.text,
      'gender': selectedGender.value.toLowerCase(),
      'branch_id': selectedBranch.value?.id,
      'service_id': selectedServices.map((s) => s.id).toList(),
      'status': 1,
      'assigned_commission_id':selectedCommition.value?.id,
      'salon_id': (await prefs.getUser())?.salonId,
      'image': null,
      'salary': int.tryParse(salaryController.text) ?? 0,
      'assign_time': {
        'start_shift': shiftStarttimeController.text,
        'end_shift': shiftEndtimeController.text,
      },
      'lunch_time': {
        'duration': int.tryParse(durationController.text) ?? 0,
        'timing': LunchStarttimeController.text,
      },
    };
    print("===> ${staffData.toString()}");
    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.postStaffDetails}',
        staffData,
        (json) => json,
      );
      print("===> ${staffData.toString()}");
      CustomSnackbar.showSuccess('Success', 'Staff added successfully');
    } catch (e) {
      print('==> Add Staff Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
