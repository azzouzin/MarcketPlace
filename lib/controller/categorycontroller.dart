import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';

class CatController extends GetxController {
  static CatController instance = Get.find();

  RxDouble containerw = 0.0.obs;
  RxString category = 'all'.obs;
  void changecat(String newcat) {
    category.value = newcat;
  }

  Rx<int> selctedposition = 0.obs;
  void changeposition(int newpos) {
    selctedposition.value = newpos;
  }

  void changevaleurs(context) {
    containerw.value = (MediaQuery.of(context).size.width - 50.0);
    update();
  }

  void initialvaleurs() {
    containerw.value = 0;
    update();
  }

  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    print("Toggle drawer");
    zoomDrawerController.toggle?.call();
    update();
  }
}
