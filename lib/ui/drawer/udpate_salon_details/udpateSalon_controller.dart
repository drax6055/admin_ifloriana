import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/network/model/udpateSalonModel.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class UdpatesalonController extends GetxController {
  var fullnameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var descriptionController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var selectedcategory = "UNISEX".obs;

  void getUserDetails() async {
    final signUpResponce = await prefs.getSignupDetails();
    print("===========> SignUp Response: $signUpResponce");
    fullnameController.text = signUpResponce!.salonName ?? 'DD';
    addressController.text = signUpResponce.address ?? '';
    emailController.text = signUpResponce.email ?? '';
    phoneController.text = signUpResponce.phoneNumber ?? '';
    opentimeController.text = signUpResponce.salonDetails?.openingTime ?? '';
    closetimeController.text = signUpResponce.salonDetails?.closingTime ?? '';
    selectedcategory.value =
        signUpResponce.salonDetails?.category?.toUpperCase() ?? 'UNISEX';
    if (signUpResponce.salonDetails?.image != null) {
      singleImage.value = signUpResponce.salonDetails!.image! as File?;
    } else {
      singleImage.value = null;
    }
  }

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

  Future<void> onupdateClick() async {
    final loginUser = await prefs.getUser();
    File? imageFile;
    String? imagePath;

    if (singleImage.value != null && singleImage.value!.toString().isNotEmpty) {
      if (singleImage.value is File) {
        imagePath = singleImage.value!.path;
      } else {
        imagePath = singleImage.value!.toString();
      }
      imageFile = File(imagePath);
      if (!imageFile.existsSync()) {
        CustomSnackbar.showError("Error", "Image file does not exist");
        return;
      }
    }
    Map<String, dynamic> salon_post_details = {
      'name': fullnameController.text,
      'description': descriptionController.text,
      'address': addressController.text,
      'contact_number': phoneController.text,
      'contact_email': emailController.text,
      'opening_time': opentimeController.text,
      'closing_time': closetimeController.text,
      'category': selectedcategory.value.toLowerCase(),
      'status': 1,
      'package_id': loginUser!.packageId,
      'signup_id': loginUser.adminId,
      if (imageFile != null)
        'image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
    };

    try {
      final formData = dio.FormData.fromMap(salon_post_details);

      await dioClient.putFormData<UpdateSalonModel>(
        '${Apis.baseUrl}${Endpoints.update_salon}${loginUser.salonId}',
        formData,
        (json) => UpdateSalonModel.fromJson(json),
      );

      CustomSnackbar.showSuccess("Done", "Salon details updated successfully");
    } catch (e) {
      CustomSnackbar.showError("Error", "Failed to update salon details: $e");
    }
  }
}
