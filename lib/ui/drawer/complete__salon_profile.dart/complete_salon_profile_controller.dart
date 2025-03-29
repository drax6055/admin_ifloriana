import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../commen_items/sharePrafrence.dart';
import '../../../main.dart';
import '../../../network/model/signup_model.dart';
import '../../../network/model/addSalonDetails.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';
import '../../../wiget/custome_snackbar.dart';

class CompleteSalonProfileController extends GetxController {
  var nameController = TextEditingController(); // salon name add
  var disController = TextEditingController();
  var addController = TextEditingController(); // address add
  var contact_numberController = TextEditingController(); // contact number add
  var contact_emailController = TextEditingController(); // email add
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var categoryController = TextEditingController();
  var selectedcategory = "UNISEX".obs;

  final SharedPreferenceManager _prefs = SharedPreferenceManager();

  var signupdetails = Rxn<Sigm_up_model>();

  @override
  void onInit() async {
    super.onInit();
    getSignupdetails(Get.context);
  }

  Future<void> getSignupdetails(context) async {
    // Fetch stored signup details
    signupdetails.value = await _prefs.getSignupDetails();

    if (signupdetails.value != null) {
      print("==> Stored Signup Data: ${signupdetails.value?.toJson()}");

      // Assign values to controllers
      nameController.text = signupdetails.value?.data?.salonName ?? '';
      addController.text = signupdetails.value?.data?.address ?? '';
      contact_emailController.text = signupdetails.value?.data?.email ?? '';
      contact_numberController.text =
          signupdetails.value?.data?.phoneNumber ?? '';
    } else {
      print("No stored signup details found!");
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
      'package_id': signupdetails.value?.data?.packageId ?? 0,
    };

    print("{'===>': $updateSalonData}");
    try {
      final response = await dioClient.postData<AddsalonDetails>(
        '${Apis.baseUrl}${Endpoints.udpate_salon}',
        updateSalonData,
        (json) => AddsalonDetails.fromJson(json),
      );
      await _prefs.setCreatedSalondetails(response);
      CustomSnackbar.showSuccess('Success', 'Salon created successfully');
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
