
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/splash_view/splash_controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/widgets/app_text.dart';
import 'package:sizer/sizer.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

             TweenAnimationBuilder(
              duration:
              const Duration(milliseconds: 1400),
              tween: Tween<double>(
                begin: 0.4,
                end: 1,
              ),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                AppAssets.appLogo,
                height: 150,
              ),
            ),

              SizedBox(height: 2.h),

             TweenAnimationBuilder(
              duration:
              const Duration(milliseconds: 1800),
              tween: Tween<double>(
                begin: 60,
                end: 0,
              ),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(
                    opacity:
                    (1 - value / 60)
                        .clamp(0, 1),
                    child: child,
                  ),
                );
              },
              child: const AppText(
                "Image Compressor",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}