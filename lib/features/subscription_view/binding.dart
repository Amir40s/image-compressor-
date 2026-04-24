import 'package:get/get.dart';
import 'package:image_compressor/features/subscription_view/controller.dart';

class SubscriptionBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(SubscriptionController());
   }

}