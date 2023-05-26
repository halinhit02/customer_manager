import 'package:customer_manager/model/notification.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart' hide Notification;

class NotificationAddWidget extends StatelessWidget {
  const NotificationAddWidget({Key? key, required this.onConfirmed})
      : super(key: key);

  final Function(Notification) onConfirmed;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    var timeMillis = DateTime.now().millisecondsSinceEpoch;
    var notification = Notification(
        id: timeMillis.toString(),
        title: '',
        content: '',
        createdAt: timeMillis);

    onAccepted() {
      if (notification.title.isEmpty) {
        DialogUtils.showMessage("Nhập tiêu đề.");
        return;
      } else if (notification.content.isEmpty) {
        DialogUtils.showMessage("Nhập nội dung.");
        return;
      }
      onConfirmed.call(notification);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      constraints: const BoxConstraints(maxHeight: 300, maxWidth: 400),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Thêm Thông báo',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10),
              child: TextField(
                controller: titleController,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  notification.title = value;
                },
                onSubmitted: (value) {
                  onAccepted();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  hintText: 'Nhập tiêu đề',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                controller: contentController,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  notification.content = value;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  hintText: 'Nhập nội dung',
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
