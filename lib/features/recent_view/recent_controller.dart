import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_compressor/features/image_main_view/controller.dart';

class RecentController extends GetxController {
  final RxList<Map<String, String>> todayList = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> yesterdayList = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentImages();
  }

  Future<void> loadRecentImages() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final String? recentJson = prefs.getString('recent_images');

      if (recentJson != null) {
        final List<dynamic> decoded = jsonDecode(recentJson);
        final List<Map<String, String>> allImages =
            decoded.map((item) => Map<String, String>.from(item)).toList();

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        todayList.value = allImages.where((item) {
          final date = DateTime.parse(item['date']!);
          return date.isAfter(today) || date.isAtSameMomentAs(today);
        }).toList();

        yesterdayList.value = allImages.where((item) {
          final date = DateTime.parse(item['date']!);
          return date.isBefore(today) &&
              (date.isAfter(yesterday) || date.isAtSameMomentAs(yesterday));
        }).toList();
      }
    } catch (e) {
      print("Error loading recent images: $e");
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> addRecentImage(Map<String, String> newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final String? recentJson = prefs.getString('recent_images');
    List<dynamic> allImages = [];

    if (recentJson != null) {
      allImages = jsonDecode(recentJson);
    }

    // Add new item to the beginning
    newItem['date'] = DateTime.now().toIso8601String();
    allImages.insert(0, newItem);

    // Limit to last 50 items
    if (allImages.length > 50) {
      allImages = allImages.sublist(0, 50);
    }

    await prefs.setString('recent_images', jsonEncode(allImages));
  }

  static Future<void> deleteRecentImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final String? recentJson = prefs.getString('recent_images');
    if (recentJson != null) {
      List<dynamic> allImages = jsonDecode(recentJson);
      allImages.removeWhere((item) => item['image'] == imagePath);
      await prefs.setString('recent_images', jsonEncode(allImages));
    }
  }

  Future<void> deleteAllImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_images');
    todayList.clear();
    yesterdayList.clear();
    if (Get.isRegistered<ImageMainC>()) {
      Get.find<ImageMainC>().loadRecentImages();
    }
    Get.snackbar("Success", "All history cleared");
  }

  void shareImage(String path) async {
    try {
      if (!File(path).existsSync()) {
        Get.snackbar("Error", "File does not exist");
        return;
      }
      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      Get.snackbar("Error", "Could not share image");
    }
  }

  void savePhoto(String path) async {
    try {
      if (!File(path).existsSync()) {
        Get.snackbar("Error", "File does not exist");
        return;
      }
      await OpenFilex.open(path);
    } catch (e) {
      Get.snackbar("Error", "Could not open image");
    }
  }

  void removeImage(String path) async {
    await deleteRecentImage(path);
    loadRecentImages(); // Refresh lists
    if (Get.isRegistered<ImageMainC>()) {
      Get.find<ImageMainC>().loadRecentImages();
    }
    Get.snackbar("Success", "Image removed from history");
  }

  void back() {
    Get.back();
  }

  void openItem(Map<String, String> item) {}
}