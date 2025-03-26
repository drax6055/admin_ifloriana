import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/udpate_salon._model.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class CompleteSalonProfileController extends GetxController {
  var nameController = TextEditingController();
  var disController = TextEditingController();
  var addController = TextEditingController();
  var contact_numberController = TextEditingController();
  var contact_emailController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var categoryController = TextEditingController();
  var selectedcategory = "UNISEX".obs;

  final List<String> dropdownItems = [
    'MALE',
    'FEMALE',
    'UNISEX',
  ];

  Future onsalonPress() async {
    Map<String, dynamic> updateSalonData = {
      'name': nameController.text,
      'description': disController.text,
      'address': addController.text,
      'contact_number': contact_numberController.text,
      'contact_email': contact_emailController.text,
      'opening_time': opentimeController.text,
      'closing_time': closetimeController.text,
      'Category': selectedcategory.value.toString().toLowerCase(),
      'status': 1,
      'package_id': 6,
    };
    print("{'===>': $updateSalonData}");
    try {
      await dioClient.postData<UpdateSalonDetails>(
        '${Apis.baseUrl}${Endpoints.udpate_salon}',
        updateSalonData,
        (json) => UpdateSalonDetails.fromJson(json),
      );
      CustomSnackbar.showSuccess('Success', 'Salon updated successfully');
    } catch (e) {
      CustomSnackbar.showError(
          'Error', 'Failed to update salon: ${e.toString()}');
      print("==> ${e.toString()}");
    }
  }

  String formatTimeToString(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    nameController.dispose();
    disController.dispose();
    addController.dispose();
    contact_numberController.dispose();
    contact_emailController.dispose();
    opentimeController.dispose();
    closetimeController.dispose();
    categoryController.dispose();
    super.onClose();
  }
}
