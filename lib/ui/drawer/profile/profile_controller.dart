import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../network/model/udpate_salon._model.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class ProfileController extends GetxController {
  var nameController = TextEditingController();
  var disController = TextEditingController();
  var addController = TextEditingController();
  var contact_numberController = TextEditingController();
  var contact_emailController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var categoryController = TextEditingController();
  var isSwitched = true.obs;
  var selectedcategory = "UNISEX".obs;

  final List<String> dropdownItems = [
    'MALE',
    'FEMALE',
    'UNISEX',
  ];

  void toggleSwitch(bool value) {
    isSwitched.value = value;
  }

  Future onsalonPress() async {
    Map<String, dynamic> udpateSalonData = {
      'name': "Dhruve ganchi",
      'description': "A dummy context",
      'address': "Ahmedabad",
      'contact_number': "5395168423",
      'contact_email': "demo1212@gmail.com",
      'opening_time': "10:00:00",
      'closing_time': "21:00:00",
      'Category': "unisex",
      'status': 1,
      'package_id': 6,
    };

    try {
      await dioClient.postData<UpdateSalonDetails>(
        '${Apis.baseUrl}${Endpoints.udpate_salon}',
        udpateSalonData,
        (json) => UpdateSalonDetails.fromJson(json),
      );
      CustomSnackbar.showSuccess('sucess', 'salon updated successfully');
    } catch (e) {
      CustomSnackbar.showError(
          'Error', 'Failed to update salon ${e.toString()}');
    }
  }
}
