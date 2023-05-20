import 'package:customer_manager/model/history.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:flutter/material.dart';

class HistoryAddWidget extends StatelessWidget {
  const HistoryAddWidget(
      {Key? key, required this.onConfirmed})
      : super(key: key);

  final Function(History) onConfirmed;

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    var history = History(
        amount: 0,
        description: '',
        time: DateTime.now().millisecondsSinceEpoch);

    onAccepted() {
      if (amountController.text.isEmpty) {
        DialogUtils.showMessage("Nhập số tiền.");
        return;
      } else if (history.amount <= 0) {
        DialogUtils.showMessage("Nhập số tiền là số lớn hơn 0.");
        return;
      } else if (history.description.isEmpty) {
        DialogUtils.showMessage("Nhập mô tả cho đơn hàng.");
        return;
      }
      onConfirmed.call(history);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      constraints: const BoxConstraints(maxHeight: 300, maxWidth: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Thêm Lịch Sử',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: TextField(
              controller: amountController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                history.amount = int.parse(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                hintText: 'Nhập số tiền',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: TextField(
              controller: descriptionController,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                history.description = value;
              },
              onSubmitted: (value) {
                onAccepted();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                hintText: 'Nhập mô tả',
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
