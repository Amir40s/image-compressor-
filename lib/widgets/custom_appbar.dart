import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/widgets/app_text.dart';
import 'package:sizer/sizer.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double height;
  final bool isBackBtn;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    this.title,
    this.height = 120,
    this.isBackBtn = false,
    this.trailing,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTile(
        leading: isBackBtn ? IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.black,
            ),
          ),
          onPressed: () => Get.back(),
        ) : const SizedBox(width: 48),
        title: Center(
          child: AppText(
           title ?? '',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: trailing ?? const SizedBox(width: 48),
      ),
    );
  }
}
