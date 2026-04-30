import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/image_main_view/controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/utils/app_colors.dart';
import 'package:image_compressor/widgets/app_button_widget.dart';
import 'package:image_compressor/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/app_text.dart';
import '../onboarding_screen/controller.dart';

class CompressorView extends GetView<ImageMainC> {
  const CompressorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: Column(

          children: [
            CustomAppBar(title: "Select Compressor",isBackBtn: true,),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    _selectedImageCard(),
                    const SizedBox(height: 34),
                     AppText(
                      "Select Compression Option",
                           fontSize: 16, fontWeight: FontWeight.w800
                     ),
                    const SizedBox(height: 18),

                    ...List.generate(
                      controller.compressionList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Obx(
                          () {
                            final onboardingC = Get.put(OnBoardingC());
                            final isPremium = onboardingC.userModel.value?.premium ?? false;
                            return _compressionTile(
                              index: index,
                              selected: controller.selectedCompression.value == index,
                              title: controller.compressionList[index]["title"]!,
                              desc: controller.compressionList[index]["desc"]!,
                              isPremium: isPremium,
                            );
                          }
                        ),
                      ),
                    ),

                    const Spacer(),
                    Obx(
                      () => AppButtonWidget(
                        onPressed: controller.handleCompression ,
                        text: "Compress",
                        loader: controller.isLoading.value,
                        suffixIcon: SvgPicture.asset(AppAssets.compressIcon),
                        width: 80.w,
                        height: 6.h,
                        radius: 20,
                        buttonColor: AppColors.buttonColor,
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _selectedImageCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            controller.selectedImage!,
            height: 30.w,
            width: 30.w,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              AppText(
                  controller.imageName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12, color: Colors.grey),
              SizedBox(height: 6),

              Text(
                "File Size",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              Text(
                controller.selectedImageSize,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),


      ],
    );
  }

  Widget _compressionTile({
    required int index,
    required bool selected,
    required String title,
    required String desc,
    required bool isPremium,
  }) {
    return GestureDetector(
      onTap: () => controller.selectCompression(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffDDE9FB) : const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(16),
          border: selected ? Border.all(color: const Color(0xff4C79C8)) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if ((index == 1 || index == 2) && !isPremium)
                        SvgPicture.asset(AppAssets.crownIcon),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(desc, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xff4C79C8) : Colors.transparent,
                border: Border.all(color: Colors.black),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

}
