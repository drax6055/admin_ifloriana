import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';


class Getbranchescontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranches}${loginUser!.salonId}',
        (json) => json,
      );
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    }
  }

  
}
