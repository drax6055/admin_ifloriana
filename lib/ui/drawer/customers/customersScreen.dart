import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/utils/validation.dart';
import 'package:flutter_template/wiget/Custome_button.dart';
import 'package:flutter_template/wiget/Custome_textfield.dart';
import 'package:flutter_template/wiget/appbar/commen_appbar.dart';
import 'package:flutter_template/wiget/custome_dropdown.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'customerController.dart';

class CustomersScreen extends StatelessWidget {
  CustomersScreen({super.key});
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Customers"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              SizedBox(height: 1.h),
              CustomTextFormField(
                controller: customerController.fullNameController,
                labelText: 'Full Name',
                keyboardType: TextInputType.text,
                validator: (value) => Validation.validatename(value),
              ),
              CustomTextFormField(
                controller: customerController.emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validation.validateEmail(value),
              ),
              CustomTextFormField(
                controller: customerController.phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) => Validation.validatePhone(value),
              ),
              CustomTextFormField(
                controller: customerController.passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) => Validation.validatePassword(value),
              ),
              genderDropdown(),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Status',
                        textStyle:
                            CustomTextStyles.textFontRegular(size: 14.sp),
                      ),
                      Switch(
                        value: customerController.isActive.value,
                        onChanged: (value) {
                          customerController.isActive.value = value;
                        },
                        activeColor: primaryColor,
                      ),
                    ],
                  )),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Enable Package & Membership',
                        textStyle:
                            CustomTextStyles.textFontRegular(size: 14.sp),
                      ),
                      Switch(
                        value: customerController.showPackageFields.value,
                        onChanged: (value) {
                          customerController.showPackageFields.value = value;
                        },
                      ),
                    ],
                  )),
              Obx(() => customerController.showPackageFields.value
                  ? Column(
                      children: [
                        MultiDropdown<BranchPackage>(
                          items: customerController.branchPackageList
                              .map((package) => DropdownItem(
                                    label: package.packageName ?? '',
                                    value: package,
                                  ))
                              .toList(),
                          controller: customerController.packageController,
                          enabled: true,
                          searchEnabled: true,
                          chipDecoration: const ChipDecoration(
                            backgroundColor: secondaryColor,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          fieldDecoration: FieldDecoration(
                            hintText: 'Select Branch Packages',
                            hintStyle: const TextStyle(color: Colors.grey),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: secondaryColor,
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: primaryColor),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          onSelectionChange: (selectedItems) {
                            customerController.selectedPackages.value =
                                selectedItems;
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(() => DropdownButton<String>(
                                value: customerController
                                        .selectedBranchMembership.value.isEmpty
                                    ? null
                                    : customerController
                                        .selectedBranchMembership.value,
                                isExpanded: true,
                                hint: const Text('Select Branch Membership'),
                                underline: const SizedBox(),
                                items: customerController.branchMembershipList
                                    .map((membership) {
                                  return DropdownMenuItem<String>(
                                    value: membership.id,
                                    child:
                                        Text(membership.membershipName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    customerController.selectedBranchMembership
                                        .value = newValue;
                                  }
                                },
                              )),
                        ),
                      ],
                    )
                  : const SizedBox()),
              Btn_addCustomer(),
              SizedBox(height: 20.h),
              Obx(() => customerController.customerList.isEmpty
                  ? Center(
                      child: Text(
                        "No customers available.",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: customerController.customerList.length,
                      itemBuilder: (context, index) {
                        final customer = customerController.customerList[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(customer.fullName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(customer.email),
                                Text(customer.phoneNumber),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                customerController.deleteCustomer(customer.id);
                              },
                            ),
                          ),
                        );
                      },
                    )),

              // customerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderDropdown() {
    return Obx(() => CustomDropdown<String>(
          value: customerController.selectedGender.value.isEmpty
              ? null
              : customerController.selectedGender.value,
          items: customerController.genderOptions,
          hintText: 'Gender',
          labelText: 'Gender',
          onChanged: (newValue) {
            if (newValue != null) {
              customerController.selectedGender.value = newValue;
            }
          },
        ));
  }

  Widget Btn_addCustomer() {
    return ElevatedButtonExample(
      text: "Add Customer",
      onPressed: () {
        customerController.addCustomer();
      },
    );
  }
}
