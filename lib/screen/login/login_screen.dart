import 'package:customer_manager/util/app_constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              controller: TextEditingController(),
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
              controller: TextEditingController(),
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
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {},
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
