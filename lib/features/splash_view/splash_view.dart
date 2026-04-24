import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/splash_view/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
