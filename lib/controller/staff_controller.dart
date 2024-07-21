import 'package:customer_manager/controller/user_controller.dart';
import 'package:customer_manager/model/staff.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../util/app_constants.dart';
import '../util/dialog_utils.dart';
import 'auth_controller.dart';

class StaffController extends GetxController {
  DatabaseReference _dbRef = FirebaseDatabase.instance.ref(AppConstants.stores);

  final List<Staff> _staffList = [];
  bool _isLoading = true;

  List<Staff> get staffList => _staffList;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    _dbRef = _dbRef
        .child(Get.find<AuthController>().appUser?.adminUid ?? 'WrongKey');
    getAllStaff();
  }

  Future getAllStaff() async {
    try {
      _isLoading = true;
      var snapshots = await _dbRef.child(AppConstants.staff).get();
      _staffList.clear();
      if (snapshots.exists) {
        for (var snapshot in snapshots.children) {
          if (snapshot.exists) {
            _staffList.add(Staff.fromMap(snapshot.value as Map));
          }
        }
      }
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
    _isLoading = false;
    update();
  }

  Future setStaff(Staff staff) async {
    try {
      await _dbRef.child(AppConstants.staff).child(staff.id).set(staff.toMap());
      _staffList.add(staff);
      update();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
    Get.back();
  }

  Future removeStaff(String staffID) async {
    try {
      await _dbRef.child(AppConstants.staff).child(staffID).remove();
      await Get.find<UserController>().deleteAppUser(staffID);
      getAllStaff();
    } catch (e) {
      print(e);
      DialogUtils.showMessage(e.toString());
    }
  }
}
