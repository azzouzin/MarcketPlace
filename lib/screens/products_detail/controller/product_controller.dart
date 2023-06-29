import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Module/product.dart';

import 'package:http/http.dart' as http;

class ProductTController extends GetxController {
  var isAddLoading = false.obs;
  var isLiked = false.obs;

  Future<void> addToCart(Product product) async {
    isAddLoading.value = true;
    isLiked.value = true;
    update();

    Timer(const Duration(seconds: 2), () {
      isLiked.value = false;

      update();
    });
    Timer(const Duration(seconds: 2), () {
      isAddLoading.value = false;

      update();
    });
  }
}
