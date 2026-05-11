import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:image_compressor/features/onboarding_screen/model.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingC extends GetxController {
  late PageController pageC;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageC = PageController();
  }

  List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      assetImage: AppAssets.onBoarding1,
      title: "Compress Your Images in Seconds Instantly",
      subtitle:
          "Reduce image size in seconds without losing quality. Fast, simple, and efficient compression.",
      buttonText: "Next",
    ),
    OnboardingModel(
      assetImage: AppAssets.onBoarding2,
      title: "Set Perfect Size for Every Need",
      subtitle:
          "Resize photos for social media, websites, documents, and more with ease.",
      buttonText: "Next",
    ),
    OnboardingModel(
      assetImage: AppAssets.onBoarding3,
      title: "Powerful Tools for Perfect Photos",
      subtitle:
          "Use smart editing features to make every image look professional.",
      buttonText: "Get Started",
    ),
  ];

  void onPageChange(int index) {
    currentIndex.value = index;
  }

  void onNextPage() {
    if (currentIndex.value < onboardingPages.length - 1) {
      pageC.nextPage(
          duration: Duration(milliseconds: 240), curve: Curves.easeInOut);
    }
  }

  void getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', true);
    Get.offAllNamed(Routes.imageMainView);
  }

  void onSkip() {
    getStarted();
  }
}
