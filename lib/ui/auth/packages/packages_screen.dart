import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../network/model/packages_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/custom_text_styles.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/appbar/commen_appbar.dart';
import '../../../wiget/custome_text.dart';
import 'packages_controller.dart';

class PackagesScreen extends StatelessWidget {
  PackagesScreen({super.key});

  final PackagesController getController = Get.put(PackagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Select Preferable Package",
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              getController.selectedFilter.value = value;
              getController.filterPackages();
            },
            itemBuilder: (BuildContext context) {
              return {'All', 'Monthly', 'Quarterly', 'Half-Yearly', 'Yearly'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          getController.fetchPackages();
        },
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Expanded(
              child: Obx(() {
                if (getController.filteredPackages.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: getController.filteredPackages.length,
                  itemBuilder: (context, index) {
                    return _buildRadioCard(
                        getController.filteredPackages[index]);
                  },
                );
              }),
            ),
            Obx(() => getController.selectedPackageId.value != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButtonExample(
                      onPressed: () => getController.startPayment(),
                      text: "Process to Payment",
                    ),
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioCard(Package_model pkg) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Obx(() {
        bool isSelected = getController.selectedPackageId.value == pkg.id;
        return GestureDetector(
          onTap: () => getController.updateSelected(pkg.id!),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected ? primaryColor : transparent,
                width: 2,
              ),
            ),
            elevation: isSelected ? 4 : 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: CustomTextWidget(
                      text: pkg.name.toString(),
                      textStyle: CustomTextStyles.textFontBold(size: 14.sp),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...pkg.servicesIncluded!
                            .map((service) => CustomTextWidget(
                                text: "• $service",
                                textStyle: CustomTextStyles.textFontRegular(
                                    size: 12.sp)))
                            .toList(),
                        SizedBox(height: 5.h),
                        CustomTextWidget(
                          text: "₹${pkg.price.toString()}",
                          textStyle: CustomTextStyles.textFontBold(
                              size: 14.sp, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
