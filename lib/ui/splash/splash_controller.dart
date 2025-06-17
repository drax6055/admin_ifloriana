import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/drawer/branchPackages/branchPackagesScreen.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../drawer/branchPackages/getBranchPackagesScreen.dart';

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
          Get.to(GetBranchPackagesScreen());
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    }
  }
}
