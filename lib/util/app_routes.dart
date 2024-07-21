import 'package:customer_manager/binding/global_binding.dart';
import 'package:customer_manager/binding/home_binding.dart';
import 'package:customer_manager/binding/notification_binding.dart';
import 'package:customer_manager/binding/staff_binding.dart';
import 'package:customer_manager/middleware/auth_middleware.dart';
import 'package:customer_manager/screen/history/history_screen.dart';
import 'package:customer_manager/screen/home/home_screen.dart';
import 'package:customer_manager/screen/login/login_screen.dart';
import 'package:customer_manager/screen/splash/splash_screen.dart';
import 'package:customer_manager/screen/staff/staff_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../binding/history_binding.dart';
import '../screen/note/notification_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const login = '/login';
  static const history = '/history';
  static const notification = '/notification';
  static const staff = '/staff';

  static String getHistoryRoute(String customerID) =>
      '$history?customerID=$customerID';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: history,
      binding: HistoryBinding(),
      page: () {
        String id = Get.parameters['customerID'] ?? '';
        return HistoryScreen(
          customerID: id,
        );
      },
    ),
    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: staff,
      page: () => const StaffScreen(),
      middlewares: [AuthMiddleware()],
      binding: StaffBinding(),
    ),
  ];
}
