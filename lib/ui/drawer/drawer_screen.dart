import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/calender_booking/calender_screen.dart';
import 'package:flutter_template/ui/drawer/drawer_controller.dart';
import 'package:flutter_template/ui/drawer/udpate_salon_details/updateSalon_screen.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../utils/custom_text_styles.dart';
import '../../wiget/appbar/commen_appbar.dart';
import 'dashboard/dashboard_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawermenuController getController = Get.put(DrawermenuController());
    final List<DrawerItem> drawerItems = [
      DrawerItem(
          title: 'Dashboard', icon: FontAwesomeIcons.gauge, pageIndex: 0),
      DrawerItem(
          title: 'Booking', icon: FontAwesomeIcons.calendarDays, pageIndex: 1),
      DrawerItem(
          title: 'Update Salon Details', icon: Icons.update, pageIndex: 2),
      DrawerItem(
          title: 'Booking Details', icon: Icons.calendar_month, pageIndex: 2),
      DrawerItem(title: 'Logout', icon: Icons.logout, pageIndex: 3),
    ];
    final List<Map<String, dynamic>> pages = [
      {
        'title': 'Dashboard',
        'widget': const DashboardScreen(),
      },
      {
        'title': 'CalenderScreen',
        'widget': const CalenderScreen(),
      },
      {
        'title': 'Update Salon Details',
        'widget': UpdatesalonScreen(showAppBar: false),
      },
    ];

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Obx(() => CustomAppBar(
                title: getController.appBarTitle.value,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      size: 26.sp,
                    ),
                  ),
                ],
              )),
        ),
        body: Obx(() {
          final selectedIndex = getController.selectedPage.value;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedIndex < pages.length) {
              getController.appBarTitle.value = pages[selectedIndex]['title'];
            } else {
              getController.appBarTitle.value = 'Dashboard';
            }
          });
          if (selectedIndex < pages.length) {
            return pages[selectedIndex]['widget'];
          } else {
            return const DashboardScreen();
          }
        }),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 10.h),
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                accountName: Obx(() => CustomTextWidget(
                      text: getController.fullname.value.toString(),
                      textStyle: CustomTextStyles.textFontMedium(
                          size: 14.sp, color: white),
                    )),
                accountEmail: Obx(() => CustomTextWidget(
                      text: getController.email.value,
                      textStyle: CustomTextStyles.textFontMedium(
                          size: 14.sp, color: white),
                    )),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.updateSalonScreen);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundColor: secondaryColor,
                        child: Obx(() => CustomTextWidget(
                              text: getController.fullname.value.isNotEmpty
                                  ? getController.fullname.value[0]
                                      .toUpperCase()
                                  : '',
                              textStyle: CustomTextStyles.textFontMedium(
                                  size: 20.sp, color: white),
                            )),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 12.r,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit,
                              size: 12.sp, color: primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ...drawerItems.map((item) {
                return ListTile(
                  dense: true,
                  leading: Icon(
                    item.icon,
                    size: 18.sp,
                  ),
                  title: CustomTextWidget(
                    text: item.title,
                    textStyle: CustomTextStyles.textFontMedium(size: 13.sp),
                  ),
                  onTap: () {
                    getController.selectPage(item.pageIndex);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: CustomTextWidget(
                  text: 'Logout',
                  textStyle: CustomTextStyles.textFontMedium(size: 12.sp),
                ),
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

class DrawerItem {
  final String title;
  final IconData icon;
  final int pageIndex;

  DrawerItem(
      {required this.title, required this.icon, required this.pageIndex});
}
