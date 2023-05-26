import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/controller/notification_controller.dart';
import 'package:customer_manager/screen/note/widget/item_notification.dart';
import 'package:customer_manager/screen/note/widget/notification_add_widget.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: Get.find<AuthController>().isAdmin() ? [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      NotificationAddWidget(onConfirmed: (notification) async {
                    Navigator.of(context).pop();
                    DialogUtils.showLoading();
                    await Get.find<NotificationController>()
                        .setNotification(notification);
                  }),
                ),
              );
            },
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add),
          ),
        ] : null,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: GetBuilder<NotificationController>(
              builder: (notificationController) {
            if (notificationController.notificationList.isEmpty &&
                !notificationController.isLoading) {
              return const Center(
                child: Text('Không có dữ liệu.'),
              );
            } else if (notificationController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              itemCount: notificationController.notificationList.length,
              itemBuilder: (_, index) {
                return ItemNotification(
                  notification: notificationController.notificationList[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                indent: 20,
                endIndent: 20,
              ),
            );
          }),
        ),
      ),
    );
  }
}
