import 'package:e_commerce/controller/middelware.dart';
import 'package:e_commerce/controller/services.dart';
import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen/login_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init;
  await intial();
  runApp(const MyApp());
}

Future intial() async {
  await Get.putAsync(() => MyServices().init());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: kPrimaryColor,
              fontFamily: 'Nirmala',
            ),
      ),
      getPages: [
        GetPage(name: '/', page: () => const LoginScreen(), middlewares: [
          MyMiddelware(),
        ]),
        GetPage(name: '/home', page: () => HomeScreen())
      ],
    );
  }
}
