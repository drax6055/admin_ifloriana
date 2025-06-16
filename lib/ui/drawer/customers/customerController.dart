import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Customer {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;

  Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }
}

class CustomerController extends GetxController {
  var isLoading = false.obs;

  RxList<Customer> customerList = <Customer>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final loginUser = await prefs.getUser();

      final Map<String, dynamic> response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCustomersDetails}?salon_id=${loginUser!.salonId}',
        (json) => json as Map<String, dynamic>,
      );

      final List<dynamic> data = response['data'];
      customerList.value = data.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch customers: $e');
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      final loginUser = await prefs.getUser();
      isLoading.value = true;
      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.customers}/$customerId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        customerList.removeWhere((customer) => customer.id == customerId);
        CustomSnackbar.showSuccess('Success', 'Customer deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete customer: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
