import 'package:customer_manager/controller/customer_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(CustomerController());
  }
}