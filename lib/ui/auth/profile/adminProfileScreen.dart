import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/splash/splash_controller.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

class Adminprofilescreen extends StatelessWidget {
  const Adminprofilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController getController = Get.put(SplashController());

    getController.navigateToNextScreen();

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.r, color: secondaryColor, spreadRadius: 10.r)
              ],
            ),
            child: CircleAvatar(
              radius: 70.r,
              backgroundColor: secondaryColor,
              foregroundImage: AssetImage(AppImages.applogo),
            ),
          ),
        ),
      ),
    ));
  }
}
