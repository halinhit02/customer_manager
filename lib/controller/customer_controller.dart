import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../model/customer.dart';
import '../util/dialog_utils.dart';

class CustomerController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final List<Customer> _customerList = [];
  final List<Customer> _showCustomerList = [];

  List<Customer> get customerList => _showCustomerList;

  @override
  void onInit() {
    getAllCustomer();
    super.onInit();
  }

  getAllCustomer() async {
    try {
      var snapshots = await _dbRef.child(AppConstants.customers).get();
      if (snapshots.exists) {
        _customerList.clear();
        _showCustomerList.clear();
        for (var snapshot in snapshots.children) {
          if (snapshot.exists) {
            _customerList.add(Customer.fromJson(snapshot.value as Map));
          }
        }
        _showCustomerList.addAll(_customerList);
      }
      update();
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
  }

  Future setCustomer(Customer customer) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customer.id.toString())
          .set(customer.toJson());
      _customerList.add(customer);
      _showCustomerList.add(customer);
      update();
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
    Get.back();
  }

  Future updateCustomer(Customer customer) async {
    try {
      await _dbRef
          .child(AppConstants.customers)
          .child(customer.id.toString())
          .set(customer.toJson());
      getAllCustomer();
      update();
    } catch (e) {
      DialogUtils.showMessage(e.toString());
    }
    Get.back();
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
    Get.back();
  }

  void searchCustomer(String keyword) {
    _showCustomerList.clear();
    if (keyword.trim().isEmpty) {
      _showCustomerList.addAll(_customerList);
    }
    _showCustomerList.addAll(_customerList.where((e) =>
        e.name.contains(keyword) ||
        e.phone.contains(keyword) ||
        e.address.contains(keyword)));
    update();
  }
}
