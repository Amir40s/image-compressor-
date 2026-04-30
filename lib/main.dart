import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/core/routes_config/app_pages.dart';
import 'package:image_compressor/core/routes_config/routess.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, _,_){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Image Compressor',
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          getPages: AppPages.routes,
          initialRoute: Routes.splashView,
         );
      }
    );
  }
}
