import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/commen_items/commen_class.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:get/get.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/ui/drawer/branchPackages/branchPackagesController.dart';
import '../../../utils/validation.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/custome_snackbar.dart';
import '../../../wiget/custome_text.dart';

class DynamicInputScreen extends StatelessWidget {
  final DynamicInputController controller = Get.put(DynamicInputController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Service Inputs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: controller.addContainer,
              child: Text('Add Container'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.containerList.length,
                    itemBuilder: (context, index) {
                      final data = controller.containerList[index];
                      return Obx(() => Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Container ${index + 1}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: primaryColor),
                                      onPressed: () =>
                                          controller.removeContainer(index),
                                    ),
                                  ],
                                ),
                                DropdownButtonFormField<Service>(
                                  value: data.selectedService.value,
                                  items: controller.serviceList
                                      .map((service) => DropdownMenuItem(
                                            value: service,
                                            child: Text(service.name ?? ''),
                                          ))
                                      .toList(),
                                  onChanged: (newService) {
                                    if (newService != null) {
                                      controller.onServiceSelected(
                                          data, newService);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Select Service",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomTextFormField(
                                  controller: data.discountedPriceController,
                                  labelText: 'Discounted Price',
                                  hintText: 'Enter Discounted Price',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 10),
                                CustomTextFormField(
                                  controller: data.quantityController,
                                  labelText: 'Quantity',
                                  hintText: 'Enter Quantity',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 10),
                                Text("Total: ₹${data.total.value}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ],
                            ),
                          ));
                    },
                  )),
            ),
            branchDropdown(),
            CustomTextFormField(
              controller: controller.nameController,
              labelText: 'Name',
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validatename(value),
            ),
            CustomTextFormField(
              controller: controller.discriptionController,
              labelText: 'Discription',
              maxLines: 2,
              keyboardType: TextInputType.text,
              validator: (value) => Validation.validatedisscription(value),
            ),
            Row(
              children: [
                Expanded(child: startTime(context)),
                SizedBox(
                  width: 5,
                ),
                Expanded(child: endTime(context)),
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
                      value: controller.isActive.value,
                      onChanged: (value) {
                        controller.isActive.value = value;
                      },
                      activeColor: primaryColor,
                    ),
                  ],
                )),
            Obx(() => Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${controller.grandTotal.value}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.submitPackage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Create Package',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget branchDropdown() {
    return Obx(() {
      return DropdownButtonFormField<Branch>(
        value: controller.selectedBranch.value,
        decoration: InputDecoration(
          labelText: "Select Branch",
          border: OutlineInputBorder(),
        ),
        items: controller.branchList.map((Branch branch) {
          return DropdownMenuItem<Branch>(
            value: branch,
            child: Text(branch.name ?? ''),
          );
        }).toList(),
        onChanged: (Branch? newValue) {
          if (newValue != null) {
            controller.selectedBranch.value = newValue;

            CustomSnackbar.showSuccess(
              'Branch Selected',
              'ID: ${newValue.id}',
            );
          }
        },
      );
    });
  }

  Widget startTime(BuildContext context) {
    return CustomTextFormField(
      controller: controller.StarttimeController,
      labelText: 'Start Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          await pickAndSetDate(
            context: context,
            controller: controller.StarttimeController,
          );
        },
        icon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget endTime(BuildContext context) {
    return CustomTextFormField(
      controller: controller.EndtimeController,
      labelText: 'End Time',
      keyboardType: TextInputType.none,
      validator: (value) => Validation.validateTime(value),
      suffixIcon: IconButton(
        onPressed: () async {
          await pickAndSetDate(
            context: context,
            controller: controller.EndtimeController,
          );
        },
        icon: Icon(Icons.calendar_today),
      ),
    );
  }
}
