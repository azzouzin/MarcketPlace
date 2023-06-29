import 'package:e_commerce/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyMiddelware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (GetStorage().read('refresh') != null) {
      return RouteSettings(name: '/home');
    } else {
      return null;
    }
  }
}
