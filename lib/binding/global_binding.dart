import 'package:customer_manager/controller/auth_controller.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(AuthController());
  }
}