import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var fullnameController = TextEditingController();
  var salonNameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var salonEmailController = TextEditingController();
  var phoneController = TextEditingController();
  var salonPhoneController = TextEditingController();
  var descriptionController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var selectedcategory = "UNISEX".obs;
  
  final List<String> dropdownItems = [
    'MALE',
    'FEMALE',
    'UNISEX',
  ];

  var currentStep = 0.obs;

  void goToStep(int step) {
    currentStep.value = step;
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  String formatTimeToString(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }
}
