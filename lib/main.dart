import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/view/SplashScreen.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    clearCache();
  });
}

Future<void> clearCache() async {
  DefaultCacheManager().emptyCache();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return StreamProvider<InternetConnectionStatus>(
        initialData: InternetConnectionStatus.connected,
        create: (_) {
          return InternetConnectionChecker().onStatusChange;
        },
        child: GetMaterialApp(
          theme: ThemeData(
              primaryColor: Appcolor.COLOR_PRIMARY,
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                color: Appcolor.COLOR_PRIMARY,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                floatingLabelStyle: TextStyle(color: Appcolor.COLOR_PRIMARY),
                iconColor: Appcolor.COLOR_PRIMARY,
                contentPadding: EdgeInsets.all(10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1, color: Appcolor.COLOR_PRIMARY),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              )),
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
