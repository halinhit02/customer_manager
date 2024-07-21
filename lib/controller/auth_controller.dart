import 'package:customer_manager/controller/user_controller.dart';
import 'package:customer_manager/model/app_user.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/app_constants.dart';

class AuthController extends GetxController {
  final UserController userController;

  AuthController({required this.userController});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? appUser;

  bool isAdmin() {
    return appUser != null && (appUser?.isAdmin ?? false);
  }

  String getUid() {
    return _auth.currentUser?.uid ?? 'WrongKey';
  }

  @override
  void onInit() {
    super.onInit();
    appUser = userController.getUserLocal();
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        appUser = await userController.getAppUser(credential.user!.uid);
        userController.setUserLocal(appUser!);
        await saveEmailPassword(email, password);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.code);
    } catch (e) {
      print(e.toString());
      return Future.error(AppConstants.errorOccurred);
    }
  }

  Future<bool> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        appUser = AppUser(
          isAdmin: true,
          adminUid: credential.user!.uid,
        );
        userController.setUserLocal(appUser!);
        await userController.setUserInfo(
          credential.user!.uid,
          appUser!,
        );
        saveEmailPassword(email, password);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('email-already-in-use')) {
        return Future.error('Email này đã được sử dụng.');
      }
      return Future.error(e.message ?? e.code);
    } catch (e) {
      print(e.toString());
      return Future.error(AppConstants.errorOccurred);
    }
  }

  Future<User?> createStaffAccount(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await signOut();
        String email = GetStorage().read(AppConstants.email) ?? '';
        String password = GetStorage().read(AppConstants.password) ?? '';

        if (email.isNotEmpty && password.isNotEmpty) {
          await signInWithEmailPassword(email, password);
        }
        var user = AppUser(
          isAdmin: false,
          adminUid: appUser!.adminUid,
        );
        await userController.setUserInfo(
          credential.user!.uid,
          user,
        );
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('email-already-in-use')) {
        return Future.error('Email này đã được sử dụng.');
      }
      return Future.error(e.message ?? e.code);
    } catch (e) {
      print(e.toString());
      return Future.error(AppConstants.errorOccurred);
    }
  }

  Future saveEmailPassword(String email, String password) async {
    await GetStorage().write(AppConstants.email, email);
    await GetStorage().write(AppConstants.password, password);
  }

  Future<void> deleteAccount() async {
    await FirebaseDatabase.instance
        .ref()
        .child(AppConstants.appUsers)
        .child(appUser?.adminUid ?? 'WrongKey')
        .remove();
    await FirebaseDatabase.instance
        .ref()
        .child(AppConstants.stores)
        .child(appUser?.adminUid ?? 'WrongKey')
        .remove();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser?.delete();
    }
    DialogUtils.showMessage('Tài khoản của bạn đã bị xoá.', isError: false);
    await signOut();
  }

  Future<void> signOut({bool removeStorage = false}) {
    appUser = null;
    if (removeStorage) {
      GetStorage().remove(AppConstants.email);
      GetStorage().remove(AppConstants.password);
      GetStorage().remove(AppConstants.appUserKey);
    }
    return _auth.signOut();
  }
}
