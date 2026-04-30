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

class ResultView extends GetView<ImageMainC> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Image Compressor", isBackBtn: true),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  children: [
                    _topInfoCard(),
                    const SizedBox(height: 16),
                    _imagePreview(),
                    const SizedBox(height: 18),
                    _toolBox(),
                    const SizedBox(height: 22),
                    _bottomButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          AppText("Original : ${controller.selectImageSize.isEmpty ? controller.selectedImageSize : controller.selectImageSize}", fontSize: 13),
          const Spacer(),
          SvgPicture.asset(AppAssets.leftArrowIcon),
          const Spacer(),
          AppText("Compressed : ${controller.compressedImageSize}", fontSize: 13),
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return GetBuilder<ImageMainC>(
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.file(
                  controller.selectedImage!,
                  height: 390,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 34,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff5D89C9).withOpacity(.3),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: AppText(
                  controller.compressedImageSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _toolBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _toolItem(
            icon: AppAssets.comparedIcon,
            title: "Reconvert",
            onTap: controller.goBack,
          ),
          _toolItem(
            icon: AppAssets.comparedIcon,
            title: "Compare",
            onTap: controller.compare,
          ),
          _toolItem(
            icon: AppAssets.cropIcon,
            title: "Crop",
            onTap: controller.cropSelectedImage,
          ),
        ],
      ),
    );
  }

  Widget _toolItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xff4E79C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: SvgPicture.asset(icon)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.shareImage,
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: const Color(0xffD9E6FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.share_outlined, color: Color(0xff4E79C7)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButtonWidget(
            text: "Save to Photo",
            onPressed: controller.savePhoto,
            suffixIcon: SvgPicture.asset(AppAssets.compressIcon),
            buttonColor: AppColors.buttonColor,
            textColor: Colors.white,
            width: 70.w,
            height: 6.h,
            radius: 20,
          ),
        ),
      ],
    );
  }
}
