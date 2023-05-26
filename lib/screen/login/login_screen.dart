import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void onLogin(String email, String password) {
    if (email.isEmpty) {
      DialogUtils.showMessage('Nhập email người dùng.');
      return;
    } else if (!email.isEmail) {
      DialogUtils.showMessage('Email không đúng định dạng.');
    } else if (password.isEmpty) {
      DialogUtils.showMessage('Nhập mật khẩu người dùng.');
      return;
    } else if (password.length < 6) {
      DialogUtils.showMessage('Nhập mật khẩu từ 6 kí tự trở lên.');
      return;
    } else {
      DialogUtils.showLoading();
      Get.find<AuthController>()
          .signInWithEmailPassword(email, password)
          .then((value) {
        Get.back();
        Get.offAllNamed(AppRoutes.home);
      }).catchError((e) {
        Get.back();
        DialogUtils.showMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppConstants.APPNAME,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 30,
              ),
              child: Text('Quản lí khách hàng dễ dàng hơn!'),
            ),
            TextField(
              controller: emailEditingController,
              decoration: InputDecoration(
                  hintText: 'Tài khoản Email',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      width: 1,
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordEditingController,
              decoration: InputDecoration(
                hintText: 'Mật khẩu',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    width: 1,
                  ),
                ),
              ),
              onSubmitted: (value) => onLogin(
                  emailEditingController.text.trim(),
                  passwordEditingController.text),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () => onLogin(emailEditingController.text.trim(),
                  passwordEditingController.text),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).primaryColor,
              child: const SizedBox(
                width: double.maxFinite,
                child: Text(
                  'Đăng nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
