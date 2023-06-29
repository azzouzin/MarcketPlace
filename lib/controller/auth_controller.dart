// ignore: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:e_commerce/Module/product.dart';
import 'package:e_commerce/controller/product_controller.dart';
import 'package:e_commerce/screens/Forget_password/login_screen_2/login_screen.dart';
import 'package:e_commerce/screens/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../screens/Forget_password/InputPassword_screen.dart';
import '../screens/OTP_SCREEN/otp_screen.dart';
import '../screens/home_screen/home_screen.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final box = GetStorage();
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  RxString accesstoken = ''.obs;
  RxString token = ''.obs;
  RxString refrshtoken = ''.obs;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> register(String email, String password, String firstName,
      String lastName, BuildContext context) async {
    print('regster called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/register/';

    var res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'email': email,
                'password': password,
                'first_name': firstName,
                'last_name': lastName,
              },
            ))
        .then((value) {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        var body = json.decode(value.body);
        token.value = body['token'];
        Get.to(OTPSCREEN('${body['token']}', false));
        print(token.value);
      } else {
        var body = json.decode(value.body);
        var txt = body;
        QuickAlert.show(
          context: context,
          text: txt["email"][0],
          type: QuickAlertType.error,
        );
      }
    });
  }

  Future<void> login(String email, password, BuildContext context) async {
    print('Login called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/login/';

    var res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'email': email,
                'password': password,
              },
            ))
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        var data = json.decode('${value.body.toString()}');
        refrshtoken.value = data['tokens']['refresh'];
        print('The refrsh Token value is :  ${refrshtoken.value}');
        accesstoken.value = data['tokens']['access'];
        refrshtoken.value = data['tokens']['refresh'];
        print('The acces Token value is :  ${accesstoken.value}');
        print('The reresh Token value is :  ${refrshtoken.value}');
        ProductController product_controller = ProductController();
        product_controller.get_product('all');
        box.write('token', accesstoken.value);
        box.write('refresh', refrshtoken.value);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      } else {
        if (value.statusCode == 401) {
          refresh();

          QuickAlert.show(
            context: context,
            text: value.body.toString(),
            type: QuickAlertType.error,
          );
        }
      }
    });
  }

  Future<void> verify(
      String otp, BuildContext context, String token, bool forget) async {
    print('verify called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/verify/{${token}}';

    var res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'otp': otp,
              },
            ))
        .then((value) {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: Colors.blue,
            confirmBtnText: "OKey",
            onConfirmBtnTap: () {
              if (forget == true) {
                Get.to(InputPassword(
                  token: token,
                ));
              } else {
                Get.back();
              }
            },
            text: 'your email is verified');
      } else {
        if (value.statusCode == 401) {
          refresh();
        } else {
          QuickAlert.show(
            context: context,
            text: value.body.toString(),
            type: QuickAlertType.error,
          );
        }
      }
    });
  }

  Future<void> googlelogin(
    String email,
    first,
    last,
    idclient,
    BuildContext context,
  ) async {
    print(' google Login called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/social/google/';

    var res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'email': email,
                'first_name': first,
                'last_name': last,
                'id_client':
                    '330044050606-6pj3vbmqrn2qndasdhui790748636l5v.apps.googleusercontent.com',
              },
            ))
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        var data = json.decode('${value.body.toString()}');
        refrshtoken.value = data['tokens']['refresh'];
        print('The refrsh Token value is :  ${refrshtoken.value}');
        accesstoken.value = data['tokens']['access'];
        refrshtoken.value = data['tokens']['refresh'];
        print('The acces Token value is :  ${accesstoken.value}');
        print('The reresh Token value is :  ${refrshtoken.value}');
        ProductController product_controller = ProductController();
        product_controller.get_product('all');
        box.write('token', accesstoken.value);
        box.write('refresh', refrshtoken.value);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      } else {
        if (value.statusCode == 401) {
          refresh();

          QuickAlert.show(
            context: context,
            text: value.body.toString(),
            type: QuickAlertType.error,
          );
        }
      }
    });
  }

  Future<void> passwordchange(String token, String password, context) async {
    print('verify called');
    var url =
        'http://islamdjemmal7.pythonanywhere.com/auth/forgetpassword/{${token}}';

    var res = await http
        .patch(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'password': password,
              },
            ))
        .then((value) {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnColor: Colors.blue,
            confirmBtnText: "Okey",
            onConfirmBtnTap: () {
              Get.to(LoginScreen2());
            },
            text: 'your password change sucssfuly ');
      } else {
        if (value.statusCode == 401) {
          refresh();
        } else {
          QuickAlert.show(
            context: context,
            text: value.body.toString(),
            type: QuickAlertType.error,
          );
        }
      }
    });
  }

  Future<void> delete(String password) async {
    print('delete called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/delete/';

    if (password == null) {
    } else {}
    var res = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'password': password,
              },
            ))
        .then((value) {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
    });
  }

  Future<int?> refreshtken() async {
    String? refresht;
    print('refresh called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/refresh/';
    refresht = box.read('refresh');
    if (refresh == null) {
      return 0;
    }
    await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'refresh': refresht,
              },
            ))
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
        var data = json.decode(value.body.toString());

        if (data['detail'] == 'Token is invalid or expired') {
          return 1;
        } else {
          accesstoken.value = data['access'];

          print('The acces Token value is :  ${accesstoken.value}');

          box.write('token', accesstoken.value);

          print('THe NEW Refresh Token is ${box.read('token')}');
          return 0;
        }
      } else {
        print('body is empty');
        return 1;
      }
    });
  }

  Future<void> checkemailint(String email, context) async {
    print('check email called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/chackemail/';

    await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              {
                'email': email,
              },
            ))
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
      if (value.statusCode < 400) {
        var data = json.decode('${value.body.toString()}');
        accesstoken.value = data['token'];

        print('The acces Token value is :  ${accesstoken.value}');

        box.write('token', accesstoken.value);
        // ignore: use_build_context_synchronously

      }
      if (value.statusCode == 401) {
        refresh();

        QuickAlert.show(
          context: context,
          text: value.body.toString(),
          type: QuickAlertType.error,
        );
      }
    });
  }

  Future<void> logout() async {
    print('logout email called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/auth/logout/';

    accesstoken.value = box.read('token')!;
    print(accesstoken.value);
    refrshtoken.value = box.read('refresh')!;
    print(refrshtoken.value);
    box.erase();
    await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${accesstoken.value}',
            },
            body: json.encode(
              {
                'refresh': refrshtoken.value,
              },
            ))
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
    });
  }
}
