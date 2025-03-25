import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:get/get.dart';
import '../../../route/app_route.dart';
import '../../../utils/colors.dart';
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
              left: 20.h,
              right: 20.h,
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                open_time(context),
                SizedBox(height: 10.h),
                close_time(context),
                SizedBox(height: 10.h),
                status(),
                InputTxtfield_Email(),
                SizedBox(height: 10.h),
                InputTxtfield_Phone(),
                SizedBox(height: 10.h),
                InputTxtfield_add(),
                SizedBox(height: 10.h),
                InputTxtfield_dis(),
                SizedBox(height: 10.h),
                InputTxtfield_category(),
                SizedBox(height: 10.h),
                InputTxtfield_SalonName(),
                SizedBox(height: 10.h),
                cat(),
                SizedBox(height: 10.h),
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
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );
          if (pickedTime != null) {
            String formattedTime = pickedTime.format(context);
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
      suffixIcon: IconButton(
        onPressed: () async {
          TimeOfDay initialTime = TimeOfDay.now();
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );

          if (pickedTime != null) {
            String formattedTime = pickedTime.format(context);
            getController.closetimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget status() {
    return Obx(() => Switch(
          activeColor: primaryColor,
          value: getController.isSwitched.value,
          onChanged: getController.toggleSwitch,
        ));
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.contact_emailController,
      labelText: 'Personal Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail('Please enter Email'),
    );
  }

Widget InputTxtfield_Phone() {
  return CustomTextFormField(
    controller: getController.contact_numberController,
    labelText: 'Personal Phone',
    keyboardType: TextInputType.phone,
    validator: (value) => Validation.validatePhone('Please enter a valid 10-digit phone number'),
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
      validator: (value) =>
          Validation.validateAddress('Please enter Salon Address'),
    );
  }

  Widget InputTxtfield_dis() {
    return CustomTextFormField(
      controller: getController.disController,
      labelText: 'Description',
      maxLines: 2,
      keyboardType: TextInputType.text,
      validator: (value) =>
          Validation.validatedisscription('Please enter Salon Description'),
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

  Widget cat() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedcategory.value.isEmpty
              ? null
              : getController.selectedcategory.value,
          items: getController.dropdownItems,
          hintText: 'Select an option',
          labelText: 'Dropdown Label',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedcategory(newValue);
            }
          },
        )); 

  }
}
