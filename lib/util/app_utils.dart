import 'package:customer_manager/util/dialog_utils.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_constants.dart';

class AppUtils {
  static Future<void> openUrl(String ytbUrl) async {
    bool isLauncher = await launchUrl(Uri.parse(ytbUrl),
        mode: LaunchMode.externalNonBrowserApplication);
    if (!isLauncher) {
      isLauncher = await launchUrl(Uri.parse(ytbUrl),
          mode: LaunchMode.externalApplication);
      if (!isLauncher) {
        print('>>> can\'t launch youtube url: $ytbUrl');
      }
    }
  }

  static openAppOnStore() {
    if (GetPlatform.isAndroid) {
      openUrl(
          'https://play.google.com/store/apps/details?id=${FirebaseRemoteConfig.instance.getString(
        AppConstants.androidPackageApp,
      )}');
    } else if (GetPlatform.isIOS) {
      openUrl(
          'https://apps.apple.com/vn/app/hzone/id${FirebaseRemoteConfig.instance.getString(AppConstants.appleStoreId)}');
    } else {
      DialogUtils.showMessage('not_available'.tr);
    }
  }

  static Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static Future<bool> isUpdate() async {
    PackageInfo packageInfo = await getPackageInfo();
    int buildNumber = int.tryParse(packageInfo.buildNumber) ?? 1;
    if (GetPlatform.isAndroid) {
      var minimumBuildNumber = FirebaseRemoteConfig.instance
          .getInt(AppConstants.minimumBuildNumberApp);
      if (minimumBuildNumber <= buildNumber) {
        return false;
      }
      return true;
    } else if (GetPlatform.isIOS) {
      var minimumBuildNumber = FirebaseRemoteConfig.instance
          .getInt(AppConstants.minimumBuildNumberApp);
      if (minimumBuildNumber <= buildNumber) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}
