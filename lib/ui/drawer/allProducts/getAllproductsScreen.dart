import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/allProducts/getAllproductsController.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../wiget/custome_snackbar.dart';

class Getallproductsscreen extends StatelessWidget {
  Getallproductsscreen({super.key});
  final Getallproductscontroller getController =
      Get.put(Getallproductscontroller());
  final MultiSelectController<String> variationValueController =
      MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: branchDropdown()),
              SizedBox(width: 8),
              Expanded(child: caregoryDropdown()),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: tagDropdown()),
              SizedBox(width: 8),
              Expanded(child: unitDropdown()),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: variationTypeDropdown()),
              SizedBox(width: 8),
              Expanded(child: variationValueDropdown()),
            ],
          ),
        ],
      ),
    ));
  }

  Widget branchDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Branch>(
        value: getController.selectedBranch.value,
        decoration: InputDecoration(
          labelText: "Select Branch",
          border: OutlineInputBorder(),
        ),
        items: getController.branchList.map((Branch branch) {
          return DropdownMenuItem<Branch>(
            value: branch,
            child: Text(branch.name ?? ''),
          );
        }).toList(),
        onChanged: (Branch? newValue) {
          if (newValue != null) {
            getController.selectedBranch.value = newValue;

            CustomSnackbar.showSuccess(
              'Branch Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }

  Widget caregoryDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Category>(
        value: getController.selectedCategory.value,
        decoration: InputDecoration(
          labelText: "Select Category",
          border: OutlineInputBorder(),
        ),
        items: getController.categoryList.map((Category category) {
          return DropdownMenuItem<Category>(
            value: category,
            child: Text(category.name ?? ''),
          );
        }).toList(),
        onChanged: (Category? newValue) {
          print('Category dropdown onChanged called with: ${newValue?.name}');
          if (newValue != null) {
            getController.selectedCategory.value = newValue;
            CustomSnackbar.showSuccess(
              'Category Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }

  Widget tagDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Tag>(
        value: getController.selectedTag.value,
        decoration: InputDecoration(
          labelText: "Select Tag",
          border: OutlineInputBorder(),
        ),
        items: getController.tagList.map((Tag tag) {
          return DropdownMenuItem<Tag>(
            value: tag,
            child: Text(tag.name ?? ''),
          );
        }).toList(),
        onChanged: (Tag? newValue) {
          if (newValue != null) {
            getController.selectedTag.value = newValue;
            CustomSnackbar.showSuccess(
              'Tag Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }

  Widget unitDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Unit>(
        value: getController.selectedUnit.value,
        decoration: InputDecoration(
          labelText: "Select Unit",
          border: OutlineInputBorder(),
        ),
        items: getController.unitList.map((Unit unit) {
          return DropdownMenuItem<Unit>(
            value: unit,
            child: Text(unit.name ?? ''),
          );
        }).toList(),
        onChanged: (Unit? newValue) {
          if (newValue != null) {
            getController.selectedUnit.value = newValue;
            CustomSnackbar.showSuccess(
              'Unit Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }

  Widget variationTypeDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Variation>(
        value: getController.selectedVariation.value,
        decoration: InputDecoration(
          labelText: "Variation Type",
          border: OutlineInputBorder(),
        ),
        items: getController.variationList.map((Variation variation) {
          return DropdownMenuItem<Variation>(
            value: variation,
            child: Text(variation.name),
          );
        }).toList(),
        onChanged: (Variation? newValue) {
          getController.selectedVariation.value = newValue;
          getController.selectedVariationValues.clear();
          getController.update();
        },
      );
    });
  }

  Widget variationValueDropdown() {
    return Obx(() {
      final values = getController.selectedVariation.value?.values ?? [];
      return DropdownButtonFormField<String>(
        value: getController.selectedVariationValues.isNotEmpty
            ? getController.selectedVariationValues.first
            : null,
        decoration: InputDecoration(
          labelText: "Variation Value",
          border: OutlineInputBorder(),
        ),
        items: values.map((v) {
          return DropdownMenuItem<String>(
            value: v,
            child: Text(v),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            getController.selectedVariationValues.value = [newValue];
          }
        },
      );
    });
  }
}
