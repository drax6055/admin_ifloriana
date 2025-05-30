import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/auth/register/register_controller.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import 'package:step_progress/step_progress.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController getController = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  Widget _stepForm(int step, BuildContext context) {
    switch (step) {
      case 0:
        return Case1();

      case 1:
        return Case2();

      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              loginScreenHeader(),
              SizedBox(height: 60.h),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 30.h,
                  children: [
                    Obx(() =>
                        _stepForm(getController.currentStep.value, context)),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 5.w),
                            if (getController.currentStep.value > 0)
                              Expanded(
                                child: ElevatedButtonExample(
                                  text: "Back",
                                  onPressed: getController.previousStep,
                                  height: 35.h,
                                ),
                              ),
                            if (getController.currentStep.value > 0)
                              SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButtonExample(
                                height: 35.h,
                                text: getController.currentStep.value == 1
                                    ? 'Select Packages'
                                    : 'Next',
                                onPressed: () {
                                  // Validate the form before proceeding
                                  final isValid =
                                      _formKey.currentState?.validate() ??
                                          false;
                                  if (!isValid) return;
                                  if (getController.currentStep.value < 1) {
                                    getController.nextStep();
                                  } else {
                                    var register_data = {
                                      "owner_name":
                                          getController.fullnameController.text,
                                      "owner_phone":
                                          getController.phoneController.text,
                                      "owner_email":
                                          getController.emailController.text,
                                      "salon_address":
                                          getController.addressController.text,
                                      "salon_name": getController
                                          .salonNameController.text,
                                    };

                                    Get.toNamed(Routes.packagesScreen,
                                        arguments: register_data);
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          text: 'Already have an account?',
                          textStyle:
                              CustomTextStyles.textFontRegular(size: 13.sp),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.loginScreen),
                          child: CustomTextWidget(
                            text: 'Login Here',
                            textStyle: CustomTextStyles.textFontBold(
                                size: 13.sp, color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loginScreenHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 190.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 35, left: 30, right: 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Obx(() => StepProgress(
                    totalSteps: 2,
                    currentStep: getController.currentStep.value,
                    stepSize: 24,
                    nodeTitles: const [
                      "Owner's Info",
                      "Salon's Info",
                    ],
                    padding: const EdgeInsets.all(18),
                    theme: const StepProgressThemeData(
                      shape: StepNodeShape.diamond,
                      activeForegroundColor: white,
                      defaultForegroundColor: secondaryColor,
                      stepLineSpacing: 18,
                      stepLineStyle: StepLineStyle(
                        borderRadius: Radius.circular(4),
                      ),
                      nodeLabelStyle: StepLabelStyle(
                        margin: EdgeInsets.only(bottom: 6),
                      ),
                      stepNodeStyle: StepNodeStyle(
                        activeIcon: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  )),
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
                    blurRadius: 10,
                    color: secondaryColor,
                    spreadRadius: 6,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: primaryColor,
                foregroundImage: AssetImage(AppImages.applogo),
              ),
            ))
      ],
    );
  }

  Widget Case1() {
    return Column(
      spacing: 15.h,
      children: [
        InputTxtfield_fullName(),
        InputTxtfield_Email(),
        InputTxtfield_Phone(),
      ],
    );
  }

  Widget Case2() {
    return Column(
      spacing: 15.h,
      children: [
        InputTxtfield_saloneName(),
        InputTxtfield_add(),
      ],
    );
  }

  Widget InputTxtfield_fullName() {
    return CustomTextFormField(
      controller: getController.fullnameController,
      labelText: "Owner's Name",
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.emailController,
      labelText: "Owner's Email",
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Phone() {
    return CustomTextFormField(
      controller: getController.phoneController,
      labelText: "Owner's Phone",
      keyboardType: TextInputType.phone,
      validator: (value) => Validation.validatePhone(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget InputTxtfield_saloneName() {
    return CustomTextFormField(
      controller: getController.salonNameController,
      labelText: "Salon's Name",
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
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
}
