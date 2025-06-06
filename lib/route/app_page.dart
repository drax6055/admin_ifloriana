import 'package:flutter_template/ui/auth/login/login_screen.dart';
import 'package:flutter_template/ui/auth/profile/adminProfileScreen.dart';
import 'package:flutter_template/ui/auth/register_packages/register_packages_screen.dart';
import 'package:flutter_template/ui/auth/register/register_screen.dart';
import 'package:flutter_template/ui/drawer/drawer_screen.dart';
import 'package:flutter_template/ui/drawer/udpate_salon_details/updateSalon_screen.dart';
import 'package:get/get.dart';
import '../ui/auth/forgot/forgot_screen.dart';
import '../ui/drawer/dashboard/dashboard_screen.dart';
import '../ui/splash/splash_screen.dart';
import 'app_route.dart';

class AppPages {
  static const initial = Routes.splashScreen;
  static final routes = [
    GetPage(
        name: Routes.splashScreen,
        page: () => SplashScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.loginScreen,
        page: () => LoginScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.drawerScreen,
        page: () => DrawerScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.registerScreen,
        page: () => RegisterScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.packagesScreen,
        page: () => PackagesScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.dashboardScreen,
        page: () => DashboardScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: Routes.forgotScreen,
        page: () => ForgotScreen(),
        transition: Transition.rightToLeft),

    GetPage(
        name: Routes.updateSalonScreen,
        page: () => UpdatesalonScreen(),
        transition: Transition.rightToLeft),
        GetPage(
        name: Routes.adminprofilescreen,
        page: () => Adminprofilescreen(),
        )
  ];
}
