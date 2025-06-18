import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';
import '../../../../network/model/category_model.dart';

class Categorycontroller extends GetxController {
  RxList<Category> categories = <Category>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  Future<void> getCategories() async {
    isLoading.value = true;
    final loginUser = await prefs.getUser();
    try {
      await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getAllCategory}${loginUser!.salonId}',
        (json) {
          final response = CategoryResponse.fromJson(json);
          categories.value = response.data;
          return json;
        },
      );
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
