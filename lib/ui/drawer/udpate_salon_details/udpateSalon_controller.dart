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
      'image': singleImage.value,
    };

    print(
      "====> $salon_post_details",
    );

    try {
      await dioClient.postData<UpdateSalonModel>(
        '${Apis.baseUrl}${Endpoints.salon}',
        salon_post_details,
        (json) => UpdateSalonModel.fromJson(json),
      );
      CustomSnackbar.showError("Done", "Salon details updated successfully");
    } catch (e) {
      CustomSnackbar.showError("Error", e.toString());
    }
  }
}
