import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/addSalonDetails.dart';
import '../../../network/model/updateSalonDetails.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';
import '../../../wiget/custome_snackbar.dart';

class UdpatesalonController extends GetxController {
  var nameController = TextEditingController();
  var disController = TextEditingController();
  var addController = TextEditingController();
  var contact_numberController = TextEditingController();
  var contact_emailController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var categoryController = TextEditingController();
  var selectedcategory = "UNISEX".obs;

  var salonDetails = Rxn<AddsalonDetails>();
  var salonid = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    getSignupdetails(Get.context);
  }

  Future<void> getSignupdetails(context) async {
    salonDetails.value = await prefs.getCreatedSalondetails();

    if (salonDetails.value != null) {
      // salonid.value = salonDetails.value?.signupId ?? 0;
      nameController.text = salonDetails.value?.name ?? '';
      disController.text = salonDetails.value?.description ?? '';
      addController.text = salonDetails.value?.address ?? '';
      contact_emailController.text = salonDetails.value?.contactEmail ?? '';
      contact_numberController.text = salonDetails.value?.contactNumber ?? '';
      opentimeController.text = salonDetails.value?.openingTime ?? '';
      closetimeController.text = salonDetails.value?.closingTime ?? '';
      selectedcategory.value = salonDetails.value?.category ?? 'UNISEX';
    } else {
      CustomSnackbar.showError('=>', 'No stored salon details found!');
    }
  }

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
      'package_id': salonDetails.value?.packageId,
    };

    try {
      await dioClient.putData<UpdateSalon>(
        '${Apis.baseUrl}${Endpoints.udpate_salon}/${salonid.value}',
        updateSalonData,
        (json) => UpdateSalon.fromJson(json),
      );
      await prefs.getCreatedSalondetails();
      CustomSnackbar.showSuccess('Success', 'Salon updated successfully');
      Get.offAllNamed(Routes.loginScreen);
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
