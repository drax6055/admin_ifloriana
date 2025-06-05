import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsController.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:flutter_template/wiget/loading.dart';
import 'package:get/get.dart';

class Staffdetailsscreen extends StatelessWidget {
  const Staffdetailsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Staffdetailscontroller getController =
        Get.put(Staffdetailscontroller());

    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: white,
        ),
        child: Obx(() {
          if (getController.isLoading.value) {
            return Center(
              child: CustomLoadingAvatar(),
            );
          }
          if (getController.staffList.isEmpty) {
            return Center(
                child: CustomTextWidget(
              text: 'No Staff Found',
              textStyle: CustomTextStyles.textFontRegular(
                size: 12.sp,
                color: white,
              ),
            ));
          }
          return StaffExpandableList(staffList: getController.staffList);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // Add your action here
          Get.toNamed(Routes.addNewStaff);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    ));
  }
}

class StaffExpandableList extends StatelessWidget {
  final List<Data> staffList;
  StaffExpandableList({super.key, required this.staffList});
  final Staffdetailscontroller getController =
      Get.put(Staffdetailscontroller());
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getController.getCustomerDetails();
      },
      child: ListView.builder(
        itemCount: staffList.length,
        itemBuilder: (context, index) {
          final staff = staffList[index];
          var isSwitched = (staff.status == 1).obs;
          var isExpanded = false.obs;
          return Obx(() => GestureDetector(
                onTap: () => isExpanded.value = !isExpanded.value,
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryColor.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            staff.image != null && staff.image!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(staff.image!),
                                    radius: 20,
                                  )
                                : CircleAvatar(
                                    child: Icon(Icons.person),
                                    radius: 20,
                                  ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: staff.fullName ?? 'No Name',
                                          textStyle:
                                              CustomTextStyles.textFontRegular(
                                            size: 16.sp,
                                          ),
                                        ),
                                        CustomTextWidget(
                                          text: staff.email ?? '',
                                          textStyle:
                                              CustomTextStyles.textFontRegular(
                                            size: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16)),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text: "Service Details",
                                                textStyle: CustomTextStyles
                                                    .textFontRegular(
                                                  size: 18.sp,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              if ((staff.serviceId ?? [])
                                                  .isEmpty)
                                                Text(
                                                    "No services assigned to this staff.")
                                              else
                                                ...staff.serviceId!
                                                    .map((service) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 6),
                                                    child: Row(
                                                      children: [
                                                        if (service.image !=
                                                            null)
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                Image.network(
                                                              service.image!,
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomTextWidget(
                                                                text: service
                                                                        .name ??
                                                                    'Unnamed',
                                                                textStyle:
                                                                    CustomTextStyles
                                                                        .textFontBold(
                                                                  size: 16.sp,
                                                                ),
                                                              ),
                                                              CustomTextWidget(
                                                                text:
                                                                    "Duration: ${service.serviceDuration ?? 0} min",
                                                                textStyle:
                                                                    CustomTextStyles
                                                                        .textFontRegular(
                                                                  size: 14,
                                                                ),
                                                              ),
                                                              CustomTextWidget(
                                                                text:
                                                                    "Regular: ₹${service.regularPrice ?? '-'}, Member: ₹${service.membersPrice ?? '-'}",
                                                                textStyle:
                                                                    CustomTextStyles
                                                                        .textFontRegular(
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                            ],
                                          ),
                                        ),
                                        isScrollControlled: true,
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        child: CustomTextWidget(
                                          text: (staff.serviceId != null
                                              ? staff.serviceId!.length
                                                  .toString()
                                              : '0'),
                                          textStyle:
                                              CustomTextStyles.textFontRegular(
                                            size: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isExpanded.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.black,
                              size: 24,
                            ),
                          ],
                        ),
                        if (isExpanded.value)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return CustomTextWidget(
                                    text: isSwitched.value
                                        ? 'Active'
                                        : 'Deactive',
                                    textStyle: CustomTextStyles.textFontBold(
                                      size: 14.sp,
                                      color: isSwitched.value
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );
                                }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextWidget(
                                      text: ' ${staff.branchId?.name ?? 'N/A'}',
                                      textStyle:
                                          CustomTextStyles.textFontRegular(
                                        size: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            CustomSnackbar.showError(
                                              'Delete',
                                              'This feature is not implemented yet.',
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.edit,
                                                color: Colors.white,
                                                size: 20.sp),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            getController
                                                .deleteStaff(staff.id!);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.delete,
                                                color: Colors.white,
                                                size: 20.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
