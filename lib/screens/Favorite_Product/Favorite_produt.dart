import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:e_commerce/controller/product_controller.dart';
import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:e_commerce/screens/products_detail/view/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../utils/constants.dart';
import '../add_product_screen/add_product_screen.dart';

class FavoriteProducts extends StatelessWidget {
  FavoriteProducts({super.key});
  var controller = HomeScreenState().controller;
  ProductController productController = Get.put(ProductController());
  final List _listItem = [
    {
      'name': 'Azzouz Peiro',
      'imageurl': 'assets/images/1.jpg',
      'price': '2000',
      'profilurl':
          'https://scontent.fqsf1-1.fna.fbcdn.net/v/t1.6435-9/124055280_2713943132198874_8218075942674776209_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeFoUGYSeC__RYRNYK-IUi9chN87ouVNRwOE3zui5U1HA1HzvKDogp1hecTYP9SoghSAfcnbnjaamE-mUJHl74JG&_nc_ohc=cmWF3HX1fPEAX9Qtjur&_nc_ht=scontent.fqsf1-1.fna&oh=00_AT-JvsmybsSZ_Xb1leEDlp3-UscfjuhgApAARfP1Y_szPg&oe=63787821',
      'title': 'Glass',
      'desc':
          'Un texte est une série orale ou écrite de mots perçus comme constituant un ensemble cohérent, porteur de sens et utilisant les structures propres à une langue (conjugaisons, construction et association des phrases…).'
    },
    {
      'name': 'Azzouz Peiro',
      'imageurl': 'assets/images/4.jpg',
      'price': '2000',
      'profilurl':
          'https://scontent.fqsf1-1.fna.fbcdn.net/v/t1.6435-9/124055280_2713943132198874_8218075942674776209_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeFoUGYSeC__RYRNYK-IUi9chN87ouVNRwOE3zui5U1HA1HzvKDogp1hecTYP9SoghSAfcnbnjaamE-mUJHl74JG&_nc_ohc=cmWF3HX1fPEAX9Qtjur&_nc_ht=scontent.fqsf1-1.fna&oh=00_AT-JvsmybsSZ_Xb1leEDlp3-UscfjuhgApAARfP1Y_szPg&oe=63787821',
      'title': 'Glass',
      'desc':
          'Un texte est une série orale ou écrite de mots perçus comme constituant un ensemble cohérent, porteur de sens et utilisant les structures propres à une langue (conjugaisons, construction et association des phrases…).'
    },
    {
      'name': 'Azzouz Peiro',
      'imageurl': 'assets/images/3.jpg',
      'price': '2000',
      'profilurl':
          'https://scontent.fqsf1-1.fna.fbcdn.net/v/t1.6435-9/124055280_2713943132198874_8218075942674776209_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeFoUGYSeC__RYRNYK-IUi9chN87ouVNRwOE3zui5U1HA1HzvKDogp1hecTYP9SoghSAfcnbnjaamE-mUJHl74JG&_nc_ohc=cmWF3HX1fPEAX9Qtjur&_nc_ht=scontent.fqsf1-1.fna&oh=00_AT-JvsmybsSZ_Xb1leEDlp3-UscfjuhgApAARfP1Y_szPg&oe=63787821',
      'title': 'Glass',
      'desc':
          'Un texte est une série orale ou écrite de mots perçus comme constituant un ensemble cohérent, porteur de sens et utilisant les structures propres à une langue (conjugaisons, construction et association des phrases…).'
    }
  ];

  @override
  Widget build(BuildContext context) {
    productController.get_favorite_product();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecondaryColor,
        splashColor: Colors.white,
        onPressed: () {
          Get.to(Add_product_Screen());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: HomeScreenState().buildBottomTab(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Obx(() {
                  return Stack(
                    children: [
                      productController.isloading.value == false
                          ? Container(
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                              ),
                              child: GridView.builder(
                                  itemCount: productController
                                      .favoriteproductslist.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 1 / 1.5,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onLongPress: () {
                                        showAdaptiveActionSheet(
                                          context: context,
                                          title: const Text(
                                              'Are you sure you want to delete this image'),
                                          androidBorderRadius: 30,
                                          actions: <BottomSheetAction>[
                                            BottomSheetAction(
                                                title: const Text(
                                                  'delete ',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                onPressed: (context) {
                                                  print(
                                                      'The product id is ${productController.favoriteproductslist[index].id}');
                                                  productController
                                                      .delet_product_favorite(
                                                          productController
                                                              .favoriteproductslist[
                                                                  index]
                                                              .id,
                                                          context)
                                                      .then((value) async {
                                                    await productController
                                                        .get_favorite_product();
                                                    Get.back();
                                                  });
                                                }),
                                          ],
                                          cancelAction: CancelAction(
                                              title: const Text(
                                                  'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                opacity: 10,
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'http://islamdjemmal7.pythonanywhere.com/${productController.favoriteproductslist[index].images[0]['image']}')),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.black),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height: 200,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: BlurryContainer(
                                            child: Text(
                                              productController
                                                  .favoriteproductslist[index]
                                                  .title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                            ),
                                            blur: 5,
                                            width: double.infinity,
                                            height: 50,
                                            elevation: 0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : CircularProgressIndicator(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
