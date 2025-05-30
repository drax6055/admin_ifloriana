import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsController.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:flutter_template/wiget/loading.dart';
import 'package:get/get.dart';

class Staffdetailsscreen extends StatelessWidget {
  const Staffdetailsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Staffdetailscontroller getController =
        Get.put(Staffdetailscontroller());

    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: BoxDecoration(
        color: white,
      ),
      child: Obx(() {
        if (getController.isLoading.value) {
          return Center(
            child: CustomLoadingAvatar(),
          );
        }
        if (getController.staffList.isEmpty) {
          return Center(
              child: CustomTextWidget(
            text: 'No Staff Found',
            textAlign: TextAlign.center,
            textStyle: TextStyle(fontSize: 18, color: grey),
          ));
        }
        return StaffExpandableList(staffList: getController.staffList);
      }),
    )));
  }
}
