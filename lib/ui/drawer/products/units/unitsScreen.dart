import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/products/units/unitsController.dart';
import 'package:get/get.dart';


class Unitsscreen extends StatelessWidget {
 Unitsscreen({super.key});
  final Unitscontroller getController = Get.put(Unitscontroller());
  @override
  Widget build(BuildContext context) {


    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: [
            
          ],
        ),
      ),
    ));
  }
}
