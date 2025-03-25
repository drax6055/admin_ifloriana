import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import '../../../route/app_route.dart';
import '../../../utils/custom_text_styles.dart';
import '../../../utils/validation.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/custome_snackbar.dart';
import '../../../wiget/custome_text.dart';
import 'register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController getController = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              register_screen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Phone() {
    return CustomTextFormField(
      controller: getController.phoneController,
      labelText: 'Phone',
      keyboardType: TextInputType.phone,
      validator: (value) => Validation.validatePhone(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget InputTxtfield_add() {
    return CustomTextFormField(
      controller: getController.addressController,
      labelText: 'Address',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validateAddress(value),
    );
  }

  Widget InputTxtfield_SalonName() {
    return CustomTextFormField(
      controller: getController.salonNameController,
      labelText: 'Salon Name',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget InputTxtfield_OwnerName() {
    return CustomTextFormField(
      controller: getController.ownerNameController,
      labelText: 'Owner Name',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget Btn_register() {
    return ElevatedButtonExample(
      text: "Next",
      onPressed: () {
        var register_data = {
          'Owner_Name': getController.ownerNameController.text,
          'Salon_Name': getController.salonNameController.text,
          'Phone': getController.phoneController.text,
          'Address': getController.addressController.text,
          'Email': getController.emailController.text,
        };

        if (_formKey.currentState?.validate() ?? false) {
          Get.toNamed(Routes.packagesScreen, arguments: register_data);
          getController.ownerNameController.text = "";
          getController.salonNameController.text = "";
          getController.phoneController.text = "";
          getController.addressController.text = "";
          getController.emailController.text = "";
        } else {
          CustomSnackbar.showError(
              'Validation Error', 'Please fill in all fields correctly');
        }
      },
    );
  }

  Widget register_screen_header() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: secondaryColor, spreadRadius: 6)
              ],
            ),
            child: CircleAvatar(
              radius: 70,
              backgroundColor: primaryColor,
              foregroundImage: AssetImage(
                AppImages.applogo,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget register_screen_body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomTextWidget(
            text: 'Create account',
            textStyle: CustomTextStyles.textFontSemiBold(size: 16.sp),
          ),
          SizedBox(height: 3.h),
          CustomTextWidget(
            text: 'create an account so you can explore all the features',
            textStyle:
                CustomTextStyles.textFontSemiBold(size: 12.sp, color: grey),
          ),
          SizedBox(height: 20.h),
          InputTxtfield_OwnerName(),
          SizedBox(height: 16.h),
          InputTxtfield_Phone(),
          SizedBox(height: 16.h),
          InputTxtfield_add(),
          SizedBox(height: 16.h),
          InputTxtfield_SalonName(),
          SizedBox(height: 16.h),
          InputTxtfield_Email(),
          SizedBox(height: 30.h),
          Btn_register(),
          SizedBox(height: 30.h),
          InkWell(
              onTap: () => Get.back(),
              child: Align(
                  alignment: Alignment.center,
                  child: CustomTextWidget(
                      text: "Already have an account",
                      textStyle: CustomTextStyles.textFontBold(
                          size: 14.sp, color: primaryColor)))),
        ],
      ),
    );
  }

  Widget register_screen() {
    return Column(
      children: [
        register_screen_header(),
        SizedBox(height: 45.h),
        register_screen_body(),
      ],
    );
  }
}
