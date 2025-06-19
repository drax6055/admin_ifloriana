import 'package:flutter/widgets.dart';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';

import '../../../../../network/network_const.dart';
import '../../../../../wiget/custome_snackbar.dart';

class VariationGetcontroller extends GetxController {
  var valueControllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    getVariation();
  }

  Future<void> getVariation() async {
    final loginUser = await prefs.getUser();
    try {
      await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.postVariation}?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch packages: $e');
    }
  }
}
