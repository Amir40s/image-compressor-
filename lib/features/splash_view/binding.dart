import 'package:get/get.dart';
import 'package:image_compressor/features/splash_view/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
   }

}