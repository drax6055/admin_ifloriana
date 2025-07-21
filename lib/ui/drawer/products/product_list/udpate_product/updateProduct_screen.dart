import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'update_product_controller.dart';

class UpdateproductScreen extends StatelessWidget {
  UpdateproductScreen({super.key});
  final UpdateProductController getController =
      Get.put(UpdateProductController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [_buildBranchDropdown()],
                ))));
  }

  Widget _buildBranchDropdown() {
    return Obx(() => DropdownButtonFormField<Branch>(
          value: getController.selectedBranch.value,
          decoration: const InputDecoration(
              labelText: 'Branch *', border: OutlineInputBorder()),
          items: getController.branchList
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item.name ?? '')))
              .toList(),
          onChanged: (v) {
            getController.selectedBranch.value = v;
          },
          validator: (v) => v == null ? 'Required' : null,
        ));
  }
}
