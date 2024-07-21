import 'package:customer_manager/controller/admob_controller.dart';
import 'package:customer_manager/controller/staff_controller.dart';
import 'package:customer_manager/model/staff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../util/number_utils.dart';

class ItemStaff extends StatelessWidget {
  const ItemStaff({Key? key, required this.staff}) : super(key: key);

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                staff.username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  staff.email,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  FormatUtils.formatDate(staff.createdAt),
                ),
              )
            ],
          ),
          Get.find<AuthController>().isAdmin()
              ? Positioned(
                  right: 0,
                  top: 5,
                  child: InkWell(
                    onTap: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                                title: const Text('Thông báo'),
                                content: const Text(
                                    'Bạn có chắc muốn xóa nhân viên này?'),
                                actions: [
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Get.find<StaffController>()
                                          .removeStaff(staff.id);
                                      Get.back();
                                      Get.find<AdmobController>().loadInterstitialAd();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              ));
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
