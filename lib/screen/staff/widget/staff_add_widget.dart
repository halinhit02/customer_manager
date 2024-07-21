import 'package:customer_manager/model/staff.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/dialog_utils.dart';

class StaffAddWidget extends StatelessWidget {
  const StaffAddWidget({Key? key, required this.onConfirmed}) : super(key: key);

  final Function(Staff, String) onConfirmed;

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    var timeMillis = DateTime.now().millisecondsSinceEpoch;
    var staff = Staff(
        id: timeMillis.toString(),
        username: '',
        email: '',
        createdAt: timeMillis);

    onAccepted() {
      var password = passwordController.text;
      if (staff.username.isEmpty) {
        DialogUtils.showMessage("Nhập họ tên nhân viên.");
        return;
      } else if (staff.email.isEmpty) {
        DialogUtils.showMessage("Nhập email nhân viên.");
        return;
      } else if (!staff.email.isEmail) {
        DialogUtils.showMessage('Email không đúng định dạng. ');
        return;
      } else if (password.isEmpty) {
        DialogUtils.showMessage('Nhập mật khẩu người dùng. ');
        return;
      } else if (password.length < 6) {
        DialogUtils.showMessage('Nhập mật khẩu từ 6 kí tự trở lên. ');
        return;
      }
      onConfirmed.call(staff, password);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      constraints: const BoxConstraints(maxHeight: 410, maxWidth: 400),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Thêm Nhân Viên',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10),
              child: TextField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  staff.username = value;
                },
                onSubmitted: (value) {
                  onAccepted();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  hintText: 'Nhập họ và tên',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  staff.email = value;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  hintText: 'Nhập email nhân viên',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  hintText: 'Nhập mật khẩu mới',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: onAccepted,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
