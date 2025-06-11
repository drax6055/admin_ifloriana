import 'package:flutter/material.dart';
import 'package:flutter_template/network/model/addModel.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class Service {
  String? id;
  String? name;

  Service({this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}

class Postbranchescontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getServices();
  }

  var nameController = TextEditingController();
  var contactEmailController = TextEditingController();
  var contactNumberController = TextEditingController();
  var landmarkController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();
  var LatitudeController = TextEditingController();
  var longtitudeController = TextEditingController();
  var discriptionController = TextEditingController();
  var addressController = TextEditingController();
  var selectedCategory = "Male".obs;
  var isActive = true.obs;
  RxList<Service> selectedServices = <Service>[].obs;
  RxList<Service> serviceList = <Service>[].obs;
  RxString locationText = "Press the button to get location".obs;
  final RxList<String> selectedPaymentMethod = <String>[].obs;

  var latController = TextEditingController();
  var lngController = TextEditingController();

  final List<String> dropdownItemSelectedCategory = [
    'Male',
    'Female',
    'Unisex',
  ];

  final List<String> dropdownItemPaymentMethod = [
    'Cash',
    'UPI',
  ];

  var isLoading = false.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;

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
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
          CustomSnackbar.showSuccess('Locatotion Featching: ', "Wait for a while we're Featching your location ");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        isLoading.value = false;
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    isLoading.value = false;
  }

  Future onBranchAdd() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> branchData = {
      "name": nameController.text,
      "salon_id": loginUser!.salonId,
      'category': selectedCategory.value.toLowerCase(),
      'status': isActive.value ? 1 : 0,
      "contact_email": contactEmailController.text,
      "contact_number": contactNumberController.text,
      "payment_method": selectedPaymentMethod.toList(),
      'service_id': selectedServices.map((s) => s.id).toList(),
      "landmark": landmarkController.text,
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "postal_code": postalCodeController.text,
      "latitude": int.tryParse(LatitudeController.text),
      "longitude": int.tryParse(longtitudeController.text),
      "description": discriptionController.text,
      "image": null,
      "address": addressController.text
    };

    try {
      await dioClient.postData<AddBranch>(
        '${Apis.baseUrl}${Endpoints.postBranchs}',
        branchData,
        (json) => AddBranch.fromJson(json),
      );
      CustomSnackbar.showSuccess('Succcess', 'Branch add Successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
