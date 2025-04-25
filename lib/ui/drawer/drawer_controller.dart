import 'package:get/get.dart';
import '../../commen_items/sharePrafrence.dart';
import '../../network/model/signup_model.dart';

class DrawermenuController extends GetxController {
  final SharedPreferenceManager _prefs = SharedPreferenceManager();
  var selectedPage = 0.obs;
  var signupdetails = Rxn<Sigm_up_model>();
  var name = ''.obs;
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
    await _prefs.onLogout();
  }

  void getUserDetails() async {
    final loginUser = await _prefs.getUser();
    name.value = loginUser?.admin?.firstName ?? '';
    email.value = loginUser?.admin?.email ?? '';
  }
}
