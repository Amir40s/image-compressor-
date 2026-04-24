import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:image_compressor/features/onboarding_screen/controller.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_compressor/features/recent_view/recent_controller.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/permission_serives.dart';

class ImageMainC extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  RxInt selectedCompression = 0.obs;
  RxString selectedFormat = "Original".obs;
  File? selectedImage;
  File? originalImage;
  int selectImageBytes = 0;
  String selectedImageSize = "";
  String compressedImageSize = "";
  String selectImageSize = "";
  String imagePath = "";
  String imageName = "";
  RxInt selectedRatio = 0.obs;
  RxBool isBeforeSelected = true.obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, String>> recentImages = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentImages();
  }

  Future<void> loadRecentImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? recentJson = prefs.getString('recent_images');

      if (recentJson != null) {
        final List<dynamic> decoded = jsonDecode(recentJson);
        final List<Map<String, String>> allImages =
            decoded.map((item) => Map<String, String>.from(item)).toList();

        // Only show top 10 for the main view
        recentImages.value = allImages.take(10).toList();
      }
    } catch (e) {
      print("Error loading recent images in main view: $e");
    }
  }


  Future<void> uploadImage() async {
    PermissionStatus status =  await PermissionService.requestGalleryPermission();
    if (PermissionService.isGranted(status)) {
      _pickImage();
    } else if (PermissionService.isLimited(status)) {
      _pickImage();
    } else if (PermissionService.isDenied(status)) {
      await PermissionService.openSettings();
    } else if (PermissionService.isPermanentDenied(status)) {
      PermissionService.openSettings();
    }
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      selectedImage = File(file.path);
      originalImage = selectedImage;
      selectImageBytes = await selectedImage!.length();
      imagePath = file.path;
      imageName = imagePath.split("/").last;
      selectedImageSize = formatBytes(selectImageBytes);
      selectImageSize = selectedImageSize;
      Get.toNamed(Routes.CompressorView);
    } else {
      Get.snackbar("no image", "no image did not selected");
    }
  }

  Future<void> cropSelectedImage() async {
    if (selectedImage == null) {
      Get.snackbar("No Image", "Please select image first");
      return;
    }

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedImage!.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Photo",
          toolbarColor: const Color(0xffF7F8FC),
          toolbarWidgetColor: Colors.black,
          statusBarColor: const Color(0xffF7F8FC),
          backgroundColor: const Color(0xffF7F8FC),
          activeControlsWidgetColor: const Color(0xff4E79C7),
          dimmedLayerColor: Colors.black.withOpacity(.45),
          cropFrameColor: Colors.white,
          cropGridColor: Colors.white70,
          cropFrameStrokeWidth: 3,
          cropGridStrokeWidth: 1,
          showCropGrid: true,
          hideBottomControls: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: "Crop Photo",
          rotateButtonsHidden: false,
          rotateClockwiseButtonHidden: false,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: false,
          rectX: 0,
          rectY: 0,
          rectWidth: 300,
          rectHeight: 400,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      selectedImage = File(croppedFile.path);
      originalImage = selectedImage;
      selectImageBytes = await selectedImage!.length();
      selectImageSize = formatBytes(selectImageBytes);
      imageName = imagePath.split('/').last;
      selectedImageSize = formatBytes(selectImageBytes);
      update();
    }
  }


  String formatBytes(int bytes) {
    if (bytes < 1024) {
      return "$bytes B";
    } else if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    } else {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
  }

  final List<Map<String, String>> compressionList = [
    {
      "title": "Small file",
      "desc": "Reduces size slightly - 70% Quality",
    },
    {
      "title": "Medium file",
      "desc": "Balanced size and quality - 50% Quality",
    },
    {
      "title": "Large file",
      "desc": "Smallest size - 40% Quality",
    },
  ];


  Future<void> shareImage({String? path}) async {
    try {
      final String sharePath = path ?? selectedImage?.path ?? "";
      if (sharePath.isEmpty || !File(sharePath).existsSync()) {
        Get.snackbar("No Image", "No image available to share.");
        return;
      }

      await Share.shareXFiles(
        [XFile(sharePath)],
        text: "Check out my compressed image!",
        subject: "Compressed Image",
      );
    } catch (e) {
      Get.snackbar("Error", "Unable to share image.");
    }
  }

  Future<void> savePhoto({String? path}) async {
    try {
      final String savePath = path ?? selectedImage?.path ?? "";
      if (savePath.isEmpty || !File(savePath).existsSync()) {
        Get.snackbar("No Image", "No image available to save.");
        return;
      }

      await OpenFilex.open(savePath);

      Get.snackbar(
        "Saved",
        "Image saved successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to save image",
      );
    }
  }

  void selectCompression(int index) {
    selectedCompression.value = index;
  }


  void removeImage() {
    selectedImage = null;
    originalImage = null;
    imagePath = "";
    imageName = "";
    selectedImageSize = "";
    update();
  }

  Future<void> removeHistoryImage(String path) async {
    await RecentController.deleteRecentImage(path);
    recentImages.removeWhere((item) => item['image'] == path);
    Get.snackbar("Success", "Image removed from history");
  }

  Future<void> handleCompression() async {
    try {
      isLoading.value = true;

      final onboardingC = Get.put(OnBoardingC());
      if (onboardingC.userModel.value == null) {
        await onboardingC.initializeUser();
      }
      final user = onboardingC.userModel.value;

      if (user == null) {
        Get.snackbar("Error", "User data not loaded");
        return;
      }

      if (selectedImage == null) {
        Get.snackbar("Error", "Please select image first");
        return;
      }

      if (!user.premium && selectedCompression.value > 0) {
        Get.toNamed(Routes.subscriptionView);
        return;
      }

      if (!user.premium && user.trialsLeft <= 0) {
        Get.toNamed(Routes.subscriptionView);
        return;
      }

      final updatedUser = user.copyWith(
        trialsLeft: user.trialsLeft - 1,
      );

      onboardingC.userModel.value = updatedUser;

      await compressImage(file: selectedImage!);

      await firestore.collection("users").doc(user.deviceId).update({
        "trialsLeft": updatedUser.trialsLeft,
        "updatedAt": FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> compressImage({
    required File file,
  }) async {
    try {
      int quality = 70;

      if (selectedCompression.value == 1) {
        quality = 50;
      } else if (selectedCompression.value == 2) {
        quality = 40;
      }

      final dir = await getTemporaryDirectory();

      final targetPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: quality,
      );

      if (result == null) {
        Get.snackbar("Error", "Compression failed");
        return;
      }

       if (selectImageSize.isEmpty) {
        selectImageSize = selectedImageSize;
      }

       selectedImage = File(result.path);
      imagePath = result.path;
      imageName = result.path.split('/').last;

      final compressedBytes = await result.length();
      compressedImageSize = formatBytes(compressedBytes);

       final newItem = {
        "image": result.path,
        "type": result.path.split('.').last.toUpperCase(),
        "size": compressedImageSize,
      };
      await RecentController.addRecentImage(newItem);

       recentImages.insert(0, newItem);
      if (recentImages.length > 10) {
        recentImages.removeLast();
      }

      update();

       Get.toNamed(Routes.ResultView);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }



  void openImage(int index) {}


  void openPremium() {
    Get.toNamed(Routes.SubscriptionView);
  }

  final List<String> ratios = [
    "Free",
    "1:1",
    "4:5",
    "9:16",
    "4:3",
  ];


  void selectRatio(int index) {
    selectedRatio.value = index;
  }


  void goBack() {
    Get.back();
  }


  void compare() {
    Get.toNamed(Routes.CompareView);
  }



  void done() {
    Get.back();
  }
  void showBefore() {
    isBeforeSelected.value = true;
  }

  void showAfter() {
    isBeforeSelected.value = false;
  }


}