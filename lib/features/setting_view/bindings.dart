import 'package:get/get.dart';
import 'package:image_compressor/features/setting_view/controllr.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
   }

}