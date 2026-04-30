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
        child: Column(
          children: [
            CustomAppBar(
              title: "Recent Activity",
              isBackBtn: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Clear All",
                    middleText: "Are you sure you want to clear all history?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      controller.deleteAllImages();
                      Get.back();
                    },
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                child: Obx(() {
                  final hasToday = controller.todayList.isNotEmpty;
                  final hasYesterday = controller.yesterdayList.isNotEmpty;

                  if (!hasToday && !hasYesterday) {
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                  Text(
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
          ],
        ),
      ),
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
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Delete",
                        middleText: "Remove this image from history?",
                        textConfirm: "Yes",
                        textCancel: "No",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.removeImage(item["image"]!);
                          Get.back();
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
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
