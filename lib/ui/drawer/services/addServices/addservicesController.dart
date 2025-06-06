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

  Service({
    this.id,
    this.name,
    this.image,
    this.duration,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      duration: json['service_duration'],
      price: json['regular_price'],
    );
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

  @override
  void onInit() {
    super.onInit();
    getCategorys();
    getAllServices();
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

  Future onServicePress() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> loginData = {
      "image": null,
      "name": nameController.text,
      "service_duration": int.parse(serviceDuration.text),
      "regular_price": int.parse(regularPrice.text),
      "category_id": selectedBranch.value?.id,
      "description": descriptionController.text,
      'status': isActive.value ? 1 : 0,
      "salon_id": loginUser!.salonId
    };
    try {
      await dioClient.postData<AddService>(
        '${Apis.baseUrl}${Endpoints.getServices}',
        loginData,
        (json) => AddService.fromJson(json),
      );
      CustomSnackbar.showSuccess('success', 'Login Successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
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

}
