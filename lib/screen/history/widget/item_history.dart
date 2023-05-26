import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/controller/history_controller.dart';
import 'package:customer_manager/model/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/number_utils.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory(
      {Key? key, required this.history, required this.onDeleteClicked})
      : super(key: key);

  final History history;

  final Function() onDeleteClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                FormatUtils.formatDate(history.time),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                FormatUtils.formatMoney(history.amount),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Get.find<AuthController>().isAdmin()
              ? InkWell(
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
                                    Get.back();
                                    onDeleteClicked();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
