import 'package:customer_manager/controller/history_controller.dart';
import 'package:customer_manager/model/history.dart';
import 'package:customer_manager/screen/history/widget/history_add_widget.dart';
import 'package:customer_manager/screen/history/widget/item_history.dart';
import 'package:customer_manager/util/number_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key, required this.customerID}) : super(key: key);

  final String customerID;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<HistoryController>().getAllHistory(widget.customerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử mua hàng'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HistoryAddWidget(
                    onConfirmed: (History history) async {
                      Navigator.of(context).pop();
                      Get.find<HistoryController>()
                          .setHistory(widget.customerID, history);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<HistoryController>(builder: (historyController) {
          if (historyController.historyList.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu.'),
            );
          }
          return ListView.builder(
            itemCount: historyController.historyList.length,
            itemBuilder: (_, index) =>
                ItemHistory(history: historyController.historyList[index]),
          );
        }),
      ),
    );
  }
}
