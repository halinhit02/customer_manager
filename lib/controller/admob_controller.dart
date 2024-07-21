import 'dart:math';

import 'package:customer_manager/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../util/app_routes.dart';

class AdmobController extends GetxController {
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  AppOpenAd? appOpenAd;
  bool isLoaded = false;
  int _interstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 5;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  final Duration maxCacheDuration = const Duration(hours: 4);

  DateTime? _appOpenLoadTime;

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  @override
  void onInit() async {
    super.onInit();
    await loadAppOpenAd();
    showOpenAppAd();
  }

  Future loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            Get.size.width.truncate());
    bannerAd = BannerAd(
      adUnitId: AppConstants.bannerUnitID,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        bannerAd = ad as BannerAd;
        isLoaded = true;
        update();
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        loadBannerAd();
      }),
    )..load();
  }

  Future loadInterstitialAd() {
    return InterstitialAd.load(
        adUnitId: AppConstants.interstitialUnitID,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            _interstitialLoadAttempts = 0;
            interstitialAd!.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
              loadInterstitialAd();
            }
          },
        ));
  }

  Future showInterstitialAd() async {
    int value = Random().nextInt(10) + 1;
    if (value <= 2) {
      await loadInterstitialAd();
    }
  }

  Future loadAppOpenAd({bool isSplash = false}) {
    return AppOpenAd.load(
      adUnitId: AppConstants.interstitialUnitID,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          if (isSplash) {
            _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _isShowingAd = true;
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _isShowingAd = false;
                ad.dispose();
                _appOpenAd = null;
              },
              onAdDismissedFullScreenContent: (ad) {
                _isShowingAd = false;
                ad.dispose();
                _appOpenAd = null;
                loadAppOpenAd();
              },
            );
            _appOpenAd!.show();
          }
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  void showAdIfAvailable({bool isSplash = false}) {
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAppOpenAd(isSplash: isSplash);
      return;
    }
    if (_isShowingAd) {
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      print('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    _appOpenAd!.show();
  }

  showOpenAppAd() {
    int timeMillis = GetStorage().read<int>(AppConstants.installedKey) ?? -1;
    if (timeMillis == -1) {
      timeMillis = DateTime.now().millisecondsSinceEpoch;
      GetStorage().write(AppConstants.installedKey, timeMillis);
    }
    if (DateTime.now().millisecondsSinceEpoch - timeMillis >
        24 * 60 * 60 * 1000) {
      Get.find<AdmobController>().showAdIfAvailable(isSplash: true);
    }
    Future.delayed(
      const Duration(seconds: 2),
          () => Get.offAllNamed(AppRoutes.home),
    );
  }
}
