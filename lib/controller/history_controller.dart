import 'package:customer_manager/model/history.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../util/dialog_utils.dart';

class HistoryController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final List<History> _historyList = [];

  List<History> get historyList => _historyList;

  Future getAllHistory(String customerID) async {
    try {
      var snapshots = await _dbRef
          .child(AppConstants.customers)
          .child(customerID)
          .child(AppConstants.history)
          .get();
      if (snapshots.exists) {
        _historyList.clear();
        for (var snapshot in snapshots.children) {
          _historyList.add(History.fromMap(snapshot.value as Map));
        }
        update();
      }
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }

  Future setHistory(String customerID, History history) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customerID)
          .child(AppConstants.history)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set(history.toMap());
      _historyList.add(history);
      update();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }
}
