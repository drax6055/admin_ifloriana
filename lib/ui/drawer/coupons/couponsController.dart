import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';
class CouponModel {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? type;
  final String? discountType;
  final int? discountAmount;
  final int? useLimit;
  final int? status;

  CouponModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.type,
    this.discountType,
    this.discountAmount,
    this.useLimit,
    this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'],
      name: json['name'],
      code: json['coupon_code'],
      description: json['description'],
      type: json['coupon_type'],
      discountType: json['discount_type'],
      discountAmount: json['discount_amount'],
      useLimit: json['use_limit'],
      status: json['status'],
    );
  }
}

class CouponsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCoupons();
  }
var couponList = <CouponModel>[].obs;
Future<void> getCoupons() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCoupons}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      couponList.value = data.map((e) => CouponModel.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }


}
