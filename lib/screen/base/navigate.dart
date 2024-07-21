import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigate extends StatelessWidget {
  const Navigate(
      {Key? key,
      required this.onAccount,
      required this.onDeleteAccount,
      this.onSearchChanged})
      : super(key: key);

  final Function() onAccount;
  final Function() onDeleteAccount;
  final Function(String)? onSearchChanged;

  Future<void> handleClick(int item) async {
    switch (item) {
      case 0:
        onAccount();
        break;
      case 1:
        onDeleteAccount();
        break;
      default:
        await Get.find<AuthController>().signOut();
        Get.offAllNamed(AppRoutes.login);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      constraints: const BoxConstraints(
        minHeight: kToolbarHeight,
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 12,
            offset: const Offset(0, 5))
      ]),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.notification);
              },
              icon: Icon(
                Icons.book_rounded,
                color: Theme.of(context).primaryColor,
                size: 24,
              )),
          const SizedBox(
            width: 5,
          ),
          Text(
            "Quản Lý Khách Hàng",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: width >= 720
                ? TextField(
                    onChanged: (value) {
                      if (onSearchChanged != null) {
                        onSearchChanged!.call(value);
                      }
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search_rounded),
                      hintText: "Nhập họ tên hoặc số điện thoại người dùng...",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  )
                : Container(),
          ),
          !Get.find<AuthController>().isAdmin()
              ? MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await Get.find<AuthController>().signOut();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  minWidth: 40,
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.logout,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              : Get.size.width >= 480
                  ? Row(
                      children: [
                        MaterialButton(
                          shape: const CircleBorder(),
                          color: Theme.of(context).primaryColor,
                          onPressed: onAccount,
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.group_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MaterialButton(
                          shape: const CircleBorder(),
                          color: Theme.of(context).primaryColor,
                          onPressed: onDeleteAccount,
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.person_remove_rounded,
                              size: 22,
                              color: Colors.white,
                              semanticLabel: 'Xoá tài khoản',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                          shape: const CircleBorder(),
                          color: Colors.redAccent,
                          onPressed: () async {
                            await Get.find<AuthController>().signOut();
                            Get.offAllNamed(AppRoutes.login);
                          },
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.logout,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : PopupMenuButton<int>(
                      onSelected: (item) => handleClick(item),
                      itemBuilder: (context) => const [
                        PopupMenuItem<int>(value: 0, child: Text('Nhân viên')),
                        PopupMenuItem<int>(
                            value: 1, child: Text('Xoá tài khoản')),
                        PopupMenuItem<int>(value: 2, child: Text('Đăng xuất')),
                      ],
                    ),
        ],
      ),
    );
  }
}
