import 'package:customer_manager/screen/home/home_screen.dart';
import 'package:customer_manager/screen/login/login_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {

  static const home = '/home';
  static const login = '/login';

  static List<GetPage> pages = [
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: login, page: () => const LoginScreen())
  ];
}