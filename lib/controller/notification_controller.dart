import 'package:customer_manager/model/notification.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/dialog_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final List<Notification> _notificationList = [];
  bool _isLoading = true;

  List<Notification> get notificationList => _notificationList;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    getAllNotification();
  }

  Future getAllNotification() async {
    try {
      _isLoading = true;
      var snapshots = await _dbRef.child(AppConstants.notification).get();
      _notificationList.clear();
      if (snapshots.exists) {
        for (var snapshot in snapshots.children) {
          _notificationList.add(Notification.fromMap(snapshot.value as Map));
        }
      }
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
    _isLoading = false;
    update();
  }

  Future setNotification(Notification notification) async {
    try {
      await _dbRef
          .child(AppConstants.notification)
          .child(notification.id)
          .set(notification.toMap());
      _notificationList.add(notification);
      update();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
    Get.back();
  }

  Future removeNotification(String notificationID) async {
    try {
      await _dbRef
          .child(AppConstants.notification)
          .child(notificationID)
          .remove();
      getAllNotification();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }
}
