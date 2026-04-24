import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/image_main_view/controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_compressor/utils/app_colors.dart';
import 'package:image_compressor/widgets/app_button_widget.dart';
import 'package:image_compressor/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';


class CropView extends GetView<ImageMainC> {
  const CropView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageMainC>(
      builder: (_) {
        return Scaffold(
          backgroundColor: const Color(0xffF7F8FC),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  CustomAppBar(title: "Crop Photo", isBackBtn: true),
                  _imageCropPreview(),
                  const SizedBox(height: 26),
                  _ratioList(),
                  const SizedBox(height: 34),
                  AppButtonWidget(
                    onPressed: controller.cropSelectedImage,
                    text: "Crop Image",
                    width: 90.w,
                    height: 6.h,
                    suffixIcon: SvgPicture.asset(AppAssets.compressIcon),
                    buttonColor: AppColors.buttonColor,
                    textColor: Colors.white,
                    radius: 20,
                  ),
                  const SizedBox(height: 14),
                  AppButtonWidget(
                    onPressed: (){

                    },
                    text: "Compress",
                    width: 90.w,
                    height: 6.h,
                    suffixIcon: SvgPicture.asset(AppAssets.compressIcon),
                    buttonColor: AppColors.buttonColor,
                    textColor: Colors.white,
                    radius: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _imageCropPreview() {
    return Container(
      height: 470,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              controller.selectedImage!,
              height: 470,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratioList() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.ratios.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          return Obx(
                () => GestureDetector(
              onTap: () => controller.selectRatio(index),
              child: Container(
                width: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: controller.selectedRatio.value == index
                      ? const Color(0xff4E79C7)
                      : const Color(0xffE9E9E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  controller.ratios[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: controller.selectedRatio.value == index
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.65)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 4; i++) {
      double dx = size.width * i / 4;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    for (int i = 1; i < 4; i++) {
      double dy = size.height * i / 4;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
