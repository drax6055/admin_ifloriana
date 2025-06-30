import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../network/dio.dart';

class BuyProductController extends GetxController {
  final DioClient dioClient = DioClient();
  final String salonId = "684011271ee646f27873fddc";

  RxList branches = [].obs;
  RxList customers = [].obs;
  RxList products = [].obs;

  Rxn selectedBranch = Rxn();
  Rxn selectedCustomer = Rxn();
  Rxn selectedProduct = Rxn();
  Rxn selectedVariant = Rxn();
  RxInt quantity = 1.obs;
  RxString paymentMethod = "Cash".obs;

  RxList cart = [].obs;
  RxInt totalAmount = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
    fetchCustomers();
    fetchProducts();
  }

  void fetchBranches() async {
    final endpoint =
        'http://192.168.1.21:5000/api/branches/names?salon_id=$salonId';
    final data =
        await dioClient.getData<Map<String, dynamic>>(endpoint, (json) => json);
    branches.value = data['data'] ?? [];
  }

  void fetchCustomers() async {
    final endpoint =
        'http://192.168.1.21:5000/api/customers/names?salon_id=$salonId';
    final data =
        await dioClient.getData<Map<String, dynamic>>(endpoint, (json) => json);
    customers.value = data['data'] ?? [];
  }

  void fetchProducts() async {
    final endpoint = 'http://192.168.1.21:5000/api/products?salon_id=$salonId';
    final data = await dioClient.getData<List<dynamic>>(
        endpoint, (json) => json as List<dynamic>);
    products.value = data;
  }

  void addToCart() {
    if (selectedProduct.value == null || quantity.value < 1) return;
    final product = selectedProduct.value;
    final hasVariations = product['has_variations'] == 1;
    final variant = hasVariations ? selectedVariant.value : null;
    final price = hasVariations ? variant['price'] : product['price'];
    final name = hasVariations
        ? "${product['product_name']} - ${variant['combination'].map((v) => v['variation_value']).join(' - ')}"
        : product['product_name'];

    cart.add({
      'product': product,
      'variant': variant,
      'name': name,
      'quantity': quantity.value,
      'price': price,
      'total': price * quantity.value,
    });
    calculateTotal();
    selectedProduct.value = null;
    selectedVariant.value = null;
    quantity.value = 1;
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    calculateTotal();
  }

  void calculateTotal() {
    totalAmount.value =
        cart.fold<int>(0, (sum, item) => sum + (item['total'] as int));
  }

  void setPaymentMethod(String value) {
    paymentMethod.value = value;
  }

  Future<bool> placeOrder() async {
    if (selectedBranch.value == null ||
        selectedCustomer.value == null ||
        cart.isEmpty) return false;
    isLoading.value = true;
    try {
      final endpoint = 'http://192.168.1.21:5000/api/orders';
      final orderItems = cart.map((item) {
        final hasVariations = item['variant'] != null;
        return {
          "product_id": item['product']['_id'],
          if (hasVariations) "variant_id": item['variant']['_id'],
          "quantity": item['quantity'],
          "price": item['price'],
        };
      }).toList();
      final data = {
        "salon_id": salonId,
        "branch_id": selectedBranch.value['_id'],
        "customer_id": selectedCustomer.value['_id'],
        "items": orderItems,
        "total_amount": totalAmount.value,
        "payment_method": paymentMethod.value,
      };
      await dioClient.postData<Map<String, dynamic>>(
          endpoint, data, (json) => json);
      cart.clear();
      calculateTotal();
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }
}
