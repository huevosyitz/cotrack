import 'package:cotrack/core/models/user.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static const currentUserKey = "currentUser";
  static const userTypeKey = "userType";
  static const appViewModeKey = "appViewMode";

  final currentUser = ValueNotifier<UserModel?>(null);
  final Future<PackageInfo> packageInfo = () async {
    return await PackageInfo.fromPlatform();
  }();
  
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  Future<void> setCurrentUser(UserModel? user) async {
    currentUser.value = user;
    if (user == null) {
      await _asyncPrefs.remove(currentUserKey);
    } else {
      await _asyncPrefs.setString(currentUserKey, user.toJson());
    }
  }
}
