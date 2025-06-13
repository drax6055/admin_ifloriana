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
          child: Obx(() {
            return getController.serviceList.isEmpty
                ? Text("No services available.")
                : ListView.builder(
                    itemCount: getController.serviceList.length,
                    itemBuilder: (context, index) {
                      final service = getController.serviceList[index];
                      return Card(
                        child: ListTile(
                          title: Text(service.name ?? ''),
                          subtitle: Text(
                              '₹${service.price} • ${service.duration} mins ${service.status == 1 ? 'Active' : 'Deactive'}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              getController.deleteService(service.id!);
                            },
                          ),
                        ),
                      );
                    },
                  );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddCategorySheet(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget Imagepicker() {
    return Obx(() {
      return GestureDetector(
        onTap: () => pickImage(isMultiple: false),
        child: Container(
          height: 51.h,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
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
              : Icon(Icons.image_rounded, color: primaryColor, size: 30.sp),
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
        isExpanded: true,
        value: getController.selectedBranch.value,
        hint: const Text("Select Category"),
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
              'Category Selected',
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
        getController.onServicePress();
      },
    );
  }

  void showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Imagepicker(),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomTextFormField(
                          controller: getController.nameController,
                          labelText: 'Name',
                          keyboardType: TextInputType.text,
                          validator: (value) => Validation.validatename(value),
                        ),
                      )
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: getController.serviceDuration,
                          labelText: 'Service Duration',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validation.validateisBlanck(value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          controller: getController.regularPrice,
                          labelText: 'Regular Price',
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              Validation.validateisBlanck(value),
                        ),
                      ),
                    ],
                  ),
                  branchDropdown(),
                  InputTxtfield_discription(),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'Status',
                            textStyle:
                                CustomTextStyles.textFontRegular(size: 14.sp),
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
                  Btn_serviceAdd(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }
}
