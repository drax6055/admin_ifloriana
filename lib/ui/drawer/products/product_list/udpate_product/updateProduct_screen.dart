import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_images.dart';
import 'update_product_controller.dart';

class UpdateproductScreen extends StatelessWidget {
   UpdateproductScreen({super.key});
    final UpdateProductController getController = Get.put(UpdateProductController());

  @override
  Widget build(BuildContext context) {

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
              backgroundColor: primaryColor,
              foregroundImage: AssetImage(AppImages.applogo),
            ),
          ),
        ),
      ),
    ));
  }
}
