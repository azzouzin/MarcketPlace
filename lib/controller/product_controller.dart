// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../Module/product.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  RxString category = 'All'.obs;
  var selctedimages = [].obs;
  RxList productslist = [].obs;

  RxList favoriteproductslist = [].obs;

  RxBool isloading = true.obs;
  RxBool imagesloading = true.obs;
  static List categorylist = <String>[
    'Sport',
    'Men',
    'women',
    'child',
    'House',
    'Clothes',
    'Phones',
    'Computers',
    'Fornutur',
    'Garden',
    'Accesoir',
    'Cars',
    'Plans',
  ];

  Future<void> add_product(Product product) async {
    String accesToken;
    GetStorage box = GetStorage();

    accesToken = box.read('token')!;

    print('add Product called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/product/create/';
    if (accesToken == null) {
      print("Acces Tpken is null");
    } else {
      print(accesToken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesToken',
      };
      var res = await http
          .post(Uri.parse(url),
              headers: requestHeaders,
              body: json.encode(
                {
                  'title': product.title,
                  'discription': product.descreption,
                  'price': product.price,
                  'state': product.state,
                  'category': product.category,
                },
              ))
          .then((value) async {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);
          var data = json.decode('${value.body.toString()}');
          if (value.statusCode == 401) {
            await AuthController().refreshtken();
            add_product(
              product,
            );
          } else {
            String id = data['id'];
            await addproductimage(id);
            print('image added');
          }
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> add_product_to_favorit(Product product) async {
    print('add Product to favorite called ');
    String? accesToken;
    GetStorage box = GetStorage();

    accesToken = box.read('token')!;
    var url =
        'http://islamdjemmal7.pythonanywhere.com/product/Fovriate/${product.id}';
    if (accesToken == null) {
      print("Acces Token is null");
    } else {
      print(accesToken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesToken',
      };
      var res = await http
          .post(Uri.parse(url),
              headers: requestHeaders,
              body: json.encode(
                {
                  'title': product.title,
                  'discription': product.descreption,
                  'price': product.price,
                  'state': product.state,
                  'category': product.category,
                },
              ))
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          if (value.statusCode == 401) {
            AuthController().refreshtken();
            add_product_to_favorit(product);
          } else {
            print(value.body);
            var txt = json.decode(value.body);
            Fluttertoast.showToast(
                msg: "${txt['details']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> addproductimage(String id) async {
    String accesToken;
    GetStorage box = GetStorage();

    accesToken = box.read('token')!;
    print('add Product image Called');
    var url = 'http://islamdjemmal7.pythonanywhere.com/product/images/{$id}/';
    print(accesToken);
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accesToken',
    };

    for (var item in selctedimages) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.fields['id'] = id;

      request.headers.addAll(requestHeaders);
      request.files.add(http.MultipartFile.fromBytes(
          'image', File(item.path).readAsBytesSync(),
          filename: item.path));
      var response = await request.send();
      print(response.statusCode);
      final respStr = await response.stream.bytesToString();
      print(respStr);
      var data = json.decode(respStr);
      var imgurl = data['image'];
      print(imgurl);
    }
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
// Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//TO convert Xfile into file
    if (image?.path == null) {
      print('no photo is selected');
    } else {
      File file = File(image!.path);
//print(‘Image picked’);
      selctedimages.add(file);
    }
  }

  Future<void> get_product(String search) async {
    isloading.value = false;
    productslist.clear();
    GetStorage box = GetStorage();

    String? accestoken = box.read('token');

    print('get Product called');
    String url;
    if (search == 'All') {
      url = 'http://islamdjemmal7.pythonanywhere.com/product/';
    } else {
      print('Search Product called with $search');
      url = 'http://islamdjemmal7.pythonanywhere.com/product/?search=$search';
    }

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$accestoken',
      };
      var res = await http
          .get(
        Uri.parse(url),
        headers: requestHeaders,
      )
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);

          var data = json.decode('${value.body.toString()}');

          var productlenth = data['count'];
          productlenth = productlenth > 10 ? 10 : data['count'];
          for (var i = 0; i < productlenth - 1; i++) {
            print('la valeur de i est = $i');
            var product = Product(
              title: data['results'][i]['title'],
              descreption: data['results'][i]['discription'],
              price: data['results'][i]['price'],
              state: data['results'][i]['state'],
              category: data['results'][i]['category'],
              id: data['results'][i]['id'],
              createdat: data['results'][i]['created_at'],
              images: [],
            );
            for (var j = 0; j < data['results'][i]['images'].length; j++) {
              product.images!.add(data['results'][i]['images'][j]);
              print(product.images![j]['id']);
            }

            productslist.add(product);
            isloading.value = false;
          }

          print(' This is list of product :  ${productslist.length}');
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> add_product_list(String search, int i) async {
    isloading.value = true;
    GetStorage box = GetStorage();

    String? accestoken = box.read('token')!;

    productslist.clear();
    print('Add get Product called');
    String url;
    if (search == 'All') {
      url = 'http://islamdjemmal7.pythonanywhere.com/product/?page=$i';
    } else {
      print('Search Product called with $search');
      url =
          'http://islamdjemmal7.pythonanywhere.com/product/?search=$search&page=$i';
    }

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$accestoken',
      };
      var res = await http
          .get(
        Uri.parse(url),
        headers: requestHeaders,
      )
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);

          var data = json.decode('${value.body.toString()}');
          var productlenth = data['count'];
          if (productlenth == null) {
            print('there is no next page');
          } else {
            print(productlenth);

            productlenth = productlenth > 10 ? 10 : data['count'];
            for (var i = 0; i < productlenth - 1; i++) {
              print('la valeur de i est = $i');
              var product = Product(
                title: data['results'][i]['title'],
                descreption: data['results'][i]['discription'],
                price: data['results'][i]['price'],
                state: data['results'][i]['state'],
                category: data['results'][i]['category'],
                id: data['results'][i]['id'],
                createdat: data['results'][i]['created_at'],
                images: [],
              );
              for (var j = 0; j < data['results'][i]['images'].length; j++) {
                product.images!.add(data['results'][i]['images'][j]);
                print(product.images![j]['id']);
              }

              productslist.add(product);
              isloading.value = false;
            }
            i = i++;
            print(' This is list of product :  ${productslist.length}');
          }
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> get_favorite_product() async {
    isloading.value = false;
    GetStorage box = GetStorage();

    String? accestoken = box.read('token')!;

    favoriteproductslist.clear();

    print('Favoriat get Product called');
    String url;

    url = 'http://islamdjemmal7.pythonanywhere.com/product/Fovriate/';

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accestoken',
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
          if (value.statusCode == 401) {
            await AuthController().refreshtken();
            get_favorite_product();
          } else {
            var productlenth = data.length;
            print(productlenth);
            for (var i = 0; i < productlenth - 1; i++) {
              print('la valeur de i est = $i');
              var product = Product(
                title: data[i]['title'],
                descreption: data[i]['discription'],
                price: data[i]['price'],
                state: data[i]['state'],
                category: data[i]['category'],
                id: data[i]['id'],
                createdat: data[i]['created_at'],
                images: [],
              );
              for (var j = 0; j < data[i]['images'].length; j++) {
                product.images!.add(data[i]['images'][j]);
                print(product.images![j]['id']);
              }

              favoriteproductslist.add(product);
              isloading.value = false;
            }
          }

          print(' This is list of product :  ${productslist.length}');
        } else {
          print('body is empty');
        }
      });
    }
  }

  Future<void> delet_product(String? id, BuildContext context) async {
    GetStorage box = GetStorage();

    String? accestoken = box.read('token')!;

    productslist.clear();

    String url = 'http://islamdjemmal7.pythonanywhere.com/product/{$id}/';
    print('delete Product called');

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accestoken',
      };
      var res = await http
          .delete(
        Uri.parse(url),
        headers: requestHeaders,
      )
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);
          if (value.statusCode == 401) {
            AuthController().refreshtken();
            delet_product(id, context);
          } else {}

          var data = json.decode(value.body.toString());
        }
      });
    }
  }

  Future<void> delet_product_image(String? id, BuildContext context) async {
    GetStorage box = GetStorage();

    String? accestoken = box.read('token')!;

    productslist.clear();
    String url =
        'http://islamdjemmal7.pythonanywhere.com/product/images/delete/{$id}/';
    print('delete image  Product called');

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accestoken',
      };
      var res = await http
          .delete(
        Uri.parse(url),
        headers: requestHeaders,
      )
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);
          if (value.statusCode == 401) {
            AuthController().refreshtken();
            delet_product(id, context);
          } else {}

          var data = json.decode(value.body.toString());
        }
      });
    }
  }

  Future<void> delet_product_favorite(String? id, BuildContext context) async {
    GetStorage box = GetStorage();

    String? accestoken = box.read('token')!;

    productslist.clear();

    String url =
        'http://islamdjemmal7.pythonanywhere.com/product/Fovriate/{$id}';
    print('delete image  Product called');

    if (accestoken == null) {
      print("Acces Tpken is null");
    } else {
      print(accestoken);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accestoken',
      };
      var res = await http
          .delete(
        Uri.parse(url),
        headers: requestHeaders,
      )
          .then((value) {
        print(json.decode('${value.statusCode}'));
        if (value.body.isNotEmpty) {
          print(value.body);
          if (value.statusCode == 401) {
            AuthController().refreshtken();
            delet_product(id, context);
          } else {}

          var data = json.decode(value.body.toString());
        }
      });
    }
  }

  void clearlist() {
    productslist.clear();
  }

  void cahngecategory(String cat) {
    category.value = cat;
  }
}
