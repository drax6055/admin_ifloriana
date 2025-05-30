import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/network/model/getRegisterData.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/login_model.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';
import '../../../wiget/custome_snackbar.dart';
import '../../../wiget/loading.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var showPass = false.obs;

  void toggleShowPass() {
    showPass.value = !showPass.value;
  }

  Future onLoginPress() async {
    Map<String, dynamic> loginData = {
      'email': emailController.text,
      'password': passController.text,
    };

    try {
      Login_model loginResponse = await dioClient.postData<Login_model>(
        '${Apis.baseUrl}${Endpoints.login}',
        loginData,
        (json) => Login_model.fromJson(json),
      );

      await prefs.setUser(loginResponse);
      callgetSignupApi();
      CustomSnackbar.showSuccess('success', 'Login Successfully');
      await Get.showOverlay(
        asyncFunction: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        loadingWidget: const Center(child: CustomLoadingAvatar()),
      );
      Get.offNamed(Routes.drawerScreen);
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> callgetSignupApi() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.get_register_details}${loginUser!.adminId}',
        (json) => json,
      );
      await prefs.setRegisterdetails(RegisterDetailsModel.fromJson(response));
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    }
  }
}
