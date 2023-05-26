import 'package:customer_manager/util/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../model/customer.dart';
import '../util/dialog_utils.dart';

class CustomerController extends GetxController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final List<Customer> _customerList = [];
  final List<Customer> _showCustomerList = [];
  bool _isLoading = true;

  List<Customer> get customerList => _showCustomerList;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    getAllCustomer();
    super.onInit();
  }

  getAllCustomer() async {
    try {
      _isLoading = true;
      var snapshots = await _dbRef.child(AppConstants.customers).get();
      _customerList.clear();
      if (snapshots.exists) {
        _showCustomerList.clear();
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
          .update(customer.toJson());
      getAllCustomer();
      update();
    } catch (e) {
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
