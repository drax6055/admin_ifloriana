import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../buy_product/buy_product_screen.dart';
import '../buy_product/getOrderList/getOrderListScreen.dart';
import '../drawer/allProducts/getAllproductsScreen.dart';
import '../drawer/reports/orderReport/order_report_screen.dart';
import '../drawer/reports/overallBooking/overall_booking_screen.dart';

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
          Get.to(Getorderlistscreen());
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    } 
  } 
}
