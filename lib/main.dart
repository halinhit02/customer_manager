import 'package:customer_manager/binding/global_binding.dart';
import 'package:customer_manager/firebase_options.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.APPNAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: GlobalBinding(),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
    );
  }
}
