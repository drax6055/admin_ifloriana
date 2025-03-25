import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/calender_booking/calender_screen.dart';
import 'package:flutter_template/ui/drawer/drawer_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:get/get.dart';
import '../../utils/custom_text_styles.dart';
import '../../wiget/appbar/commen_appbar.dart';
import 'dashboard/dashboard_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawermenuController getController = Get.put(DrawermenuController());

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Dashboard',
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  size: 24.sp,
                ))
          ],
        ),
        body: Obx(() {
          switch (getController.selectedPage.value) {
            case 0:
              return DashboardScreen();
            case 1:
              return CalenderScreen();
            default:
              return DashboardScreen();
          }
        }),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 10.h,
              ),
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                accountName: CustomTextWidget(
                    text: 'Dharmik Thakker',
                    textStyle: CustomTextStyles.textFontMedium(
                        size: 14.sp, color: white)),
                accountEmail: CustomTextWidget(
                    text: 'dharmik@example.com',
                    textStyle: CustomTextStyles.textFontMedium(
                        size: 12.sp, color: white)),
                currentAccountPicture: InkWell(
                  onTap: () {
                    // Close the drawer first
                    Navigator.pop(context); // This will close the drawer

                    // Then navigate to the profile screen
                    Get.toNamed(Routes.profileScreen);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: secondaryColor,
                        child: CustomTextWidget(
                          text: 'DT',
                          textStyle: CustomTextStyles.textFontMedium(
                              size: 20.sp, color: white),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 12.r,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 12.sp,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: CustomTextWidget(
                    text: 'Dashboard',
                    textStyle: CustomTextStyles.textFontMedium(size: 15.sp)),
                onTap: () {
                  getController.selectPage(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: CustomTextWidget(
                    text: 'Calender Booking',
                    textStyle: CustomTextStyles.textFontMedium(size: 15.sp)),
                onTap: () {
                  getController.selectPage(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: CustomTextWidget(
                    text: 'Logout',
                    textStyle: CustomTextStyles.textFontMedium(size: 15.sp)),
                onTap: () async {
                  await getController.onLogoutPress();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
