import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'buy_product_controller.dart';

class BuyProductScreen extends StatelessWidget {
  final BuyProductController controller = Get.put(BuyProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF232328),
      appBar: AppBar(
        title: Text("Buy Product"),
        // backgroundColor: Color(0xFF232328),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _dropdown(
                      label: "Select Branch *",
                      value: controller.selectedBranch.value,
                      items: controller.branches,
                      getLabel: (b) => b['name'],
                      onChanged: (v) => controller.selectedBranch.value = v,
                    )),
                    SizedBox(width: 16),
                    Expanded(
                        child: _dropdown(
                      label: "Select Customer *",
                      value: controller.selectedCustomer.value,
                      items: controller.customers,
                      getLabel: (c) => c['full_name'],
                      onChanged: (v) => controller.selectedCustomer.value = v,
                    )),
                  ],
                ),
                SizedBox(height: 16),
                _productDropdown(controller),
                SizedBox(height: 8),
                _quantityField(controller),
                ElevatedButton.icon(
                  onPressed: controller.selectedProduct.value == null
                      ? null
                      : controller.addToCart,
                  icon: Icon(Icons.add),
                  label: Text("Add Another Product"),
                ),
                SizedBox(height: 16),
                if (controller.cart.isNotEmpty) ...[
                  Text("Selected Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 8),
                  ...controller.cart.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Card(
                      // color: Colors.black,
                      child: ListTile(
                        title: Text(item['name'],
                            style: TextStyle(color: Colors.black)),
                        subtitle: Text(
                            "${item['quantity']} x ₹${item['price']}",
                            style: TextStyle(color: Colors.black87)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("₹${item['total']}",
                                style: TextStyle(color: Colors.black)),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeFromCart(i),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 8),
                ],
                Text("Total Amount:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                Obx(() => Text("₹${controller.totalAmount.value}",
                    style: TextStyle(fontSize: 18, color: Colors.black))),
                SizedBox(height: 16),
                Text("Payment Method *", style: TextStyle(color: Colors.black)),
                Row(
                  children: [
                    _radio(controller, "Cash"),
                    _radio(controller, "Card"),
                    _radio(controller, "Upi"),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() => ElevatedButton(
                      onPressed: controller.cart.isEmpty ||
                              controller.isLoading.value
                          ? null
                          : () async {
                              final success = await controller.placeOrder();
                              if (success) {
                                Get.snackbar(
                                    'Order', 'Order placed successfully!',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white);
                              } else {
                                Get.snackbar('Order', 'Failed to place order',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.black)
                          : Text("Place Order"),
                    )),
              ],
            )),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required dynamic value,
    required List items,
    required String Function(dynamic) getLabel,
    required Function(dynamic) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black)),
        SizedBox(height: 4),
        DropdownButtonFormField(
          value: value,
          items: items
              .map<DropdownMenuItem>((item) =>
                  DropdownMenuItem(value: item, child: Text(getLabel(item))))
              .toList(),
          onChanged: (v) => onChanged(v),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _productDropdown(BuyProductController controller) {
    return Obx(() {
      final product = controller.selectedProduct.value;
      final hasVariations = product != null && product['has_variations'] == 1;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dropdown(
            label: "Select Product *",
            value: product,
            items: controller.products,
            getLabel: (p) => p['product_name'],
            onChanged: (v) {
              controller.selectedProduct.value = v;
              controller.selectedVariant.value = null;
            },
          ),
          if (hasVariations)
            _dropdown(
              label: "Select Variation",
              value: controller.selectedVariant.value,
              items: product['variants'],
              getLabel: (v) =>
                  v['combination'].map((c) => c['variation_value']).join(' - '),
              onChanged: (v) => controller.selectedVariant.value = v,
            ),
        ],
      );
    });
  }

  Widget _quantityField(BuyProductController controller) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quantity *", style: TextStyle(color: Colors.black)),
            SizedBox(height: 4),
            TextFormField(
              initialValue: controller.quantity.value.toString(),
              keyboardType: TextInputType.number,
              onChanged: (v) =>
                  controller.quantity.value = int.tryParse(v) ?? 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ));
  }

  Widget _radio(BuyProductController controller, String value) {
    return Obx(() => Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: controller.paymentMethod.value,
              onChanged: (v) => controller.setPaymentMethod(v ?? ''),
            ),
            Text(value, style: TextStyle(color: Colors.black)),
          ],
        ));
  }
}
