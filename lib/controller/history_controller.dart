import 'package:customer_manager/model/history.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../util/dialog_utils.dart';
import 'auth_controller.dart';

class HistoryController extends GetxController {
  DatabaseReference _dbRef = FirebaseDatabase.instance.ref(AppConstants.stores);
  final List<History> _historyList = [];
  bool _isLoading = false;

  List<History> get historyList => _historyList;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    _dbRef = _dbRef
        .child(Get.find<AuthController>().appUser?.adminUid ?? 'WrongKey');
  }

  Future getAllHistory(String customerID) async {
    try {
      _isLoading = true;
      var snapshots = await _dbRef
          .child(AppConstants.customers)
          .child(customerID)
          .child(AppConstants.history)
          .get();
      _historyList.clear();
      if (snapshots.exists) {
        for (var snapshot in snapshots.children) {
          _historyList.add(History.fromMap(snapshot.value as Map));
        }
      }
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
    _isLoading = false;
    update();
  }

  Future setHistory(String customerID, History history) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customerID)
          .child(AppConstants.history)
          .child(history.id)
          .set(history.toMap());
      _historyList.add(history);
      update();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }

  Future deleteHistory(String customerID, String historyID) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customerID)
          .child(AppConstants.history)
          .child(historyID)
          .remove();
      await getAllHistory(customerID);
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }
}
