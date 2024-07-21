import 'package:customer_manager/controller/admob_controller.dart';
import 'package:customer_manager/controller/auth_controller.dart';
import 'package:customer_manager/controller/user_controller.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(AuthController(userController: Get.find()));
    Get.put(AdmobController());
  }
}