import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';
import 'package:image_compressor/utils/app_colors.dart';
import 'package:image_compressor/widgets/app_button_widget.dart';
import 'package:image_compressor/widgets/app_text.dart';
import 'package:image_compressor/widgets/custom_text_widget.dart';
import 'package:sizer/sizer.dart';

class OnboardingPage extends GetView<OnBoardingC> {
  int index;
  OnboardingPage({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.w),
                child: Image.asset(
                  controller.onboardingPages[index].assetImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.onboardingPages.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    height: 1.h,
                    width: controller.currentIndex.value == i ? 7.w : 2.w,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == i
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  CustomTextWidget(
                    text:   controller.onboardingPages[index].title,
                    fontSize: 18,
                    isFirst: index == 1 ?  true : false,
                    isLast: index ==1 ? false : true,
                    secondColor: Colors.indigo,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,),
                  SizedBox(height: 1.h),
                  AppText(
                    textAlign: TextAlign.center,
                    controller.onboardingPages[index].subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            AppButtonWidget(
              onPressed:
              controller.onboardingPages[index].buttonText == "Get Started"
                  ? controller.onSkip
                  : controller.onNextPage,
              radius: 20,
              text: controller.onboardingPages[index].buttonText,
              width: 90.w,
              height: 12.w,
              textColor: Colors.white,
              buttonColor: AppColors.buttonColor,
            ),
            index != 2
                ? TextButton(
              onPressed: controller.onSkip,
              child: AppText(
                "Skip",
                color: AppColors.textPrimery,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

}
