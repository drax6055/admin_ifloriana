import 'package:get/get.dart';
import '../../commen_items/sharePrafrence.dart';


class DrawermenuController extends GetxController {

  final SharedPreferenceManager _prefs = SharedPreferenceManager();
  var selectedPage = 0.obs;

  void selectPage(int page) {
    selectedPage.value = page;
  }
  
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onLogoutPress() async {
    await _prefs.onLogout();
  }

}
