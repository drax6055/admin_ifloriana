import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../auth/profile/adminProfileScreen.dart';
import '../drawer/customers/customersScreen.dart';
import '../drawer/staff/staffDetailsScreen.dart';
import '../product_list/product_list_screen.dart';
import '../product_list/product_list_screen.dart';

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
       
          Get.to(CustomersScreen());
            //  Get.to(ProductListScreen());
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    }
  }
}
  