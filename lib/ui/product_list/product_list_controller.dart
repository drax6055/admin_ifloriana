import 'dart:convert';

import 'package:flutter_template/main.dart';
import 'package:get/get.dart';

import 'product_list_model.dart';

class ProductListController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var response = await dioClient.dio.get(
          'http://192.168.1.12:5000/api/products?salon_id=684011271ee646f27873fddc');
      if (response.statusCode == 200) {
        var products = productFromJson(jsonEncode(response.data));
        productList.assignAll(products);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateStock(String productId,
      {int? stock, List<Map<String, dynamic>>? updatedStocks}) async {
    try {
      isLoading(true);
      final String baseUrl = 'http://192.168.1.12:5000/api/products';

      if (updatedStocks != null) {
        // has variations
        for (var variantStock in updatedStocks) {
          await dioClient.patchData(
            '$baseUrl/$productId/stock',
            {
              'variant_sku': variantStock['sku'],
              'variant_stock': variantStock['stock'],
            },
            (json) => json,
          );
        }
      } else if (stock != null) {
        // no variations
        await dioClient.patchData(
          '$baseUrl/$productId/stock',
          {'stock': stock},
          (json) => json,
        );
      }

      Get.back(); // Close bottom sheet
      Get.snackbar('Success', 'Stock updated successfully');
      fetchProducts(); // Refresh the list
    } catch (e) {
      Get.snackbar('Error', 'Failed to update stock: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      isLoading(true);
      final String baseUrl = 'http://192.168.1.12:5000/api/products';

      await dioClient.deleteData(
        '$baseUrl/$productId',
        (json) => json,
      );

      Get.snackbar('Success', 'Product deleted successfully');
      fetchProducts(); // Refresh the list
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    } finally {
      isLoading(false);
    }
  }
}
