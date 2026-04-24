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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    controller.onboardingPages[index].assetImage,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
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
            index == 2?
            Positioned(
              top: 55.h,
                child: toolsCard()) : SizedBox.shrink(),
          ]
        ),
      ),
    );
  }

  Widget toolsCard(){
    return Container(
      width: 90.w,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _toolItem(
            icon: Icons.sync_alt_rounded,
            title: "Reconvert",
           ),
          _toolItem(
            icon: Icons.compare_arrows_rounded,
            title: "Compare",
           ),
          _toolItem(
            icon: Icons.crop_outlined,
            title: "Crop",
           ),
        ],
      ),
    );
  }

  Widget _toolItem({
    required IconData icon,
    required String title,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: const Color(0xff4D79C7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
