import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/ui/drawer/services/addServices/addservicesController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';

class AddNewService extends StatelessWidget {
  AddNewService({super.key});
  final Addservicescontroller getController = Get.put(Addservicescontroller());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            Imagepicker(),
            CustomTextFormField(
              controller: getController.nameController,
              labelText: 'Name',
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validatename(value),
            ),
            CustomTextFormField(
              controller: getController.serviceDuration,
              labelText: 'Service Duration',
              keyboardType: TextInputType.number,
              validator: (value) => Validation.validateisBlanck(value),
            ),
            CustomTextFormField(
              controller: getController.regularPrice,
              labelText: 'Regular Price',
              keyboardType: TextInputType.number,
              validator: (value) => Validation.validateisBlanck(value),
            ),
            branchDropdown(),
            InputTxtfield_discription(),
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
            Btn_serviceAdd()
          ],
        ),
      ),
    ));
  }

  Widget Imagepicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => pickImage(isMultiple: false),
        child: Container(
          height: 120.h,
          width: 120.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
              width: 1,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.r),
            color: secondaryColor.withOpacity(0.2),
          ),
          child: singleImage.value != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    singleImage.value!,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.image_rounded,
                  color: primaryColor,
                  size: 30.sp,
                ),
        ),
      );
    });
  }

  Widget InputTxtfield_discription() {
    return CustomTextFormField(
      controller: getController.descriptionController,
      labelText: 'Description',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatedisscription(value),
    );
  }

  Widget branchDropdown() {
    return Obx(() {
      return DropdownButton<Category>(
        value: getController.selectedBranch.value,
        hint: Text("Select Branch"),
        items: getController.branchList.map((Category branch) {
          return DropdownMenuItem<Category>(
            value: branch,
            child: Text(branch.name ?? ''),
          );
        }).toList(),
        onChanged: (Category? newValue) {
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

  Widget Btn_serviceAdd() {
    return ElevatedButtonExample(
      text: "Add Service",
      onPressed: () {
        //call add service
        getController.onServicePress();
      },
    );
  }
}
