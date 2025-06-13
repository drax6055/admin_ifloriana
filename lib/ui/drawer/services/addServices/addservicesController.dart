import 'package:flutter/widgets.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/addService.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Service {
  String? id;
  String? name;
  String? image;
  int? duration;
  int? price;
  int? status;

  Service({
    this.id,
    this.name,
    this.image,
    this.duration,
    this.price,
    this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
        id: json['_id'],
        name: json['name'],
        image: json['image'],
        duration: json['service_duration'],
        price: json['regular_price'],
        status: json['status']);
  }
}

class Category {
  final String? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Addservicescontroller extends GetxController {
  var nameController = TextEditingController();
  var serviceDuration = TextEditingController();
  var regularPrice = TextEditingController();
  var descriptionController = TextEditingController();
  var isActive = true.obs;
  var selectedBranch = Rx<Category?>(null);
  var branchList = <Category>[].obs;
  var serviceList = <Service>[].obs;
  var isEditing = false.obs;
  var editingService = Rxn<Service>();

  @override
  void onInit() {
    super.onInit();
    getCategorys();
    getAllServices();
  }

  void startEditing(Service service) {
    isEditing.value = true;
    editingService.value = service;
    nameController.text = service.name ?? '';
    serviceDuration.text = service.duration?.toString() ?? '';
    regularPrice.text = service.price?.toString() ?? '';
    isActive.value = service.status == 1;
  }

  void resetForm() {
    nameController.clear();
    serviceDuration.clear();
    regularPrice.clear();
    isActive.value = true;
    isEditing.value = false;
    editingService.value = null;
  }

  Future<void> getCategorys() async {
    final loginUser = await prefs.getUser();
    try {
      var response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceCategotyName}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      branchList.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> onServicePress() async {
    if (isEditing.value && editingService.value != null) {
      await updateService(editingService.value!.id!);
    } else {
      await addService();
    }
  }

  Future<void> addService() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      "image": null,
      "name": nameController.text,
      "service_duration": int.parse(serviceDuration.text),
      "regular_price": int.parse(regularPrice.text),
      "status": isActive.value ? 1 : 0,
      "salon_id": loginUser!.salonId
    };
    try {
      await dioClient.postData<AddService>(
        '${Apis.baseUrl}${Endpoints.getServices}',
        serviceData,
        (json) => AddService.fromJson(json),
      );
      getAllServices();
      Get.back();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Service Added Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> updateService(String id) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      "name": nameController.text,
      "service_duration": int.parse(serviceDuration.text),
      "regular_price": int.parse(regularPrice.text),
      "status": isActive.value ? 1 : 0,
      "salon_id": loginUser!.salonId
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.getServices}/$id?salon_id=${loginUser.salonId}',
        serviceData,
        (json) => json,
      );
      await getAllServices();
      Get.back();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Service Updated Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to update service: $e');
    }
  }

  Future<void> getAllServices() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getAllServices}${loginUser!.salonId}',
        (json) => json,
      );

      if (response['data'] != null) {
        List<dynamic> servicesJson = response['data'];
        serviceList.value =
            servicesJson.map((e) => Service.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch services: $e');
    }
  }

  Future<void> deleteService(String id) async {
    final loginUser = await prefs.getUser();
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.getServices}/$id?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      await getAllServices();

      CustomSnackbar.showSuccess('Success', 'Service deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete service: $e');
    }
  }
}
