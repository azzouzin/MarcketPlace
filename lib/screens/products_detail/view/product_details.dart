// ignore_for_file: prefer_const_constructors

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:e_commerce/Module/product.dart';
import 'package:e_commerce/controller/product_controller.dart';
import 'package:e_commerce/screens/Profile_screen/profile_screen.dart';
import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import '../controller/product_controller.dart';
import '../model/sm_product_model.dart';
import '../utils/color.dart';

class ProductDetailsView extends StatelessWidget {
  ProductDetailsView({Key? key, required this.product}) : super(key: key);
  final ProductTController productController = Get.put(ProductTController());
  final Product product;
  final List<SmProduct> smProducts = [];
  bool isLiked = false;

  ProductController controller = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < product.images!.length; i++) {
      var img = SmProduct(
        id: product.images![i]['id'],
        image: product.images![i]['image'],
      );
      smProducts.add(img);
      print(product.images![i]['id']);
    }

    return Scaffold(
      backgroundColor: AppColors.kBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.kBgColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Ionicons.chevron_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding:
                EdgeInsets.only(top: (MediaQuery.of(context).size.height / 50)),
            child: Text(
              'Delet',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w300, fontSize: 20),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: IconButton(
                color: Colors.red,
                onPressed: (() async {
                  print('button tapped');

                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'Did You want to Delete This Item ?',
                      showCancelBtn: true,
                      cancelBtnText: 'Cancel',
                      confirmBtnColor: Colors.red,
                      confirmBtnText: 'Delete',
                      onCancelBtnTap: () {
                        Get.back();
                      },
                      onConfirmBtnTap: () async {
                        await ProductController()
                            .delet_product(product.id, context);
                        Get.to(HomeScreen());
                      });
                }),
                icon: Icon(
                  Icons.remove_circle_outline,
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: double.infinity,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: smProducts.length,
                itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    height: MediaQuery.of(context).size.height * .35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.kSmProductBgColor,
                    ),
                    child: InkWell(
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: (context) {
                                  controller.delet_product_image(
                                      smProducts[index].id, context);
                                  smProducts.removeWhere((item) =>
                                      item.id == smProducts[index].id);
                                }),
                          ],
                          cancelAction: CancelAction(
                              title: const Text(
                                  'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
                        );
                      },
                      child: Image.network(
                          smProducts[index].image.contains(
                                  'http://islamdjemmal7.pythonanywhere.com/')
                              ? smProducts[index].image
                              : 'http://islamdjemmal7.pythonanywhere.com/${smProducts[index].image}',
                          fit: BoxFit.cover),
                    )),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.createdat!.substring(0, 10),
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${product.price} da',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          product.descreption,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Similar This',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: smProducts.length,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(right: 6),
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.kSmProductBgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Image(
                                  height: 70,
                                  image: NetworkImage(
                                    smProducts[index].image.contains(
                                            'http://islamdjemmal7.pythonanywhere.com/')
                                        ? smProducts[index].image
                                        : 'http://islamdjemmal7.pythonanywhere.com/${smProducts[index].image}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.kGreyColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kGreyColor),
              ),
              child: Obx(() {
                return Icon(
                  productController.isLiked.value == true
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: productController.isLiked.value == true
                      ? Colors.yellow
                      : Colors.grey,
                  size: 40,
                );
              }),
            ),
            SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await controller.add_product_to_favorit(product);
                  productController.addToCart(product);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(
                    () => productController.isAddLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            'Save to Favorit',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
