import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart';

import '../../model/customer.dart';
import '../../model/user_action.dart';

class EditItemBuilder extends StatelessWidget {
  const EditItemBuilder(
      {Key? key,
      required this.title,
      this.user,
      this.userAction = UserAction.create,
      required this.onConfirmed})
      : super(key: key);

  final String title;
  final UserAction userAction;
  final Customer? user;
  final Function(Customer) onConfirmed;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController moneyController = TextEditingController();

    var editedUser = Customer(id: DateTime.now().millisecondsSinceEpoch.toString());

    if (user != null) {
      editedUser = user!.clone();
      nameController.text = user!.name;
      phoneController.text = user!.phone;
      moneyController.text = "";
      if (userAction == UserAction.delete || userAction == UserAction.edit) {
        moneyController.text = user!.address.toString();
      }
    }

    onAccepted() {
      if (userAction != UserAction.delete) {
        if (editedUser.name.isEmpty) {
          DialogUtils.showMessage("Nhập họ tên khách hàng.");
          return;
        } else if (editedUser.phone.isEmpty) {
          DialogUtils.showMessage("Nhập số điện thoại khách hàng.");
          return;
        } else if (editedUser.phone.length != 10 || !editedUser.phone.startsWith('0')) {
          DialogUtils.showMessage("Số điện thoại không hợp lệ.");
          return;
        } else if (editedUser.address.isEmpty) {
          DialogUtils.showMessage("Nhập địa chỉ khách hàng.");
          return;
        }
      }
      onConfirmed.call(editedUser);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      constraints: const BoxConstraints(maxHeight: 380, maxWidth: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: TextField(
              controller: nameController,
              enabled: userAction == UserAction.create ||
                  userAction == UserAction.edit,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editedUser.name = value;
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: TextField(
              controller: phoneController,
              enabled: userAction == UserAction.create ||
                  userAction == UserAction.edit,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                editedUser.phone = value;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                hintText: 'Nhập số điện thoại',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              controller: moneyController,
              enabled: userAction != UserAction.delete,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                editedUser.address = value;
              },
              onSubmitted: (value) {
                onAccepted();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                hintText: 'Nhập địa chỉ',
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
    );
  }
}
