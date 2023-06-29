import 'package:e_commerce/Module/product.dart';
import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:e_commerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/product_controller.dart';
import 'dropdawnb.dart';

class Add_product_Screen extends StatelessWidget {
  Add_product_Screen({super.key});

  String dropdownValue = 'Dog';
  List categorylist = <String>[
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
    'Plans'
  ];
  var titlecontroller = TextEditingController();
  var pricecontroller = TextEditingController();

  var desccontroller = TextEditingController();

  var statecontroller = TextEditingController();
  ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Get.to(() => HomeScreen());
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "Title",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Personaltextfield(
              controller: titlecontroller, context: context, title: "title"),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "Descreption",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Personaltextfield(
              controller: desccontroller,
              context: context,
              title: "descreption"),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "Price : DA",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Personaltextfield(
              controller: pricecontroller, context: context, title: "price"),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "State",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Personaltextfield(
              controller: statecontroller, context: context, title: "state"),
          SizedBox(
            height: 30,
          ),
          PersonalButton2('Add Image  + ', context),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Obx(() {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: 200,
                    child: controller.selctedimages.isEmpty
                        ? Center(
                            child: Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.grey,
                          ))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.selctedimages.length,
                            itemBuilder: ((context, index) {
                              return Image.file(
                                controller.selctedimages[index],
                                fit: BoxFit.cover,
                              );
                            })));
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButtonExample(controller),
              PersonalButton('Submit', context),
            ],
          ),
        ],
      )),
    );
  }

  Widget Personaltextfield(
      {required TextEditingController controller,
      context,
      required String title}) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: controller == desccontroller ? 200 : 50,
        decoration: BoxDecoration(
            color: fieldColor, borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(bottom: 25, left: 10),
        child: TextField(
          maxLength: title == 'price' ? 4 : 5000,
          keyboardType:
              title == 'price' ? TextInputType.number : TextInputType.text,
          controller: controller,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          maxLines: null,
          enabled: true,
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true, //<-- SEE HERE
            fillColor: fieldColor, //<-- SEE HERE
            hintText: title,
            hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),

            contentPadding: EdgeInsets.all(10),
          ),
        ));
  }

  Widget PersonalButton(title, context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accestoken = prefs.getString('token');
        print('the token from screen is  = $accestoken');
        await controller
            .add_product(
              Product(
                  title: titlecontroller.text,
                  descreption: desccontroller.text,
                  price: pricecontroller.text,
                  state: statecontroller.text,
                  category: controller.category.value),
            )
            .then((value) {
              
            });
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 200,
            height: 50,
            decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PersonalButton2(title, context) {
    return InkWell(
      onTap: () {
        controller.getImage();
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 50,
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getFromGallery() async {
    List<XFile>? images;

    ImagePicker picker = ImagePicker();
    images = await picker.pickMultiImage();
    print(images.length);
  }
}
