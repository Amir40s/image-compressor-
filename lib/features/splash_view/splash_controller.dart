import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final firestore =
      FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      startSplash();
    });
  }

  Future<void> startSplash() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    await handleNavigation();
  }

  Future<bool> checkFirstTime() async {
    final pref =
    await SharedPreferences.getInstance();

    return pref.getBool("isFirstTime") ??
        false;
  }

  Future<void> handleNavigation() async {
    final firstTime =
    await checkFirstTime();

    if (!firstTime) {
      Get.offAllNamed(
        Routes.onboardingView,
      );
    } else {
      Get.offAllNamed(
        Routes.imageMainView,
      );
    }
  }
}