import 'package:get/get.dart';
import 'package:image_compressor/features/recent_view/recent_controller.dart';

class RecentBinding  extends Bindings{
  @override
  void dependencies() {
 Get.put(RecentController());
  }

}