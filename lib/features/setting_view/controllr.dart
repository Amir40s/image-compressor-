import 'dart:io';

import 'package:get/get.dart';
import 'package:image_compressor/features/setting_view/model.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  late List<SettingModelTile> settingList = [
    SettingModelTile(
      icon: AppAssets.shareAppIcon,
      title: "Share App",
      onPressed: () {
        _shareApp();
      },
    ),
    SettingModelTile(
      icon: AppAssets.rateUs,
      title: "Rate Us",
      onPressed: () {
        rateApp();
      },
    ),
    SettingModelTile(
      icon: AppAssets.privacyPolicyIcon,
      title: "Privacy Policy",
      onPressed: () {
        launchAppUrl("https://image-compressor-legal.netlify.app/privacy-policy");
      },
    ),
    SettingModelTile(
      icon: AppAssets.termIcon,
      title: "Term and Condition",
      onPressed: () {
        launchAppUrl("https://image-compressor-legal.netlify.app/terms-and-conditions");
      },
    ),
    SettingModelTile(
      icon: AppAssets.contactUsIcon,
      title: "Contact Us",
      onPressed: () {
        launchAppUrl("https://image-compressor-legal.netlify.app/contact");
      },
    ),
  ];

  Future<void> restorePurchases() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      Get.snackbar("error", e.toString());
    }
  }

  Future<void> launchAppUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not open link");
      }
    } catch (e) {
      Get.snackbar("Error", "Invalid URL");
    }
  }


  Future<void> rateApp() async {
    const String packageName = 'com.solinovation.aihumanizer.app';

    try {
      if (Platform.isAndroid) {
        final Uri url = Uri.parse('market://details?id=$packageName');
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          await launchUrl(
            Uri.parse(
              'https://play.google.com/store/apps/details?id=$packageName',
            ),
            mode: LaunchMode.externalApplication,
          );
        }
      } else if (Platform.isIOS) {
        const String appId = '6761532677';

        final Uri url = Uri.parse('https://apps.apple.com/app/id$appId');

        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open store');
    }
  }

  Future<void> _shareApp() async {
    final appLink = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.solinovation.aihumanizer.app'
        : 'https://apps.apple.com/app/id6761532677';

    await Share.share(
      '🚀 Try this amazing AI Photo Generator app!\n$appLink',
    );
  }






}
