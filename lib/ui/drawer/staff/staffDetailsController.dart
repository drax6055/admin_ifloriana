import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/utils/custom_text_styles.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GetStaffDetails {
  String? message;
  List<Data>? data;

  GetStaffDetails({this.message, this.data});

  GetStaffDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? fullName;
  String? email;
  BranchId? branchId;
  String? image;
  List<dynamic>? serviceId; // Added this line

  Data(
      {this.fullName,
      this.email,
      this.branchId,
      this.image,
      this.serviceId}); // Modified this line

  Data.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    branchId =
        json['branch_id'] != null ? BranchId.fromJson(json['branch_id']) : null;
    image = json['image'];
    // Handle both List<String> and List<Map> for service_id
    if (json['service_id'] != null) {
      if (json['service_id'] is List) {
        serviceId = List<dynamic>.from(json['service_id']);
      } else {
        serviceId = [];
      }
    } else {
      serviceId = [];
    }
  }
}

class BranchId {
  String? name;
  BranchId({this.name});
  BranchId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

class Staffdetailscontroller extends GetxController {
  var staffList = <Data>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerDetails();
  }

  Future<void> getCustomerDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getStaffDetails}',
        (json) => GetStaffDetails.fromJson(json),
      );
      staffList.value = response.data ?? [];
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to check email: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class StaffExpandableList extends StatelessWidget {
  final List<Data> staffList;
  const StaffExpandableList({super.key, required this.staffList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        var isExpanded = false.obs;
        return Obx(() => GestureDetector(
              onTap: () => isExpanded.value = !isExpanded.value,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
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
                              : const CircleAvatar(
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
                                Container(
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
                                          ? staff.serviceId!.length.toString()
                                          : '0'),
                                      textStyle:
                                          CustomTextStyles.textFontRegular(
                                        size: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
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
                              CustomTextWidget(
                                text:
                                    'Branch: ${staff.branchId?.name ?? 'N/A'}',
                                textStyle: CustomTextStyles.textFontRegular(
                                  size: 12.sp,
                                  color: Colors.grey,
                                ),
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
    );
  }
}
