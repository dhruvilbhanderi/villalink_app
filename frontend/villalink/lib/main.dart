import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/data/services/auth_service.dart';
import 'package:villalink/routes/app_pages.dart';
import 'package:villalink/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<AuthService>(() async {
    final service = AuthService();
    await service.init();
    return service;
  });
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VillaLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

