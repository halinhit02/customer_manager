import 'dart:convert';

import 'package:customer_manager/model/app_user.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future setUserInfo(String uid, AppUser appUser) async {
    try {
      await _dbRef.child(AppConstants.appUsers).child(uid).set(appUser.toMap());
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<AppUser> getAppUser(String uid) async {
    try {
      AppUser appUser = AppUser(isAdmin: false, adminUid: 'WrongKey');
      var snapShot = await _dbRef.child(AppConstants.appUsers).child(uid).get();
      if (snapShot.exists) {
        appUser = AppUser.fromMap(snapShot.value as Map);
      }
      return appUser;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<bool> deleteAppUser(String uid) async {
    try {
      await _dbRef.child(AppConstants.appUsers).child(uid).remove();
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future setUserLocal(AppUser appUser) async {
    return GetStorage().write(AppConstants.appUserKey, jsonEncode(appUser.toMap()));
  }

  AppUser? getUserLocal() {
    var dataString = GetStorage().read<String>(AppConstants.appUserKey);
    if (dataString != null) {
      return AppUser.fromMap(jsonDecode(dataString));
    }
    return null;
  }
}
