import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_template/ui/drawer/staff/updateStaffController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/validation.dart';

import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';

import 'package:get/get.dart';
import 'package:step_progress/step_progress.dart';
import 'package:flutter_template/network/model/getStaffModel.dart';

class UpdateStaffScreen extends StatelessWidget {
  final Data staffData;
  UpdateStaffScreen({super.key, required this.staffData});
  final UpdateStaffController getController = Get.put(UpdateStaffController());
  final _formKey = GlobalKey<FormState>();

  void _prefillData() {
    getController.fullnameController.text = staffData.fullName ?? '';
    getController.emailController.text = staffData.email ?? '';
    getController.phoneController.text = staffData.phoneNumber ?? '';
    getController.salaryController.text = staffData.salary?.toString() ?? '';
    getController.durationController.text = staffData.lunchTime?.duration?.toString() ?? '';
    getController.LunchStarttimeController.text = staffData.lunchTime?.timing ?? '';
    getController.shiftStarttimeController.text = staffData.assignTime?.startShift ?? '';
    getController.shiftEndtimeController.text = staffData.assignTime?.endShift ?? '';
    getController.selectedGender.value = staffData.gender ?? '';
    // Prefill branch and services if lists are loaded
    if (staffData.branchId != null && getController.branchList.isNotEmpty) {
      final branch = getController.branchList.firstWhereOrNull((b) => b.id == staffData.branchId!.sId);
      if (branch != null) getController.selectedBranch.value = branch;
    }
    if (staffData.serviceId != null && getController.serviceList.isNotEmpty) {
      final selected = getController.serviceList.where((s) => staffData.serviceId!.any((sid) => sid.sId == s.id)).toList();
      getController.selectedServices.assignAll(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    _prefillData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Staff'),
        backgroundColor: primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 30.h,
                  children: [
                    Obx(() => StepProgress(
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
                            activeForegroundColor: primaryColor,
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
                    Obx(() => _stepForm(getController.currentStep.value, context)),
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
                                    ? 'Update Staff'
                                    : 'Next',
                                onPressed: () {
                                  if (getController.currentStep.value < 1) {
                                    getController.nextStep();
                                  } else {
                                    getController.onUpdateStaffPress(staffData.sId!);
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepForm(int step, BuildContext context) {
    switch (step) {
      case 0:
        return Case1();
      case 1:
        return Case2(context);
      default:
        return SizedBox.shrink();
    }
  }

  Widget Case1() {
    return Column(
      spacing: 15.h,
      children: [
        // Imagepicker(),
        InputTxtfield_fullName(),
        InputTxtfield_Email(),
        InputTxtfield_Pass(),
        InputTxtfield_confirmPass(),
      ],
    );
  }

  Widget Case2(BuildContext context) {
    return Column(
      spacing: 15.h,
      children: [
        serviceDropdown(),
        branchDropdown(),
        InputTxtfield_Phone(),
        Row(
          children: [
            Expanded(child: shiftStart_time(context)),
            SizedBox(width: 10.w),
            Expanded(child: shiftEnd_time(context)),
          ],
        ),
        Gender(),
        InputTxtfield_Salary(),
        Row(
          children: [
            Expanded(child: InputTxtfield_Duration()),
            SizedBox(width: 10.w),
            Expanded(child: LunchTime(context)),
          ],
        ),
      ],
    );
  }

   Widget InputTxtfield_fullName() {
    return CustomTextFormField(
      controller: getController.fullnameController,
      labelText: "Name",
      keyboardType: TextInputType.text,
      validator: (value) => Validation.validatename(value),
    );
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.emailController,
      labelText: "Email",
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Phone() {
    return CustomTextFormField(
      controller: getController.phoneController,
      labelText: "Contect Number",
      keyboardType: TextInputType.phone,
      validator: (value) => Validation.validatePhone(value),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget InputTxtfield_Salary() {
    return CustomTextFormField(
      controller: getController.salaryController,
      labelText: "Salary",
      keyboardType: TextInputType.number,
      validator: (value) => Validation.validateSalary(value),
    );
  }

  Widget InputTxtfield_Duration() {
    return CustomTextFormField(
      controller: getController.durationController,
      labelText: "Duration",
      keyboardType: TextInputType.number,
      validator: (value) => Validation.validateDuration(value),
    );
  }

  Widget shiftStart_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.shiftStarttimeController,
      labelText: 'Shift Start Time',
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
            getController.shiftStarttimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget LunchTime(BuildContext context) {
    return CustomTextFormField(
      controller: getController.LunchStarttimeController,
      labelText: 'Lunch Start At',
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
            getController.LunchStarttimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget shiftEnd_time(BuildContext context) {
    return CustomTextFormField(
      controller: getController.shiftEndtimeController,
      labelText: 'Shift End Time',
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
            getController.shiftEndtimeController.text = formattedTime;
          }
        },
        icon: Icon(Icons.access_time),
      ),
    );
  }

  Widget Gender() {
    return Obx(() => CustomDropdown<String>(
          value: getController.selectedGender.value.isEmpty
              ? null
              : getController.selectedGender.value,
          items: getController.dropdownItems,
          hintText: 'Gender',
          labelText: 'Gender',
          onChanged: (newValue) {
            if (newValue != null) {
              getController.selectedGender(newValue);
            }
          },
        ));
  }

  Widget InputTxtfield_Pass() {
    return Obx(() => CustomTextFormField(
          controller: getController.passwordController,
          labelText: 'Password',
          obscureText: !getController.showPass.value,
          suffixIcon: IconButton(
            onPressed: () {
              getController.toggleShowPass();
            },
            icon: Icon(
              getController.showPass.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: grey,
            ),
          ),
          validator: (value) => Validation.validatePassword(value),
        ));
  }

  Widget InputTxtfield_confirmPass() {
    return Obx(() => CustomTextFormField(
          controller: getController.confirmpasswordController,
          labelText: 'Confirm Password',
          obscureText: !getController.showPass2.value,
          suffixIcon: IconButton(
            onPressed: () {
              getController.toggleShowPass2();
            },
            icon: Icon(
              getController.showPass.value
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: grey,
            ),
          ),
          validator: (value) => Validation.validatePassword(value),
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

  Widget branchDropdown() {
    return Obx(() {
      return DropdownButton<Branch>(
        value: getController.selectedBranch.value,
        hint: Text("Select Branch"),
        items: getController.branchList.map((Branch branch) {
          return DropdownMenuItem<Branch>(
            value: branch,
            child: Text(branch.name ?? ''),
          );
        }).toList(),
        onChanged: (Branch? newValue) {
          if (newValue != null) {
            getController.selectedBranch.value = newValue;

            // Show snackbar with branch ID
            CustomSnackbar.showSuccess(
              'Branch Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }
}
