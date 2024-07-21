import 'package:customer_manager/controller/staff_controller.dart';
import 'package:get/get.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaffController());
  }
}