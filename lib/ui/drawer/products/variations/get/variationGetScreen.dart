import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/products/variations/get/variationGetController.dart';
import 'package:get/get.dart';
import '../../../../../utils/colors.dart';

class VariationGetscreen extends StatelessWidget {
  VariationGetscreen({super.key});
  final VariationGetcontroller getController =
      Get.put(VariationGetcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Variations'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [],
        ),
      ),
    );
  }
}
