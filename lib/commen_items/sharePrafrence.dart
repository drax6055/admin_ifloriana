import 'dart:convert';

import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../network/model/login_model.dart';

class SharedPreferenceManager {
  static const String _accessTokenKey = 'accessToken';
  static const String KEY_USER = "login_user";


  Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }
  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
  Future<void> removeAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }

  Future<void> setUser(Login_model? user) async {
    return await storage?.write(key: KEY_USER, value: jsonEncode(user));
  }

  
  Future<void> onLogout() async {
    await removeAccessToken();
    await setUser(null);
    await storage?.delete(key: KEY_USER);
    Get.offAllNamed(Routes.loginScreen);  
  }

  Future<Login_model?> getUser() async {
    var temp = await storage?.containsKey(key: KEY_USER);
    if (temp == true) {
      String? data = await storage?.read(key: KEY_USER) ?? "";
      if (data == "" || (data == "null")) {
        return null;
      } else {
        return Login_model.fromJson(jsonDecode(data));
      }
    } else {
      return null;
    }
  }
  
  Future<String?> getToken() async {
    var user = await getUser();
    if (user != null) {
      return user.token;
    } else {
      return "";
    }
  }
}
