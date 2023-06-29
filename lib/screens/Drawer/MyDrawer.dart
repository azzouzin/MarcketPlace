import 'dart:ui';

import 'package:e_commerce/Module/Profile.dart';
import 'package:e_commerce/controller/profile_controller.dart';
import 'package:e_commerce/screens/Drawer/Draweritem.dart';
import 'package:e_commerce/screens/Profile_screen/profile_screen.dart';
import 'package:e_commerce/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../home_screen/home_screen.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List category = [
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

  var profile = Get.put(ProfileController());
  var isloading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile.getprofile().then((value) {
      profile.profile_image.value;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        bottomNavigationBar: HomeScreenState().buildBottomTab(context),
        body: SingleChildScrollView(
          child: isloading == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: HomeScreenState().controller.containerw.value,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                          image: profile.profile_image.value ==
                                  'http://islamdjemmal7.pythonanywhere.com/'
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/images/5.jpg'))
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      profile.profile_image.value)),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(50))),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 30, top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                            image: profile
                                                        .profile_image.value ==
                                                    'http://islamdjemmal7.pythonanywhere.com/'
                                                ? const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        'assets/images/5.jpg'))
                                                : DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(profile
                                                        .profile_image.value)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 6,
                            left: 20,
                            child: Text(
                              'Islem Augest',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 15,
                            left: 150,
                            child: Text(
                              'Menu',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    ...category.map((e) {
                      return InkWell(
                        onTap: (() {
                          print(profile.profile_image.value);
                          print(
                              "////////////////////////|||||||||||||||||||||||||||||||||||");
                          HomeScreenState().controller.changecat(e);
                        }),
                        child: Obx(
                          () => Mydraweritem(
                            containercolor:
                                HomeScreenState().controller.category.value == e
                                    ? TThemedata.green.withOpacity(0.09)
                                    : Colors.white,
                            title: e,
                            iconcolor:
                                HomeScreenState().controller.category.value == e
                                    ? TThemedata.green
                                    : TThemedata.grey,
                            txtcolor:
                                HomeScreenState().controller.category.value == e
                                    ? TThemedata.green
                                    : Colors.black,
                          ),
                        ),
                      );
                    })
                  ],
                ),
        ),
      ),
    );
  }
}
