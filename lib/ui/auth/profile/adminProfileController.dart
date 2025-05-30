import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/getRegisterData.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class Adminprofilecontroller extends GetxController {
  var fullnameController = TextEditingController();
  var salonNameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var showPassword = false.obs;
  var showConfirmPassword = false.obs;

  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleShowConfirmPass() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  // var pincodeController = TextEditingController();

  // var country = ''.obs;
  // var state = ''.obs;
  // var district = ''.obs;
  // var block = ''.obs;
  // var isLoading = false.obs;
  // var error = ''.obs;

  var isExpanded_Details = false.obs;
  var isExpanded_pass = false.obs;

  void expand_details() {
    isExpanded_Details.value = !isExpanded_Details.value;
  }

  void expand_pass() {
    isExpanded_pass.value = !isExpanded_pass.value;
  }

  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  void getProfileData() async {
    final profileDetails = await prefs.getRegisterdetails();
    fullnameController.text = profileDetails?.fullName ?? '';
    salonNameController.text = profileDetails?.salonName ?? '';
    addressController.text = profileDetails?.address ?? '';
    emailController.text = profileDetails?.email ?? '';
    phoneController.text = profileDetails?.phoneNumber ?? '';
  }

  Future<void> onProdileUpdate() async {
    final formData = dio.FormData.fromMap({
      'full_name': fullnameController.text,
      'phone_number': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'salonDetails[salon_name]': salonNameController.text,
    });

    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.putFormData(
        '${Apis.baseUrl}${Endpoints.get_register_details}${loginUser!.adminId}',
        formData,
        (data) => data,
      );
      await prefs.setRegisterdetails(RegisterDetailsModel.fromJson(response));
      Get.offAllNamed(Routes.drawerScreen);
    } catch (e) {
      CustomSnackbar.showError("Error", e.toString());
    }
  }

  // Future<void> fetchLocationDetails(String pincode) async {
  //   isLoading.value = true;
  //   error.value = '';

  //   try {
  //     final response = await dioClient.getData(
  //       'https://api.postalpincode.in/pincode/$pincode',
  //       (data) => data,
  //     );

  //     if (response != null && response[0]['Status'] == 'Success') {
  //       final postOffice = response[0]['PostOffice'][0];
  //       country.value = postOffice['Country'] ?? '';
  //       state.value = postOffice['State'] ?? '';
  //       district.value = postOffice['District'] ?? '';
  //       block.value = postOffice['Block'] ?? '';
  //     } else {
  //       error.value = 'Invalid Pincode or no data found.';
  //     }
  //   } catch (e) {
  //     error.value = 'Failed to fetch data: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
