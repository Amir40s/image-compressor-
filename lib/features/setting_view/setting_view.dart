import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:image_compressor/features/setting_view/controllr.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/widgets/custom_appbar.dart';
import '../../widgets/app_text.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomAppBar(title: "Setting", isBackBtn: true,),
                _premiumCard(),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    "Security",
                    type: AppTextType.heading2,
                    color: const Color(0xff222222),
                  ),
                ),
                const SizedBox(height: 14),
                Obx(() {
                  final onboardingC = Get.find<OnBoardingC>();
                  final isPremium = onboardingC.userModel.value?.premium ?? false;

                  if (!isPremium) return const SizedBox.shrink();

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: controller.restorePurchases,
                        child: Container(
                          height: 86,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffEAF1FF),
                                ),
                                child: SvgPicture.asset(AppAssets.restoreIcon),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: AppText(
                                  "Restore Subscription",
                                  type: AppTextType.body,
                                  color: const Color(0xff2B2B2B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  );
                }),

                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.settingList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.settingList[index];
                    return _settingTile(
                      icon: item.icon,
                      title: item.title,
                      onTap: item.onPressed,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _premiumCard() {
    return Obx(() {
      final onboardingC = Get.put(OnBoardingC());
      final isPremium = onboardingC.userModel.value?.premium ?? false;

      return GestureDetector(
        onTap: () {
          if (isPremium) {
            Get.snackbar("Status", "You are a premium user");
          } else {
            Get.toNamed(Routes.SubscriptionView);
          }
        },
        child: Container(
          height: 165,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [
                Color(0xff4B82F2),
                Color(0xff5D7DCE),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(AppAssets.settingProIcon,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 12),
                child: isPremium
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          AppText(
                            "You are a Premium User",
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                          SizedBox(height: 8),
                          AppText(
                            "Enjoy all exclusive features",
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            "Premium Membership",
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Icon(Icons.check, color: Colors.black, size: 18),
                              SizedBox(width: 6),
                              AppText(
                                "Enjoy Ad-Free Experience",
                                color: Colors.black54,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.check, color: Colors.black, size: 18),
                              SizedBox(width: 6),
                              AppText(
                                "VIP Customer Support",
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 30,
                            width: 88,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xffFFD400),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const AppText(
                              "Know More",
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _settingTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 86,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffEAF1FF),
              ),
              child: SvgPicture.asset(icon),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AppText(
                title,
                type: AppTextType.body,
                color: const Color(0xff2B2B2B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
