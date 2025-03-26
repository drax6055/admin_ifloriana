import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:get/get.dart';
import '../../../route/app_route.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/appbar/commen_appbar.dart';
import '../../../wiget/custome_dropdown.dart';
import '../../../wiget/custome_snackbar.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController getController = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15.w,
              right: 15.w,
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                InputTxtfield_SalonName(),
                SizedBox(height: 10.h),
                InputTxtfield_dis(),
                SizedBox(height: 10.h),
                InputTxtfield_add(),
                SizedBox(height: 10.h),
                InputTxtfield_Phone(),
                SizedBox(height: 10.h),
                InputTxtfield_Email(),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(child: open_time(context)),
                    SizedBox(width: 10.w),
                    Expanded(child: close_time(context)),
                  ],
                ),
                SizedBox(height: 10.h),
                category(),
                SizedBox(height: 40.h),
                Btn_register(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget open_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.opentimeController,
      labelText: 'Open Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            String formattedTime = getController.formatTimeToString(pickedTime);
            getController.opentimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget close_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.closetimeController,
      labelText: 'Close Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            String formattedTime = getController.formatTimeToString(pickedTime);
            getController.closetimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  // Widget status() {
  //   return Obx(() => Switch(
  //         activeColor: primaryColor,
  //         value: getController.isSwitched.value,
  //         onChanged: getController.toggleSwitch,
  //       ));
  // }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.contact_emailController,
      labelText: 'Personal Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Phone() {
    return CustomTextFormField(
      controller: getController.contact_numberController,
      labelText: 'Personal Phone',
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
      controller: getController.addController,
      labelText: 'Address',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validateAddress(value),
    );
  }

  Widget InputTxtfield_dis() {
    return CustomTextFormField(
      controller: getController.disController,
      labelText: 'Description',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatedisscription(value),
    );
  }

  Widget InputTxtfield_SalonName() {
    return CustomTextFormField(
      controller: getController.nameController,
      labelText: 'Salon Name',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget Btn_register() {
    return ElevatedButtonExample(
      text: "Update",
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          getController.onsalonPress();
          Get.toNamed(Routes.drawerScreen);
        } else {
          CustomSnackbar.showError(
              'Validation Error', 'Please fill in all fields correctly');
        }
      },
    );
  }

  Widget InputTxtfield_category() {
    return CustomTextFormField(
      controller: getController.categoryController,
      labelText: 'Category',
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validateisBlanck(value),
    );
  }

  Widget category() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedcategory.value.isEmpty
              ? null
              : getController.selectedcategory.value,
          items: getController.dropdownItems,
          hintText: 'Select an option',
          labelText: 'Category',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedcategory(newValue);
            }
          },
        ));
  }
}
