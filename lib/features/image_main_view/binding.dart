import 'package:get/get.dart';
import 'package:image_compressor/features/image_main_view/controller.dart';

class ImageMainViewBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ImageMainC());
   }

}