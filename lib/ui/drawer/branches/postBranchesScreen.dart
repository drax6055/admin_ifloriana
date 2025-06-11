import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/drawer/branches/postBranchescontroller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class Postbranchesscreen extends StatelessWidget {
  Postbranchesscreen({super.key});
  final Postbranchescontroller getController =
      Get.put(Postbranchescontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          CustomTextFormField(
            controller: getController.nameController,
            labelText: 'Name',
            keyboardType: TextInputType.text,
            validator: (value) => Validation.validatename(value),
          ),
          Category(),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    text: 'Status',
                    textStyle: CustomTextStyles.textFontRegular(size: 14.sp),
                  ),
                  Switch(
                    value: getController.isActive.value,
                    onChanged: (value) {
                      getController.isActive.value = value;
                    },
                    activeColor: primaryColor,
                  ),
                ],
              )),
          CustomTextFormField(
            controller: getController.contactEmailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validation.validateEmail(value),
          ),
          CustomTextFormField(
            controller: getController.contactNumberController,
            labelText: 'Number',
            keyboardType: TextInputType.number,
            validator: (value) => Validation.validatePhone(value),
          ),
          paymentMethodChipView(),
          serviceDropdown(),
          CustomTextFormField(
            controller: getController.addressController,
            labelText: 'Address',
            maxLines: 2,
            keyboardType: TextInputType.text,
            validator: (value) => Validation.validateAddress(value),
          ),
          CustomTextFormField(
            controller: getController.discriptionController,
            labelText: 'Discription',
            maxLines: 2,
            keyboardType: TextInputType.text,
            validator: (value) => Validation.validatedisscription(value),
          ),
        ],
      ),
    ));
  }

  Widget Category() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedCategory.value.isEmpty
              ? null
              : getController.selectedCategory.value,
          items: getController.dropdownItemSelectedCategory,
          hintText: 'Category',
          labelText: 'Category',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedCategory(newValue);
            }
          },
        ));
  }

  Widget serviceDropdown() {
    return Obx(() {
      final allSelected = getController.selectedServices.length ==
              getController.serviceList.length &&
          getController.serviceList.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // Select All chip
              FilterChip(
                label: Text(allSelected ? 'Deselect All' : 'Select All'),
                selected: allSelected,
                onSelected: (selected) {
                  if (selected) {
                    getController.selectedServices
                        .assignAll(getController.serviceList);
                  } else {
                    getController.selectedServices.clear();
                  }
                },
                disabledColor: secondaryColor.withOpacity(0.2),
                selectedColor: primaryColor.withOpacity(0.2),
              ),

              ...getController.serviceList.map((service) {
                final isSelected =
                    getController.selectedServices.contains(service);
                return FilterChip(
                  label: Text(service.name ?? ''),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      getController.selectedServices.add(service);
                    } else {
                      getController.selectedServices.remove(service);
                    }
                  },
                  selectedColor: primaryColor.withOpacity(0.2),
                );
              }).toList(),
            ],
          ),
        ],
      );
    });
  }

  Widget paymentMethodChipView() {
    return Obx(() {
      final allSelected = getController.selectedPaymentMethod.length ==
          getController.dropdownItemPaymentMethod.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // Select All chip
              FilterChip(
                label: Text(allSelected ? 'Deselect All' : 'Select All'),
                selected: allSelected,
                onSelected: (selected) {
                  if (selected) {
                    getController.selectedPaymentMethod
                        .assignAll(getController.dropdownItemPaymentMethod);
                  } else {
                    getController.selectedPaymentMethod.clear();
                  }
                },
                selectedColor: Colors.blue.withOpacity(0.2),
                disabledColor: Colors.grey[200],
              ),

              // Category chips
              ...getController.dropdownItemPaymentMethod.map((category) {
                final isSelected =
                    getController.selectedPaymentMethod.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      if (!getController.selectedPaymentMethod
                          .contains(category)) {
                        getController.selectedPaymentMethod.add(category);
                      }
                    } else {
                      getController.selectedPaymentMethod.remove(category);
                    }
                  },
                  selectedColor: Colors.blue.withOpacity(0.2),
                  checkmarkColor: Colors.blue,
                );
              }).toList(),
            ],
          ),
        ],
      );
    });
  }
}
