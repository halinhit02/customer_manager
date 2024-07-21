import 'dart:ui';

import 'package:get/get.dart';

class AppConstants {
  static const APPNAME = 'CustomerX';
  static const contact = 'https://halinhit.com';

  //Message
  static const errorOccurred = 'Đã xảy ra lỗi! Vui lòng thử lại.';

  static const List<Color> colorItems = [
    Color(0xffFEADCD),
    Color(0xffFFEC9E),
    Color(0xff7AE7B9),
    Color(0xff5BD2F0),
    Color(0xff9BE7FF),
    Color(0xffB9ACF2),
  ];

  //storage
  static const appUserKey = 'appUser';
  static const installedKey = 'installed';

  //firebase
  static const appUsers = 'AppUsers';
  static const stores = 'Stores';
  static const customers = 'Customers';
  static const history = 'Histories';
  static const notification = 'Notifications';
  static const staff = 'Staffs';
  static const email = 'email';
  static const password = 'password';
  static const minimumBuildNumberApp = 'minimum_build_number_app';
  static const androidPackageApp = 'android_package_app';
  static const appleStoreId = 'apple_store_id';

  static const defaultValueFireConfig = <String, dynamic>{
    minimumBuildNumberApp: 0,
    androidPackageApp: 'com.halinhit.customer_manager',
    appleStoreId: '',
  };

  //admob
  static String bannerUnitID = GetPlatform.isAndroid
      ? 'ca-app-pub-5301774779419611/9345679737'
      : 'ca-app-pub-5301774779419611/5782790933';
  static String interstitialUnitID = GetPlatform.isAndroid
      ? 'ca-app-pub-5301774779419611/7689779292'
      : 'ca-app-pub-5301774779419611/3156627590';
  static String appOpenUnitID = GetPlatform.isAndroid
      ? 'ca-app-pub-5301774779419611/8443661607'
      : 'ca-app-pub-5301774779419611/5399647550';
}
