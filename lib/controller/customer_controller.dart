import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../model/customer.dart';
import '../util/dialog_utils.dart';
import 'auth_controller.dart';

class CustomerController extends GetxController {
  DatabaseReference _dbRef = FirebaseDatabase.instance.ref(AppConstants.stores);
  final List<Customer> _customerList = [];
  final List<Customer> _showCustomerList = [];
  bool _isLoading = true;

  List<Customer> get customerList => _showCustomerList;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    _dbRef = _dbRef
        .child(Get.find<AuthController>().appUser?.adminUid ?? 'WrongKey');
    getAllCustomer();
  }

  getAllCustomer() async {
    try {
      _isLoading = true;
      var snapshots = await _dbRef.child(AppConstants.customers).get();
      _customerList.clear();
      _showCustomerList.clear();
      if (snapshots.exists) {
        for (var snapshot in snapshots.children) {
          if (snapshot.exists) {
            _customerList.add(Customer.fromJson(snapshot.value as Map));
          }
        }
        _showCustomerList.addAll(_customerList);
      }
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
    _isLoading = false;
    update();
  }

  Future setCustomer(Customer customer) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customer.id.toString())
          .set(customer.toJson());
      _customerList.add(customer);
      _showCustomerList.add(customer);
      Get.back();
      update();
    } catch (e) {
      Get.back();
      DialogUtils.showMessage(e.toString());
    }
  }

  Future updateCustomer(Customer customer) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customer.id.toString())
          .update(customer.toJson());
      getAllCustomer();
      Get.back();
      update();
    } catch (e) {
      Get.back();
      DialogUtils.showMessage(e.toString());
    }
  }

  Future deleteCustomer(Customer customer) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customer.id.toString())
          .remove();
      await getAllCustomer();
      update();
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
  }

  void searchCustomer(String keyword) {
    if (keyword.trim().isEmpty) {
      _showCustomerList.addAll(_customerList);
    }
    _showCustomerList.clear();
    _showCustomerList.addAll(_customerList.where((e) =>
        e.name.contains(keyword) ||
        e.name.toLowerCase().contains(keyword.toLowerCase()) ||
        e.phone.contains(keyword) ||
        e.address.contains(keyword)));
    update();
  }
}
