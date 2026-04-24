import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/widgets/image_preview_bottom_sheet.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/app_text.dart';
import 'controller.dart';

class ImageMainView extends GetView<ImageMainC> {
  const ImageMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 26),
              _uploadCard(),
              const SizedBox(height: 30),
              _recentHeader(),
              const SizedBox(height: 18),
              Expanded(
                child: Obx(() {
                  if (controller.recentImages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          const AppText(
                            "No recent images",
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    itemCount: controller.recentImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 18,
                      childAspectRatio: .82,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.recentImages[index];
                      return _imageCard(
                        image: item["image"]!,
                        title: item["type"]!,
                        size: item["size"]!,
                        onTap: () {
                          imagePreviewBottomSheet(
                            item["image"]!,
                            () => controller.removeHistoryImage(item["image"]!),
                            () => controller.shareImage(path: item["image"]!),
                            () => controller.savePhoto(path: item["image"]!),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Get.toNamed(Routes.SettingView);
          },
          child: SvgPicture.asset(AppAssets.hamburgerIcon),
        ),
        const SizedBox(width: 10),
        const AppText(
          "Image Compressor",
              fontSize: 17,
            fontWeight: FontWeight.w700,
         ),
        const Spacer(),
        Obx(() {
          final onboardingC = Get.put(OnBoardingC());
          final isPremium = onboardingC.userModel.value?.premium ?? false;

          return GestureDetector(
            onTap: controller.openPremium,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xff4C79C8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isPremium
                  ? Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.crownIcon,
                          height: 14,
                          width: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        const AppText(
                          "ELITE",
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),

                      ],
                    )
                  : const AppText(
                      "PRO",
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          );
        }),
      ],
    );
  }

  Widget _uploadCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffD9E5F6),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xffBFD0EA),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.gallery,
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        AppText(
                          "Image Compressor",
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),

                        /// Subtitle
                        AppText(
                          "Select any Image from gallery",
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ],
                ),



                const SizedBox(height: 22),

                /// Upload Button
                GestureDetector(
                  onTap: controller.uploadImage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff4C79C8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.uploadIcon,
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),

                        const SizedBox(width: 10),

                        const AppText(
                          "Upload Image",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                 Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: AppText(
                    "Supported formats: JPG, PNG,WebP",
                    fontSize: 10,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

           Container(
            height: 110,
            width: 20.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Center(
              child: Image.asset(
                AppAssets.gallery,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _recentHeader() {
    return Row(
      children: [
        const Text(
          "Recent Activities",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: (){
            Get.toNamed(Routes.recentView);
          },
          child: Text(
            "See all",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageCard({
    required String image,
    required String title,
    required String size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(image),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                color: Colors.black.withOpacity(.38),
                child: Text(
                  "$title . $size",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
