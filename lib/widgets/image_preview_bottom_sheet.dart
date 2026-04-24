import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void imagePreviewBottomSheet(String imagePath, VoidCallback removeImage,
    VoidCallback shareImage, VoidCallback saveImage) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Preview Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              File(imagePath),
              height: 480,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    removeImage();
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xffE6F0FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xff4C79C8),
                      size: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              /// Share
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    shareImage();
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xffE6F0FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: Color(0xff4C79C8),
                      size: 28,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    saveImage();
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xff4C79C8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Download",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}