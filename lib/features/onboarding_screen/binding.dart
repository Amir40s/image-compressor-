import 'package:get/get.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnBoardingC());
   }

}