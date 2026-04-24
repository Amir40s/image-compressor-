
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<PermissionStatus> requestGalleryPermission() async {
    if (Platform.isIOS) {
      return await Permission.photos.request();
    }

    if (Platform.isAndroid) {
       PermissionStatus status = await Permission.photos.request();

       if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.storage.request();
      }

      return status;
    }

    return PermissionStatus.denied;
  }

   static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }


   static Future<bool> openSettings() async {
    return await openAppSettings();
  }

   static bool isGranted(PermissionStatus status) => status.isGranted;

  static bool isDenied(PermissionStatus status) => status.isDenied;

  static bool isLimited(PermissionStatus status) => status.isLimited;

  static bool isPermanentDenied(PermissionStatus status) =>
      status.isPermanentlyDenied;

  static bool isRestricted(PermissionStatus status) =>
      status.isRestricted;
}