// compare_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/image_main_view/controller.dart';
import 'package:image_compressor/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/app_text.dart';

class CompareView extends GetView<ImageMainC> {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: Column(

          children: [
            CustomAppBar(title: "Compare", isBackBtn: true),

            Expanded(
              child: Column(
                children: [
                  _toggleTabs(),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Obx(() => _imageCard()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xffECECEC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: controller.showBefore,
                child: Container(
                  height: 5.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: controller.isBeforeSelected.value
                        ? const Color(0xff4E79C7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AppText(
                    "Before",
                    color: controller.isBeforeSelected.value
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: controller.showAfter,
                child: Container(
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !controller.isBeforeSelected.value
                        ? const Color(0xff4E79C7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: AppText(
                    "After",
                    color: !controller.isBeforeSelected.value
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCard() {
    final bool before = controller.isBeforeSelected.value;

    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.file(
            before ? controller.originalImage! : controller.selectedImage!,
            width: double.infinity,
            height: 560,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: 42,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xff5D89C9),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: AppText(
            before
                ? controller.selectImageSize
                : controller.compressedImageSize,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
