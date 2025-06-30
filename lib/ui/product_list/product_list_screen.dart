import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'product_list_controller.dart';
import 'product_list_model.dart';

class ProductListScreen extends StatelessWidget {
  final ProductListController controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: 1000,
              color: Colors.white,
              child: ListView(
                children: [
                  _buildHeader(),
                  ...controller.productList.map((product) {
                    return _ProductListItem(product: product);
                  }).toList(),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Product",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Brand",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Category",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Price",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Quantity",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text("Status",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text("Action",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;

  const _ProductListItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price = getPrice();
    String quantity = getQuantity();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildProductInfo()),
          Expanded(
              flex: 2,
              child: Text(product.brandId?.name ?? 'N/A',
                  style: TextStyle(color: Colors.black))),
          Expanded(
              flex: 2,
              child: Text(product.categoryId?.name ?? 'N/A',
                  style: TextStyle(color: Colors.black))),
          Expanded(
              flex: 2,
              child: Text(price, style: TextStyle(color: Colors.black))),
          Expanded(
              flex: 2,
              child: Text(quantity, style: TextStyle(color: Colors.black))),
          Expanded(flex: 1, child: _buildStatus()),
          Expanded(flex: 2, child: _buildActionButtons()),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(product.image),
          radius: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            product.productName,
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: product.status == 1 ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        product.status == 1 ? 'Active' : 'Inactive',
        style: TextStyle(color: Colors.white, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.brown[400],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text('+ Stock',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ],
    );
  }

  String getPrice() {
    if (product.hasVariations == 1 && product.variants.isNotEmpty) {
      final prices = product.variants.map((v) => v.price).toList();
      final minPrice = prices.reduce(min);
      final maxPrice = prices.reduce(max);
      if (minPrice == maxPrice) {
        return '₹ $minPrice';
      }
      return '₹ $minPrice - $maxPrice';
    } else {
      return '₹ ${product.price ?? 0}';
    }
  }

  String getQuantity() {
    if (product.hasVariations == 1 && product.variants.isNotEmpty) {
      return product.variants
          .map((v) => v.stock)
          .reduce((a, b) => a + b)
          .toString();
    } else {
      return product.stock?.toString() ?? '0';
    }
  }
}
