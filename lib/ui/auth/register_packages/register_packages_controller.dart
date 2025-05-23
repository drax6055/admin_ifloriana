import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../main.dart';
import '../../../network/model/packages_model.dart';
import '../../../network/model/signup_model.dart';
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
      final response =
          await dioClient.dio.get('${Apis.baseUrl}${Endpoints.packages}');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        packages.value =
            jsonData.map((e) => Package_model.fromJson(e)).toList();
        filterPackages();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
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

        await onRegisterData();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Payment capture failed: $e');
      print('Error --> Payment capture failed: $e');
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

    Map<String, dynamic> register_post_details = {
      'full_name': registerData['owner_name'].toString(),
      'salon_name': registerData['salon_name'].toString(),
      'phone_number': registerData['owner_phone'].toString(),
      'email': registerData['owner_email'].toString(),
      'address': registerData['salon_address'].toString(),
      'package_id': selectedPackageId.value,
      'salonDetails': {
        'name': registerData['salon_name'].toString(),
        'email': registerData['salon_email'].toString(),
        'phone_number': registerData['salon_phone'].toString(),
        'description': registerData['salon_description'].toString(),
        'image': registerData['image'].toString(),
        'opening_time': registerData['salon_opening_time'].toString(),
        'closing_time': registerData['salon_closing_time'].toString(),
        'category': registerData['category'].toString().toLowerCase(),
      }
    };

    try {
      final response = await dioClient.postData<Sigm_up_model>(
        '${Apis.baseUrl}${Endpoints.register_salon}',
        register_post_details,
        (json) => Sigm_up_model.fromJson(json),
      );
      await prefs.setSignupDetails(response);

      Get.offAllNamed(Routes.loginScreen);
    } catch (e) {
      CustomSnackbar.showError("Error", e.toString());
    }
  }
}
