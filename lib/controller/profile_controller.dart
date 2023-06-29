// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../Module/Profile.dart';
import 'package:http/http.dart' as http;

import 'auth_controller.dart';

class ProfileController extends GetxController {
  late File profileimg;
  RxString profile_name = ''.obs;
  RxString gender = ''.obs;
  RxString profile_prenom = ''.obs;
  RxString profile_image = 'http://islamdjemmal7.pythonanywhere.com/'.obs;
  RxString email = ''.obs;
  RxString cgender = 'male'.obs;
  RxDouble height = 0.0.obs;
  RxDouble width = 0.0.obs;
  RxDouble heightpassword = 0.0.obs;
  RxDouble widthpassword = 0.0.obs;
  RxDouble heightimage = 0.0.obs;
  RxDouble widthimage = 0.0.obs;

  void changegender(String g) {
    cgender.value = g;
  }

  Future<void> update_photo_profile(Profile profile) async {
    String accesToken;
    GetStorage box = GetStorage();

    accesToken = box.read('token')!;

    print('Patch Profile called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/profile/update/';
    if (accesToken == null) {
      print("Acces Token is null");
    } else {
      Map<String, String> requestHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesToken',
      };

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(url),
      );
      await getImage();
      print(profileimg.path);
      request.headers.addAll(requestHeaders);
      request.files.add(http.MultipartFile.fromBytes(
          'image', File(profileimg.path).readAsBytesSync(),
          filename: profileimg.path));
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 401) {
        AuthController authController = AuthController();
        authController.refreshtken();
        final respStr = await response.stream.bytesToString();
        print(respStr);
      } else {
        final respStr = await response.stream.bytesToString();
        print(respStr);
        var data = json.decode(respStr);
        print(data);
        var imgurl = data['image'];
        print('image sent succsasfule $imgurl');
      }
    }
  }

  Future<void> getprofile() async {
    print('get Profile Called ');
    Profile profile = Profile();
    String accesToken;
    GetStorage box = await GetStorage();
    accesToken = box.read('token')!;

    var url = 'http://islamdjemmal7.pythonanywhere.com/profile/';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesToken',
    };
    var res = await http
        .get(
      Uri.parse(url),
      headers: requestHeaders,
    )
        .then((value) async {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);

        var data = json.decode('${value.body.toString()}');
        if (value.statusCode == 401 ||
            data['detail'] == 'Given token not valid for any token type') {
          AuthController authController = AuthController();
          await authController.refreshtken();
          getprofile();
        } else {
          profile_name.value = data['first_name'];
          profile_prenom.value = data['last_name'];
          gender.value = data['gender'];
          email.value = data['email'];
          if (data['image'] == null) {
            print('the image is null');
          } else {
            profile_image.value =
                'http://islamdjemmal7.pythonanywhere.com/' + data['image'];
            print(profile_image.value);
            GetStorage box = await GetStorage();
            box.write('image', profile_image.value);
          }

          update();
        }
      } else {
        print('body is empty');
      }
    });
  }

  Future<void> update_profile(Profile profile) async {
    print('update Profile Called ');
    String accesToken;
    GetStorage box = GetStorage();
    accesToken = box.read('token')!;

    var url = 'http://islamdjemmal7.pythonanywhere.com/profile/update/';
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesToken',
    };
    print(profile.name);

    print(profile.prenome);

    print(cgender);
    if (profile.name == '' || profile_prenom == '') {
      print('Error Some Fields are null');

      print(profile.gender);

      print(profile.gender);

      print(profile.gender);
    } else {
      var res =
          await http.patch(Uri.parse(url), headers: requestHeaders, body: {
        'first_name': profile.name,
        'last_name': profile.prenome,
        'gender': cgender.value,
      }).then((value) async {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);

          var data = json.decode('${value.body.toString()}');

          profile.name = data['first_name'];
          profile.prenome = data['last_name'];
          profile.gender = data['gender'];
          //  profile.image_pro = data['image'];
          await getprofile();
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> update_password(String password) async {
    print('update password Called ');
    Profile profile = Profile();
    String accesToken;
    GetStorage box = await GetStorage();

    accesToken = box.read('token')!;

    var url = 'http://islamdjemmal7.pythonanywhere.com/profile/update/';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesToken',
    };

    var res = await http.patch(Uri.parse(url), headers: requestHeaders, body: {
      'password': password,
    }).then((value) {
      print(json.decode('${value.statusCode}'));
      if (value.body.isNotEmpty) {
        print(value.body);
      } else {
        print('body is empty');
      }
    });
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
// Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    File file = File(image!.path);
//print(‘Image picked’);
    profileimg = file;
  }

  void shawEditingFieldname(BuildContext context) {
    print(' shaw name called ');
    height.value = 270;
    width.value = MediaQuery.of(context).size.width - 20;
  }

  void hideEditinFieldname() {
    print(' hide name called ');
    height.value = 0.0;
    width.value = 0.0;
  }

  void shawEditingFieldpassword(BuildContext context) {
    heightpassword.value = 250.0;
    widthpassword.value = MediaQuery.of(context).size.width - 20;
  }

  void hideEditinFieldpassword() {
    height.value = 0.0;
    width.value = 0.0;
  }

  void shawEditingFieldimage(BuildContext context) {
    heightimage.value = 250.0;
    widthimage.value = MediaQuery.of(context).size.width - 20;
  }

  void hideEditinFieldimage() {
    heightimage.value = 0.0;
    widthimage.value = 0.0;
  }
}
