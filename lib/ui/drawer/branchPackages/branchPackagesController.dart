import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class Service {
  String? id;
  String? name;
  int? regularPrice;

  Service({this.id, this.name, this.regularPrice});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    regularPrice = json['regular_price'];
  }
}

class Branch {
  final String? id;
  final String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class ContainerData {
  Rxn<Service> selectedService = Rxn<Service>();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  RxInt total = 0.obs;
}

class DynamicInputController extends GetxController {
  var containerList = <ContainerData>[].obs;
  RxList<Service> serviceList = <Service>[].obs;
  RxInt grandTotal = 0.obs;
  var branchList = <Branch>[].obs;
  var selectedBranch = Rx<Branch?>(null);
  var StarttimeController = TextEditingController();
  var EndtimeController = TextEditingController();
  var isActive = true.obs;
  var discriptionController = TextEditingController();
  var nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getServices();
    getBranches();
  }

  void addContainer() {
    final container = ContainerData();
    container.discountedPriceController
        .addListener(() => updateTotal(container));
    container.quantityController.addListener(() => updateTotal(container));
    containerList.add(container);
  }

  void removeContainer(int index) {
    containerList.removeAt(index);
    calculateGrandTotal();
  }

  void onServiceSelected(ContainerData container, Service? service) {
    if (service != null) {
      container.selectedService.value = service;
      container.discountedPriceController.text =
          service.regularPrice?.toString() ?? '0';
      container.quantityController.text = '1';
      updateTotal(container);
    }
  }

  void updateTotal(ContainerData container) {
    final priceText = container.discountedPriceController.text;
    final quantityText = container.quantityController.text;

    final price = int.tryParse(priceText) ?? 0;
    final quantity = int.tryParse(quantityText) ?? 0;

    container.total.value = price * quantity;
    calculateGrandTotal();
  }

  void calculateGrandTotal() {
    grandTotal.value =
        containerList.fold(0, (sum, container) => sum + container.total.value);
  }

  Future<void> getServices() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceNames}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      serviceList.value = data.map((e) => Service.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get services: $e');
    }
  }

  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> submitPackage() async {
    if (selectedBranch.value == null) {
      CustomSnackbar.showError('Error', 'Please select a branch');
      return;
    }

    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter package name');
      return;
    }

    if (discriptionController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter description');
      return;
    }

    if (StarttimeController.text.isEmpty || EndtimeController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select start and end dates');
      return;
    }

    if (containerList.isEmpty) {
      CustomSnackbar.showError('Error', 'Please add at least one service');
      return;
    }

    try {
      final packageDetails = containerList.map((container) {
        if (container.selectedService.value == null) {
          throw Exception('Please select a service for all containers');
        }
        return {
          'service_id': container.selectedService.value!.id,
          'discounted_price':
              int.parse(container.discountedPriceController.text),
          'quantity': int.parse(container.quantityController.text),
        };
      }).toList();
      final loginUser = await prefs.getUser();
      final requestBody = {
        'branch_id': [selectedBranch.value!.id],
        'package_name': nameController.text,
        'description': discriptionController.text,
        'start_date': StarttimeController.text,
        'end_date': EndtimeController.text,
        'status': isActive.value ? 1 : 0,
        'package_details': packageDetails,
        'salon_id': loginUser!.salonId,
      };

      final response = await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.branchPackages}',
        requestBody,
        (json) => json,
      );

      CustomSnackbar.showSuccess('Success', 'Package created successfully');
      Get.back(); // Navigate back after successful creation
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to create package: $e');
    }
  }
}
