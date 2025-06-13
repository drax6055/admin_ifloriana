import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/ui/splash/splash_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import 'getBranchesController.dart';

class GetBranchesScreen extends StatelessWidget {
  const GetBranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Getbranchescontroller getController = Get.put(Getbranchescontroller());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Branches",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (getController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (getController.branches.isEmpty) {
            return Center(
              child: Text(
                "No branches found",
                style: TextStyle(fontSize: 16.sp),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.r),
            itemCount: getController.branches.length,
            itemBuilder: (context, index) {
              final branch = getController.branches[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16.r),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    //   child: CachedNetworkImage(
                    //     imageUrl: branch.image,
                    //     height: 150.h,
                    //     width: double.infinity,
                    //     fit: BoxFit.cover,
                    //     placeholder: (context, url) => Container(
                    //       color: Colors.grey[300],
                    //       child: const Center(child: CircularProgressIndicator()),
                    //     ),
                    //     errorWidget: (context, url, error) => Container(
                    //       color: Colors.grey[300],
                    //       child: const Icon(Icons.error),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch.name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  "${branch.address}, ${branch.city}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16.sp, color: Colors.grey),
                              SizedBox(width: 4.w),
                              Text(
                                branch.contactNumber,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16.sp, color: Colors.amber),
                              SizedBox(width: 4.w),
                              Text(
                                "${branch.ratingStar} (${branch.totalReview} reviews)",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
