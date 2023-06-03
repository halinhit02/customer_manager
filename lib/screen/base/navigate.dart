import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigate extends StatelessWidget {
  const Navigate({Key? key, required this.onCreated, this.onSearchChanged})
      : super(key: key);

  final Function() onCreated;
  final Function(String)? onSearchChanged;

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
            width: 20,
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
          MaterialButton(
            shape: const CircleBorder(),
            color: Theme.of(context).primaryColor,
            onPressed: onCreated,
            minWidth: 40,
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.add,
                size: 22,
                color: Colors.white,
              ),
            ),
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
      ),
    );
  }
}
