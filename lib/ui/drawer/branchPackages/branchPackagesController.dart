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

class ContainerData {
  Rxn<Service> selectedService = Rxn<Service>();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  RxInt total = 0.obs;
}

class DynamicInputController extends GetxController {
  var containerList = <ContainerData>[].obs;
  RxList<Service> serviceList = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    getServices();
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
}
