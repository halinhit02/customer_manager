import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static showAlertDialog(
      BuildContext context, String message, Function onAcceptClicked) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
                  "Thông báo",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: Text(message),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      onAcceptClicked();
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ]));
  }

  static void showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void showMessage(String message, {bool isError = true}) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: isError ? Colors.red.shade700 : Get.theme.primaryColor,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
