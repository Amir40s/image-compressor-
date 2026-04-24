import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController{

  final firestore = FirebaseFirestore.instance;
  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigation();
    });
  }

Future<bool> checkFirstTime() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool("isFirstTime") ?? false;
}
  Future<void> handleNavigation() async {
    bool firstTime = await  checkFirstTime();
    if(!firstTime){
      Get.offNamed(Routes.onboardingView);
    }
    else{
      Get.offNamed(Routes.imageMainView);
    }

  }


}