import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../../models/brand.dart';
import '../../../../../network/network_const.dart';
import '../../../../../wiget/custome_snackbar.dart';

class Getbrandscontroller extends GetxController {
  final brands = <Brand>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getBrands();
  }

  Future<void> getBrands() async {
    final loginUser = await prefs.getUser();
    try {
      isLoading.value = true;
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBrands}${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        brands.value = data.map((json) => Brand.fromJson(json)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();

      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.postBrands}/$brandId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null) {
        // Remove the deleted brand from the list
        brands.removeWhere((brand) => brand.id == brandId);
        CustomSnackbar.showSuccess('Success', 'Brand deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete brand: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
