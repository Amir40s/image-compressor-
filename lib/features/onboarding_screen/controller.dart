import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:image_compressor/features/onboarding_screen/model.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/userModel/userModel.dart';

class OnBoardingC extends GetxController {
  final firestore = FirebaseFirestore.instance;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  late PageController pageC;
  RxInt currentIndex = 0.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageC =PageController();
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
    print("working");
    if(currentIndex.value < onboardingPages.length -1){
      pageC.nextPage(duration: Duration(milliseconds: 240), curve: Curves.easeInOut);
    }
    else{

    }
  }


  void getStarted() async  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    await initializeUser();


    Get.offAllNamed(Routes.imageMainView);
  }

  Future<void> initializeUser() async {
    final prefs = await SharedPreferences.getInstance();

    final alreadyCreated = prefs.getBool("isFirstTime") ?? false;

    if (!alreadyCreated) {
      await createUser();
      await prefs.setBool("isFirstTime", true);
    } else {
      await loadUser();
    }
  }

  void onSkip() {
    getStarted();
  }

  Future<void> createUser() async {
    final deviceId = await getDeviceId();

    UserModel user = UserModel(
      deviceId: deviceId,
      premium: false,
      plan: "free",
      trialsLeft: 3,

    );

    await firestore.collection("users").doc(deviceId).set({
      ...user.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    userModel.value = user;
  }

  Future<void> loadUser() async {
    final deviceId = await getDeviceId();

    final doc = await firestore.collection("users").doc(deviceId).get();

    if (doc.exists) {
      userModel.value = UserModel.fromMap(doc.data()!);
    }
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        return androidInfo.id ;
      }

      else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        return iosInfo.identifierForVendor ?? "unknown_ios";
      }

      return "unknown_device";
    } catch (e) {
      return "error_device";
    }
  }

}
