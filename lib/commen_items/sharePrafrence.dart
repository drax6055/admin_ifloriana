import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/network/model/getAdminDetails.dart';
import 'package:flutter_template/network/model/udpateSalonModel.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import '../network/model/addSalonDetails.dart';
import '../network/model/login_model.dart';

class SharedPreferenceManager {
  static const String _keyUser = "login_user";
  static const String _keySignup = "signup_user";
  static const String _keySalonDetails = "salon_details";
  static const String _keySalonUpdate = "salon_update";

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> setUser(Login_model? user) async {
    if (user != null) {
      await storage.write(key: _keyUser, value: jsonEncode(user.toJson()));
    } else {
      await storage.delete(key: _keyUser);
    }
  }

  /// Get login user details
  Future<Login_model?> getUser() async {
    String? data = await storage.read(key: _keyUser);
    if (data == null || data.isEmpty || data == "null") {
      return null;
    }
    return Login_model.fromJson(jsonDecode(data));
  }

  Future<void> setRegisterdetails(GetAdminDetails? getRegisterDetails) async {
    if (getRegisterDetails != null) {
      await storage.write(
          key: _keySignup, value: jsonEncode(getRegisterDetails.toJson()));
      print("===> set Register Details ${getRegisterDetails.toJson()}");
    } else {
      await storage.delete(key: _keySignup);
    }
  }

  Future<GetAdminDetails?> getRegisterdetails() async {
    String? data = await storage.read(key: _keySignup);
    if (data == null || data.isEmpty || data == "null") {
      return null;
    }
    print("===> get register  details : $data");
    return GetAdminDetails.fromJson(jsonDecode(data));
  }

  // / Save signup details
  Future<void> setSalonDetails(UpdateSalonModel? getsalonDetails) async {
    if (getsalonDetails != null) {
      await storage.write(
          key: _keySalonUpdate, value: jsonEncode(getsalonDetails.toJson()));
      print("===> salon details saved: ${getsalonDetails.toJson()}");
    } else {
      await storage.delete(key: _keySignup);
    }
  }

  /// Get signup details
  Future<UpdateSalonModel?> getSalonDetails() async {
    String? data = await storage.read(key: _keySalonUpdate);
    if (data == null || data.isEmpty || data == "null") {
      return null;
    }
    print("===> salon details retrieved: $data");
    return UpdateSalonModel.fromJson(jsonDecode(data));
  }

  Future<AddsalonDetails?> getCreatedSalondetails() async {
    String? data = await storage.read(key: _keySalonDetails);
    if (data == null || data.isEmpty || data == "null") {
      return null;
    }
    return AddsalonDetails.fromJson(jsonDecode(data));
  }

  Future<void> setCreatedSalondetails(AddsalonDetails? salonDetails) async {
    if (salonDetails != null) {
      await storage.write(
          key: _keySalonDetails, value: jsonEncode(salonDetails.toJson()));
    } else {
      await storage.delete(key: _keySalonDetails);
    }
  }

  /// Get token from stored login user data
  ///
  ///
  /// current flowe goes like
  Future<String?> getToken() async {
    var user = await getUser();
    return user?.token ?? "";
  }

  /// Logout and clear data
  Future<void> onLogout() async {
    await setUser(null);
    await setSalonDetails(null);
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(Routes.loginScreen);
  }

  /// Call this after login success to redirect after 2 seconds
  Future<void> redirectToDrawerScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed(Routes.drawerScreen);
  }
}
