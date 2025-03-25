import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../commen_items/sharePrafrence.dart';
import '../../../main.dart';
import '../../../network/model/login_model.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';
import '../../../wiget/custome_snackbar.dart';

class LoginController extends GetxController {
  final SharedPreferenceManager _prefs = SharedPreferenceManager();

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

      await _prefs.setUser(loginResponse);
      await _prefs.saveAccessToken(loginResponse.token!);
      Get.offNamed(Routes.drawerScreen);
      CustomSnackbar.showSuccess('sucess', 'Login Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Invalid username or password');
    }
  }
}
