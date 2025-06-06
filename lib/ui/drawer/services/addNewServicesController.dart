import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/AddserviceCategory.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Addnewservicescontroller extends GetxController {
  var nameController = TextEditingController();
  var isActive = true.obs;

  Future onAddCategoryPress() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      'name': nameController.text,
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
    };

    try {
      await dioClient.postData<CreateServiceCategory>(
        '${Apis.baseUrl}${Endpoints.postServiceCategory}',
        serviceData,
        (json) => CreateServiceCategory.fromJson(json),
      );

      CustomSnackbar.showSuccess('success', 'Added Successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  
}
