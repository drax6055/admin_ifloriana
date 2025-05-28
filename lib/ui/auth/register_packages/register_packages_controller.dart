import 'dart:io';
import 'package:flutter_template/network/model/signup_model.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart' as dio;
import '../../../main.dart';
import '../../../network/model/packages_model.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class PackagesController extends GetxController {
  var packages = <Package_model>[].obs;
  var selectedPackageId = RxnString();
  var selectedFilter = 'All'.obs;
  var filteredPackages = <Package_model>[].obs;
  late Razorpay _razorpay;
  final Map<String, dynamic> registerData = Get.arguments;

  @override
  void onInit() {
    fetchPackages();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void fetchPackages() async {
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.packages}',
        (json) => (json as List<dynamic>)
            .map((e) => Package_model.fromJson(e))
            .toList(),
      );
      packages.value = response;
      filterPackages();
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  void filterPackages() {
    switch (selectedFilter.value) {
      case 'Monthly':
        filteredPackages.value =
            packages.where((pkg) => pkg.subscriptionPlan == "1-month").toList();
        break;
      case 'Quarterly':
        filteredPackages.value = packages
            .where((pkg) => pkg.subscriptionPlan == "3-months")
            .toList();
        break;
      case 'Half-Yearly':
        filteredPackages.value = packages
            .where((pkg) => pkg.subscriptionPlan == "6-months")
            .toList();
        break;
      case 'Yearly':
        filteredPackages.value =
            packages.where((pkg) => pkg.subscriptionPlan == "1-year").toList();
        break;
      default:
        filteredPackages.value = packages;
    }
  }

  void updateSelected(String value) {
    selectedPackageId.value = value;
  }

  Future<void> checkGmailId(String email) async {
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.check_mailId}?email=$email',
        (json) => json,
      );
      // response is a Map, not a List
      final exists = response['exists'] == true;
      if (exists) {
        CustomSnackbar.showError(
            'Error', 'Email already exists. Please use a different email.');
      } else {
        startPayment();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    }
  }

  void startPayment() {
    var selectedPackage =
        packages.firstWhereOrNull((pkg) => pkg.sId == selectedPackageId.value);
    if (selectedPackage != null) {
      var options = {
        'key': dotenv.env['RAZORPAY_KEY_ID'],
        'amount': (selectedPackage.price! * 100).toInt(),
        'name': selectedPackage.packageName,
        'description': selectedPackage.description,
        'prefill': {
          'contact': registerData['owner_phone'],
          'email': registerData['owner_email']
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        CustomSnackbar.showError('Error', 'Failed to open Razorpay: $e');
        print('==> Failed to open Razorpay: $e');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      String paymentId = response.paymentId ?? '';
      var selectedPackage = packages
          .firstWhereOrNull((pkg) => pkg.sId == selectedPackageId.value);
      if (selectedPackage != null) {
        double amount = selectedPackage.price! * 100.0;
        await dioClient.capturePayment(paymentId, amount);
        CustomSnackbar.showSuccess('Success', 'Payment captured successfully');
        try {
          await onRegisterData();
        } catch (e) {
          CustomSnackbar.showError('Error', 'Registration failed: $e');
          print('====onRegisterData error===== $e');
        }
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Payment capture failed: $e');
      print('====payment capture error=====');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackbar.showError('Error', 'Payment failed: ${response.message}');
    print('Error --> Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbar.showSuccess(
        'Info', 'External Wallet selected: ${response.walletName}');
    print('Info: External Wallet selected: ${response.walletName}');
  }

  Future<void> onRegisterData() async {
    if (selectedPackageId.value == null) {
      CustomSnackbar.showError("Error", "No package selected");
      return;
    }

    File? imageFile;
    String? imagePath;
    if (registerData['image'] != null &&
        registerData['image'].toString().isNotEmpty) {
      if (registerData['image'] is File) {
        imagePath = (registerData['image'] as File).path;
      } else {
        imagePath = registerData['image'].toString();
      }
      imageFile = File(imagePath);
      if (!imageFile.existsSync()) {
        CustomSnackbar.showError("Error", "Salon image file not found");
        return;
      }
    }

    final formData = dio.FormData.fromMap({
      'full_name': registerData['owner_name'],
      'salon_name': registerData['salon_name'],
      'phone_number': registerData['owner_phone'],
      'email': registerData['owner_email'],
      'address': registerData['salon_address'],
      'package_id': selectedPackageId.value,
      'salonDetails[name]': registerData['salon_name'],
      'salonDetails[email]': registerData['salon_email'],
      'salonDetails[phone_number]': registerData['salon_phone'],
      'salonDetails[description]': registerData['salon_description'],
      'salonDetails[opening_time]': registerData['salon_opening_time'],
      'salonDetails[closing_time]': registerData['salon_closing_time'],
      'salonDetails[category]':
          registerData['category'].toString().toLowerCase(),
      if (imageFile != null)
        'image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
    });

    try {
      await dioClient.postFormData(
        '${Apis.baseUrl}${Endpoints.register_salon}',
        formData,
        (data) => data,
      );
      CustomSnackbar.showSuccess('Success', 'Registration completed');
      Get.offAllNamed(Routes.loginScreen);
    } catch (e) {
      CustomSnackbar.showError("Error", e.toString());
    }
  }
}
