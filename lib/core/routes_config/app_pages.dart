import 'package:get/get.dart';
import 'package:image_compressor/features/image_main_view/binding.dart';
import 'package:image_compressor/features/image_main_view/image_main_view.dart';
import 'package:image_compressor/features/onboarding_screen/binding.dart';
import 'package:image_compressor/features/onboarding_screen/onboarding_view.dart';
import 'package:image_compressor/features/recent_view/recent_binding.dart';
import 'package:image_compressor/features/recent_view/recent_view.dart';
import 'package:image_compressor/features/setting_view/bindings.dart';
import 'package:image_compressor/features/splash_view/binding.dart';
import 'package:image_compressor/features/splash_view/splash_view.dart';
import 'package:image_compressor/features/subscription_view/binding.dart';
import 'package:image_compressor/features/subscription_view/subscription_view.dart';

import '../../features/image_main_view/compared_view.dart';
import '../../features/image_main_view/crop_image_view.dart';
import '../../features/image_main_view/image_compressor.dart';
import '../../features/image_main_view/image_result_view.dart';
import '../../features/setting_view/setting_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: "/splashView", page: () => SplashView(), binding: SplashBinding()),
    GetPage(
      name: "/OnboardingView",
      page: () => OnboardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: "/ImageMainView",
      page: () => ImageMainView(),
      binding: ImageMainViewBinding(),
    ),
    GetPage(
      name: "/CompressorView",
      page: () => CompressorView(),
      binding: ImageMainViewBinding(),
    ),
    GetPage(
      name: "/RecentView",
      page: () => RecentView(),
      binding: RecentBinding(),
    ),
    GetPage(
      name: "/SubscriptionView",
      page: () => SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: "/ResultView",
      page: () => ResultView(),
      binding: ImageMainViewBinding(),
    ),
    GetPage(
      name: "/CropView",
      page: () => CropView(),
      binding: ImageMainViewBinding(),
    ),
    GetPage(
      name: "/CompareView",
      page: () => CompareView(),
      binding: ImageMainViewBinding(),
    ),
    GetPage(
      name: "/SettingView",
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: "/SubscriptionView",
      page: () => SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
  ];
}
