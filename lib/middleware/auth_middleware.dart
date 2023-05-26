import 'package:customer_manager/util/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {


  @override
  RouteSettings? redirect(String? route) {
    return FirebaseAuth.instance.currentUser != null || route == AppRoutes.login
        ? null
        : const RouteSettings(name: AppRoutes.login);
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {
  }
}