import 'dart:convert';

import 'package:dio/dio.dart';
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
      var dio = Dio();
      var response = await dio.get(
          'http://192.168.1.12:5000/api/products?salon_id=684011271ee646f27873fddc');
      if (response.statusCode == 200) {
        var products = productFromJson(jsonEncode(response.data));
        productList.assignAll(products);
      }
    } finally {
      isLoading(false);
    }
  }
}
