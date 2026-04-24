import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:image_compressor/features/subscription_view/subscription_model.dart';
import 'package:image_compressor/utils/app_assets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  static const String _monthlyid = "com.solinovation.image.compressor.monthly";

  static const String _yearlyid = "com.solinovation.image.compressor.yearly";

  static const Set<String> _productIds = {
    _monthlyid,
    _yearlyid,
  };

  final firestore = FirebaseFirestore.instance;

  final selectedPlan = 1.obs;

  RxBool loading = true.obs;
  RxBool isPurchasing = false.obs;
  RxString errorMessage = ''.obs;

  RxString monthlyPrice = "--".obs;
  RxString yearlyPrice = "--".obs;

  final List<ProductDetails> _products = [];

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  List<SubscriptionModel> features = [
    SubscriptionModel(
      title: "Compress Images Fast",
      icon: AppAssets.subCompressIcon,
      isBasic: true,
      ifPremium: true,
    ),
    SubscriptionModel(
      title: "Adjust File Size Easily",
      icon: AppAssets.adjustFileIcon,
      isBasic: true,
      ifPremium: true,
    ),
    SubscriptionModel(
      title: "Set Your Desired Quality",
      icon: AppAssets.qualityIcon,
      isBasic: true,
      ifPremium: true,
    ),
    SubscriptionModel(
      title: "VIP Customer Support",
      icon: AppAssets.supportIcon,
      isBasic: false,
      ifPremium: true,
    ),
    SubscriptionModel(
      title: "Enjoy Ad-Free Experience",
      icon: AppAssets.adsIcon,
      isBasic: false,
      ifPremium: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _listenToPurchaseUpdates();
    _loadProducts();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "unknown_ios";
      }

      return "unknown_device";
    } catch (e) {
      return "error_device";
    }
  }

  Future<void> onContinue() async {
    if (_products.isEmpty) {
      Get.snackbar("Error", "Products not loaded");
      return;
    }

    final productId =
    selectedPlan.value == 0 ? _monthlyid : _yearlyid;

    final product = _products.firstWhereOrNull(
          (e) => e.id == productId,
    );

    if (product == null) {
      Get.snackbar("Error", "Product not found");
      return;
    }

    try {
      isPurchasing.value = true;

      final PurchaseParam purchaseParam =
      PurchaseParam(productDetails: product);

      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    } catch (e) {
      isPurchasing.value = false;
      Get.snackbar("Error", "Purchase failed");
    }
  }

  Future<void> restorePurchase() async {
    try {
      isPurchasing.value = true;
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      isPurchasing.value = false;
    }
  }

  Future<void> _loadProducts() async {
    try {
      loading.value = true;

      final available =
      await InAppPurchase.instance.isAvailable();

      if (!available) {
        errorMessage.value = "Store unavailable";
        return;
      }

      final response =
      await InAppPurchase.instance.queryProductDetails(
        _productIds,
      );

      _products.clear();
      _products.addAll(response.productDetails);

      for (final product in _products) {
        if (product.id == _monthlyid) {
          monthlyPrice.value = product.price;
        } else if (product.id == _yearlyid) {
          yearlyPrice.value = product.price;
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  void _listenToPurchaseUpdates() {
    _purchaseSubscription =
        InAppPurchase.instance.purchaseStream.listen(
              (purchases) {
            for (final purchase in purchases) {
              _handlePurchase(purchase);
            }
          },
        );
  }

  bool _handling = false;

  Future<void> _handlePurchase(
      PurchaseDetails purchase) async {
    if (_handling) return;

    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      _handling = true;

      try {
        final deviceId = await getDeviceId();

        final isMonthly =
            purchase.productID == _monthlyid;

        await firestore
            .collection("users")
            .doc(deviceId)
            .update({
          "deviceId": deviceId,
          "premium": true,
          "plan": isMonthly ? "MONTHLY" : "YEARLY",
          "trialsLeft": isMonthly ? 50 : 200,
          "purchaseId": purchase.purchaseID,
          "productId": purchase.productID,
          "updatedAt":
          FieldValue.serverTimestamp(),
        });

        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchase);
        }

        Get.snackbar(
          "Success",
          "Subscription Activated",
        );

        Get.back();
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to activate plan",
        );
      }

      _handling = false;
      isPurchasing.value = false;
    }

    else if (purchase.status ==
        PurchaseStatus.error) {
      isPurchasing.value = false;

      Get.snackbar(
        "Error",
        purchase.error?.message ??
            "Purchase Failed",
      );
    }

    else if (purchase.status ==
        PurchaseStatus.canceled) {
      isPurchasing.value = false;
    }
  }
}