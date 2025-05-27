import 'package:get/get.dart';
import '../../main.dart';

class DrawermenuController extends GetxController {
  var selectedPage = 0.obs;
  var fullname = ''.obs;
  var email = ''.obs;
  var appBarTitle = 'Dashboard'.obs;

  void selectPage(int page) {
    selectedPage.value = page;
  }

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  Future<void> onLogoutPress() async {
    await prefs.onLogout();
  }

  void getUserDetails() async {
    final loginUser = await prefs.getUser();
    fullname.value = '${loginUser?.salonName}';
    email.value = loginUser?.email ?? '';
  }
}
