import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignIn = true;

  void onClicked(String email, String password, String rePassword,
      {bool isSignIn = true}) {
    if (email.isEmpty) {
      DialogUtils.showMessage('Nhập email người dùng. ');
      return;
    } else if (!email.isEmail) {
      DialogUtils.showMessage('Email không đúng định dạng. ');
    } else if (password.isEmpty) {
      DialogUtils.showMessage('Nhập mật khẩu người dùng. ');
      return;
    } else if (password.length < 6) {
      DialogUtils.showMessage('Nhập mật khẩu từ 6 kí tự trở lên. ');
      return;
    } else if (rePassword.compareTo(password) != 0 && !isSignIn) {
      DialogUtils.showMessage('Mật khẩu xác nhận không khớp. ');
      return;
    } else {
      DialogUtils.showLoading();
      if (isSignIn) {
        Get.find<AuthController>()
            .signInWithEmailPassword(email, password)
            .then((value) {
          if (value) {
            Get.back();
            Get.offAllNamed(AppRoutes.home);
          }
        }).catchError((e) {
          Get.back();
          DialogUtils.showMessage(e);
        });
      } else {
        Get.find<AuthController>()
            .signUpWithEmailPassword(email, password)
            .then((value) {
          if (value) {
            Get.back();
            DialogUtils.showMessage('Bạn đã đăng kí tài khoản thành công!',
                isError: false);
            Get.offAllNamed(AppRoutes.home);
          }
        }).catchError((e) {
          Get.back();
          DialogUtils.showMessage(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    TextEditingController rePasswordEditingController = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
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
                  textInputAction: TextInputAction.next,
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
                  height: 15,
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
                  onSubmitted: isSignIn
                      ? (value) => onClicked(
                          emailEditingController.text.trim(),
                          passwordEditingController.text,
                          rePasswordEditingController.text,
                          isSignIn: isSignIn)
                      : null,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                if (!isSignIn)
                  TextField(
                    controller: rePasswordEditingController,
                    decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu',
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
                    onSubmitted: (value) => onClicked(
                        emailEditingController.text.trim(),
                        passwordEditingController.text,
                        rePasswordEditingController.text,
                        isSignIn: isSignIn),
                    obscureText: true,
                  ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () => onClicked(
                      emailEditingController.text.trim(),
                      passwordEditingController.text,
                      rePasswordEditingController.text,
                      isSignIn: isSignIn),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).primaryColor,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      isSignIn ? 'Đăng nhập' : 'Đăng ký',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: isSignIn
                              ? 'Bạn chưa có tài khoản? '
                              : 'Bạn đã có tài khoản? ',
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    isSignIn = !isSignIn;
                                  });
                                },
                              text: isSignIn ? 'Đăng ký' : 'Đăng nhập',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.black87,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await launchUrlString(AppConstants.contact);
                  },
                  child: const Text('Private Policy | Terms of Use'),
                ),
              ],
            ),
          ),
        ],
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
