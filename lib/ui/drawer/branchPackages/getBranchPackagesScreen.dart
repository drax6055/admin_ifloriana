import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/colors.dart';
import '../../../utils/custom_text_styles.dart';
import 'getBranchPackagesController.dart';

class GetBranchPackagesScreen extends StatelessWidget {
  final GetBranchPackagesController controller =
      Get.put(GetBranchPackagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Packages'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.getBranchPackages,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.packages.isEmpty) {
          return Center(
            child: Text(
              'No packages found',
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: controller.packages.length,
          itemBuilder: (context, index) {
            final package = controller.packages[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16.r),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            package.packageName,
                            style: CustomTextStyles.textFontBold(size: 18.sp),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${package.packagePrice}',
                              style: CustomTextStyles.textFontBold(
                                size: 18.sp,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _showDeleteConfirmation(package.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      package.description,
                      style: CustomTextStyles.textFontRegular(size: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Valid from ${_formatDate(package.startDate)} to ${_formatDate(package.endDate)}',
                      style: CustomTextStyles.textFontRegular(
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Services Included:',
                      style: CustomTextStyles.textFontBold(size: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    ...package.packageDetails.map((detail) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${detail.serviceId.name} (${detail.quantity}x)',
                                  style: CustomTextStyles.textFontRegular(
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${detail.discountedPrice}',
                                style: CustomTextStyles.textFontRegular(
                                  size: 14.sp,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 8.h),
                    Text(
                      'Available at:',
                      style: CustomTextStyles.textFontBold(size: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    ...package.branchId.map((branch) => Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            branch.name,
                            style:
                                CustomTextStyles.textFontRegular(size: 14.sp),
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteConfirmation(String packageId) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Package'),
        content: Text('Are you sure you want to delete this package?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePackage(packageId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
