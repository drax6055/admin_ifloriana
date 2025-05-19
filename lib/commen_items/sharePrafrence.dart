import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import '../network/model/addSalonDetails.dart';
import '../network/model/login_model.dart';
import '../network/model/signup_model.dart';

class SharedPreferenceManager {
  static const String _accessTokenKey = 'accessToken';
  static const String _keyUser = "login_user";
  static const String _keySignup = "signup_user";
  static const String _keySalonDetails = "salon_details";

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

  // / Save signup details
  Future<void> setSignupDetails(Sigm_up_model? signup) async {
    if (signup != null) {
      await storage.write(key: _keySignup, value: jsonEncode(signup.toJson()));
    } else {
      await storage.delete(key: _keySignup);
    }
  }

  /// Get signup details
  Future<Sigm_up_model?> getSignupDetails() async {
    String? data = await storage.read(key: _keySignup);
    if (data == null || data.isEmpty || data == "null") {
      return null;
    }
    return Sigm_up_model.fromJson(jsonDecode(data));
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
    await setSignupDetails(null);
    Get.offAllNamed(Routes.loginScreen);
  }
}
