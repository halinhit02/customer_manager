import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:customer_manager/binding/global_binding.dart';
import 'package:customer_manager/firebase_options.dart';
import 'package:customer_manager/util/app_constants.dart';
import 'package:customer_manager/util/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await FirebaseRemoteConfig.instance
      .setDefaults(AppConstants.defaultValueFireConfig);
  await FirebaseRemoteConfig.instance.fetchAndActivate();
  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
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
      initialRoute: AppRoutes.splash,
    );
  }
}
