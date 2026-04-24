import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/subscription_view/controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/utils/app_colors.dart';
import 'package:image_compressor/widgets/app_button_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_text.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              _topBar(),
              SizedBox(height: 1.h),
              _titleSection(),
              SizedBox(height: 2.h),
              _featureHeader(),
              SizedBox(height: 1.h),
              _featureList(),
              const Text(
                "Go Premium",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              _plans(),

              SizedBox(height: 10.h),
              Obx(
                    () => AppButtonWidget(
                  text: "Continue",
                  width: double.infinity,
                  height: 7.h,
                  buttonColor: AppColors.buttonColor,
                  textColor: Colors.white,
                  radius: 20,

                  loader: controller.isPurchasing.value,

                  onPressed: controller.onContinue,
                ),
              ),
              SizedBox(height: 1.h),

              const Text(
                "Auto-renewable. Cancel anytime.",
                style: TextStyle(fontSize: 16, color: Color(0xff727272)),
              ),
              SizedBox(height: 2.h),

              _bottomLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomLinks() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              openUrl("https://image-compressor-legal.netlify.app/eula");
            },
            child: const Text(
              "USER AGREEMENT",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xffA0A0A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "•",
              style: TextStyle(fontSize: 11, color: Color(0xffA0A0A0)),
            ),
          ),
          GestureDetector(
            onTap: () {
              openUrl("https://image-compressor-legal.netlify.app/privacy-policy");

            },
            child: const Text(
              "PRIVACY POLICY",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xffA0A0A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "•",
              style: TextStyle(fontSize: 11, color: Color(0xffA0A0A0)),
            ),
          ),
          GestureDetector(
            onTap: controller.restorePurchase,
            child: const Text(
              "RESTORE",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xffA0A0A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!success) {
        log("Could not launch URL: $url");

        Get.snackbar(
          "Error",
          "Unable to open link",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log(" URL Launch Error: $e");

      Get.snackbar(
        "Error",
        "Something went wrong while opening link",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _topBar() {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, size: 34, color: Colors.black),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Upgrade to Pro",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Unlock Unlimited Image Compression &\nPremium Features",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xff7A7A7A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureHeader() {
    return const Row(
      children: [
        Expanded(child: SizedBox()),
        SizedBox(
          width: 70,
          child: Center(
            child: Text(
              "PREMIUM",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff777777),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 52,
          child: Center(
            child: AppText(
              "BASIC",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff777777),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureList() {
    return Expanded(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.features.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          final item = controller.features[index];
          return Row(
            children: [
              SvgPicture.asset(item.icon),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  item.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 70,
                child: Center(
                  child: item.ifPremium
                      ? SvgPicture.asset(AppAssets.checkMark)
                      : Icon(Icons.remove),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 52,
                child: Center(
                  child: item.isBasic
                      ? SvgPicture.asset(AppAssets.checkMark)
                      : Icon(Icons.remove),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _plans() {
    return Obx(
          () => Row(
        children: [

          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectPlan(0),
              child: Container(
                height: 106,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: controller.selectedPlan.value == 0
                        ? const Color(0xff4D79BE)
                        : const Color(0xffD8DCE8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const AppText(
                      "MONTHLY",
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),

                    const Spacer(),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: controller.monthlyPrice.value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const TextSpan(
                            text: "/month",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectPlan(1),
              child: Container(
                height: 106,
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                ),
                decoration: BoxDecoration(
                  color: controller.selectedPlan.value == 1
                      ? const Color(0xffEEF3FC)
                      : Colors.white,
                  border: Border.all(
                    color: controller.selectedPlan.value == 1
                        ? const Color(0xff4D79BE)
                        : const Color(0xffD8DCE8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        const AppText(
                          "YEARLY",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),

                        const SizedBox(height: 4),

                        AppText(
                          controller.yearlyPrice.value,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),

                        const SizedBox(height: 4),

                        const AppText(
                          "Best Value",
                          fontSize: 13,
                          color: Color(0xff666666),
                        ),
                      ],
                    ),

                    Positioned(
                      right: -16,
                      bottom: -16,
                      child: Container(
                        width: 66,
                        height: 42,
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: 8,
                        ),
                        color: const Color(0xff4D79BE),
                        child: const AppText(
                          "SAVE",
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
