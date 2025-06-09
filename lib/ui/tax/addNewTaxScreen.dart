import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/tax/addNewTaxController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:get/get.dart';
import '../../../utils/custom_text_styles.dart';
import '../../../utils/validation.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/custome_snackbar.dart';
import '../../../wiget/custome_text.dart';

class Addnewtaxscreen extends StatelessWidget {
  Addnewtaxscreen({super.key});

  final Addnewtaxcontroller getController = Get.put(Addnewtaxcontroller());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              tax_screen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget InputTxtfield_title() {
    return CustomTextFormField(
      controller: getController.titleController,
      labelText: 'Title',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validateisBlanck(value),
    );
  }

  Widget InputTxtfield_value() {
    return CustomTextFormField(
      controller: getController.valueController,
      labelText: 'Value',
      keyboardType: TextInputType.number,
      validator: (value) => Validation.validateisBlanck(value),
    );
  }

  Widget Btn_tax() {
    return ElevatedButtonExample(
      text: "Continue",
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          getController.onTaxadded();
        } else {
          CustomSnackbar.showError(
              'Validation Error', 'Please fill in all fields correctly');
        }
      },
    );
  }

  Widget tax_screen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InputTxtfield_title(),
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
          SizedBox(height: 30.h),
          type(),
          module(),
          InputTxtfield_value(),
          branchChips(),
          Btn_tax(),
        ],
      ),
    );
  }

  Widget type() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedDropdownType.value.isEmpty
              ? null
              : getController.selectedDropdownType.value,
          items: getController.dropdownType,
          hintText: 'Select Type',
          labelText: 'Type',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedDropdownType(newValue);
            }
          },
        ));
  }

  Widget module() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedDropdownModule.value.isEmpty
              ? null
              : getController.selectedDropdownModule.value,
          items: getController.dropdownModule,
          hintText: 'Select Module',
          labelText: 'Module',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedDropdownModule(newValue);
            }
          },
        ));
  }

  Widget forgot_screen() {
    return Column(
      children: [
        tax_screen(),
      ],
    );
  }
Widget branchChips() {
    return Obx(() {
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
                  FilterChip(
            label:
                Text(getController.allSelected ? 'Deselect All' : 'Select All'),
            selected: getController.allSelected,
            onSelected: (selected) {
              if (selected) {
                getController.selectedBranches
                    .assignAll(getController.branchList);
              } else {
                getController.selectedBranches.clear();
              }
            },
            selectedColor: primaryColor.withOpacity(0.2),
          ),
          // Branch Chips
          ...getController.branchList.map((branch) {
            final isSelected = getController.selectedBranches.contains(branch);
            return FilterChip(
              label: Text(branch.name ?? ''),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  getController.selectedBranches.add(branch);
                } else {
                  getController.selectedBranches.remove(branch);
                }
              },
              selectedColor: primaryColor.withOpacity(0.2),
            );
          }).toList(),
        ],
      );
    });
  }

}
