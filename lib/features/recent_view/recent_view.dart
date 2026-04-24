import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/recent_view/recent_controller.dart';
import 'package:image_compressor/widgets/custom_appbar.dart';
import 'package:image_compressor/widgets/image_preview_bottom_sheet.dart';

class RecentView extends GetView<RecentController> {
  const RecentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Obx(() {
            final hasToday = controller.todayList.isNotEmpty;
            final hasYesterday = controller.yesterdayList.isNotEmpty;

            if (!hasToday && !hasYesterday) {
              return Column(
                children: [
                  CustomAppBar(title: "Recent Activity", isBackBtn: true),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            "You don't have recent images yet",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(title: "Recent Activity", isBackBtn: true),
                  if (hasToday) ...[
                    const Text(
                      "Today",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 18),
                    _gridSection(controller.todayList),
                    const SizedBox(height: 30),
                  ],
                  if (hasYesterday) ...[
                    const Text(
                      "Yesterday",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 18),
                    _gridSection(controller.yesterdayList),
                  ],
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.back,
          child: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Color(0xff1F2940),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Recent Activities",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 28),
      ],
    );
  }

  Widget _gridSection(List<Map<String, String>> list) {
    return GridView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: .84,
      ),
      itemBuilder: (context, index) {
        final item = list[index];

        return GestureDetector(
          onTap: () {
            imagePreviewBottomSheet(
              item["image"]!,
              () => controller.removeImage(item["image"]!),
              () => controller.shareImage(item["image"]!),
              () => controller.savePhoto(item["image"]!),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(File(item["image"]!), fit: BoxFit.cover),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    color: Colors.black.withOpacity(.38),
                    child: Text(
                      "${item["type"]} . ${item["size"]}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
