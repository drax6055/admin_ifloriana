import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../drawer/commission/add_commission_screen.dart';
import '../drawer/commission/commission_list_screen.dart';






class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  navigateToNextScreen() async {
    try {
      var duration = const Duration(seconds: 2);

      Timer(duration, () async {
        final user = await prefs.getUser();
        String? accessToken = user?.token;
        if (accessToken == null) {
          Get.offNamed(Routes.loginScreen);
        } else {
          Get.to(CommissionListScreen());
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    } 
  } 
}
