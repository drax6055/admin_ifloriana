import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/splash/splash_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'getBranchesController.dart';

class GetBranchesScreen extends StatelessWidget {
  const GetBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Getbranchescontroller getController = Get.put(Getbranchescontroller());

    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Text("Get Branches"),
        ],
      ),
    ));
  }
}
