import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/drawer/customers/customersScreen.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../auth/profile/adminProfileScreen.dart';
import '../drawer/staff/staffDetailsScreen.dart';

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
       
          Get.to(Staffdetailsscreen());
            //  Get.to(Staffdetailsscreen());
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    }
  }
}
  