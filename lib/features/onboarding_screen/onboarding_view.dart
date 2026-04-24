import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/onboarding_screen/components/onboarding_page.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';
import 'package:sizer/sizer.dart';

class OnboardingView extends GetView<OnBoardingC> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric( vertical: 2.w),
          child: Column(children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageC,
                itemCount: controller.onboardingPages.length,
                  onPageChanged: controller.onPageChange,
                  itemBuilder: (context, index){
                return OnboardingPage(index: index,);
              }),
            )
          ]),
        ),
      ),
    );
  }
}
