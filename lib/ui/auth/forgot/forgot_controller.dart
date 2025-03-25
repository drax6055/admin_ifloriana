import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/forgot_model.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';
import '../../../wiget/custome_snackbar.dart';

class ForgotController extends GetxController {
  var emailController = TextEditingController();

  Future onForgotPress() async {
    Map<String, dynamic> forgotData = {
      'email': emailController.text,
    };

    try {
      final response = await dioClient.postData<forgot_model>(
        '${Apis.baseUrl}${Endpoints.admin_forgot}',
        forgotData,
        (json) => forgot_model.fromJson(json),
      );

      if (response.status == true) {
        CustomSnackbar.showSuccess(
            'Success', 'We have emailed your password reset link!');
        Get.offNamed(Routes.loginScreen);
      } else {
        CustomSnackbar.showError('Error', 'Something went wrong. Try again.');
      }
    } catch (e) {
      CustomSnackbar.showError(
          'Error', 'Something went wrong. Please try again.');
    }
  }
}
