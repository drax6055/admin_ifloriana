import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calender_control.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CalenderController getController = Get.put(CalenderController());

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Calender Screen'),
        ),
      ),
    );
  }
}
