import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/model/notification.dart';
import 'package:customer_manager/util/number_utils.dart';
import 'package:flutter/cupertino.dart' hide Notification;
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';

import '../../../controller/notification_controller.dart';

class ItemNotification extends StatelessWidget {
  const ItemNotification({Key? key, required this.notification})
      : super(key: key);

  final Notification notification;

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
                notification.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  notification.content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  FormatUtils.formatDate(notification.createdAt),
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
                                    'Bạn có chắc muốn xóa thông báo này?'),
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
                                      Get.find<NotificationController>()
                                          .removeNotification(notification.id);
                                      Get.back();
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
