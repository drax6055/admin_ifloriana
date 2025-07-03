import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/model/order_report_model.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Getorderlistcontroller extends GetxController {
  final orderReports = <OrderReportData>[].obs;
  final filteredOrderReports = <OrderReportData>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final selectedPaymentMethod = 'All'.obs;
  final paymentMethods = ['All', 'Cash', 'Upi'];

  @override
  void onInit() {
    super.onInit();
    getOrderReports();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void updatePaymentMethodFilter(String? newMethod) {
    if (newMethod != null) {
      selectedPaymentMethod.value = newMethod;
      _applyFilters();
    }
  }

  void _applyFilters() {
    var filteredList = orderReports.where((report) {
      final nameMatches = searchQuery.value.isEmpty ||
          (report.customerId?.fullName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false);

      final paymentMethodMatches = selectedPaymentMethod.value == 'All' ||
          (report.paymentMethod?.toLowerCase() ==
              selectedPaymentMethod.value.toLowerCase());

      return nameMatches && paymentMethodMatches;
    }).toList();

    filteredOrderReports.value = filteredList;
  }

  Future<void> openPdf(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      CustomSnackbar.showError('Error', 'Could not open PDF.');
    }
  }

  Future<void> getOrderReports() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.orderReport}?salon_id=${loginUser!.salonId}',
        (json) {
          final model = OrderReportModel.fromJson(json);
          return model;
        },
      );
      if (response != null && response.data != null) {
        orderReports.value = response.data!;
        _applyFilters();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch order reports: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
