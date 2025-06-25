import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/customer_package_report_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class CustomerPackageReportController extends GetxController {
  final customerPackages = <CustomerPackageReportData>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerPackages();
  }

  Future<void> getCustomerPackages() async {
    isLoading.value = true;
    try {
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.customers}?salon_id=${loginUser!.salonId}',
        (json) {
          final model = CustomerPackageReportModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        // Only keep customers with non-empty branch_package
        customerPackages.value = response.data!
            .where(
                (c) => c.branchPackage != null && c.branchPackage!.isNotEmpty)
            .toList();
      }
    } catch (e) {
      CustomSnackbar.showError(
          'Error', 'Failed to fetch customer packages: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
