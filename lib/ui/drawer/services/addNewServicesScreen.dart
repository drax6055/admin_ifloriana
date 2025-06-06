import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/ui/drawer/services/addNewServicesController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import '../../../utils/validation.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/custome_snackbar.dart';

class AddNewServicesScreen extends StatelessWidget {
  AddNewServicesScreen({super.key});

  final Addnewservicescontroller getController =
      Get.put(Addnewservicescontroller());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              service_screen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget InputTxtfield_name() {
    return CustomTextFormField(
      controller: getController.nameController,
      labelText: 'Name',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget Btn_serviceCategory() {
    return ElevatedButtonExample(
      text: "Add Category",
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          getController.onAddCategoryPress();
        } else {
          CustomSnackbar.showError(
              'Validation Error', 'Please fill in all fields correctly');
        }
      },
    );
  }

  Widget serviceScreen_body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Imagepicker()),
              SizedBox(width: 16.w),
              Expanded(flex: 2, child: InputTxtfield_name()),
            ],
          ),
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
          SizedBox(height: 16.h),
          Btn_serviceCategory(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget Imagepicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => pickImage(isMultiple: false),
        child: Container(
          height: 60.h,
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

  Widget service_screen() {
    return Column(
      children: [
        SizedBox(height: 45.h),
        serviceScreen_body(),
      ],
    );
  }
}
