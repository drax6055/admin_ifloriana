import 'dart:async';
import 'package:get/get.dart';
import '../../commen_items/sharePrafrence.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';

class SplashController extends GetxController {
  final SharedPreferenceManager _prefs = SharedPreferenceManager();

  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  navigateToNextScreen() async {
    try {
      var duration = const Duration(seconds: 2);

      Timer(duration, () async {
        String? accessToken = await _prefs.getAccessToken();
        if (accessToken == null) {
          Get.offNamed(Routes.loginScreen);
        } else {
          Get.offNamed(Routes.drawerScreen);
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    }
  }
}
