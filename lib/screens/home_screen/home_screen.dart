import 'package:e_commerce/controller/product_controller.dart';
import 'package:e_commerce/controller/profile_controller.dart';
import 'package:e_commerce/screens/Favorite_Product/Favorite_produt.dart';
import 'package:e_commerce/screens/Profile_screen/profile_screen.dart';
import 'package:e_commerce/screens/add_product_screen/add_product_screen.dart';
import 'package:e_commerce/screens/products_detail/utils/color.dart';
import 'package:e_commerce/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../controller/categorycontroller.dart';
import '../../utils/constants.dart';
import '../Drawer/Draweritem.dart';
import '../products_detail/view/product_details.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var _selctedcat = 'all';
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  TextEditingController searchcontroller = TextEditingController();
  List<String> categorylist = [
    'All',
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

  final tabs = ['Home', 'Category', 'Faovrite', 'Profile'];

  int selectedPosition = 0;

  List listItem = [];

  CatController controller = Get.put(CatController());

  ProductController productcontroller = Get.put(ProductController());
  ProfileController profilecontroler = Get.put(ProfileController());
  ScrollController scrollController = ScrollController();
  int i = 2;
  scrollListener() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      print('LOAD HERE');
      setState(() {
        bool isloading = true;
      });
      await productcontroller.add_product_list('All', i);
      i++;
      setState(() {
        listItem.addAll(productcontroller.productslist);
        isloading = false;
      });
    }
  }

  bool isloading = true;
  PageController pageviewcontroller = PageController();
  @override
  initState() {
    // TODO: implement initState
    scrollController.addListener(scrollListener);
    productcontroller.get_product('All').then((value) {
      setState(() {
        listItem.addAll(productcontroller.productslist);
        isloading = false;
        print('This IS LIST OF ITEM  $listItem');
        profilecontroler.getprofile().then((value) {});
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.removeListener(scrollListener);
    pageviewcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffolKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            listItem.clear();
            productcontroller.clearlist();
          });
          Get.to(Add_product_Screen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.kGreyColor,
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 50.0,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          colors: [kSecondaryColor, Colors.blue, Colors.white]),
                    ),
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
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 4,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${profilecontroler.profile_image.value}')),
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
                            profilecontroler.profile_name.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 15,
                          left: 140,
                          child: Text(
                            'Category',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  ...categorylist.map((e) {
                    return InkWell(
                      onTap: (() async {
                        controller.changecat(e);
                        setState(() {
                          isloading = false;
                        });
                        await productcontroller.get_product(e);
                        setState(() {
                          isloading = false;

                          listItem.clear();
                          listItem.addAll(productcontroller.productslist);

                          isloading = false;
                          print('This IS LIST OF ITEM  $listItem');
                        });
                      }),
                      child: Obx(
                        () => Mydraweritem(
                          containercolor: controller.category.value == e
                              ? TThemedata.green.withOpacity(0.09)
                              : Colors.white,
                          title: e,
                          iconcolor: controller.category.value == e
                              ? TThemedata.green
                              : TThemedata.grey,
                          txtcolor: controller.category.value == e
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
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/2.png',
            width: screenwitdh * 0.1,
            height: screenwitdh * 0.1,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenwitdh * 0.015),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 207, 200, 200)),
            child: IconButton(
              icon: Image.asset(
                'assets/images/2.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Do something when the icon is pressed
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenwitdh * 0.05, vertical: screenwitdh * 0.005),
            margin: EdgeInsets.symmetric(
                horizontal: screenwitdh * 0.025, vertical: screenwitdh * 0.015),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromARGB(255, 207, 200, 200),
            ),
            child: Container(
              width: screenwitdh * 0.1,
              height: screenwitdh * 0.1,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isloading == true
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 20, top: screenheight * 0.025),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        color: Colors.pink,
                        width: screenwitdh * 0.9,
                        height: screenheight * 0.2,
                        child: Container(
                          child: PageIndicatorContainer(
                            child: PageView(
                              children: <Widget>[
                                Text('1'),
                                Text('2'),
                                Text('3'),
                                Text('4'),
                              ],
                              controller: pageviewcontroller,
                              reverse: true,
                            ),
                            align: IndicatorAlign.bottom,
                            length: 4,
                            indicatorSpace: 10.0,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 80,
                              height: 50,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        blurStyle: BlurStyle.normal),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60)),
                              margin: const EdgeInsets.only(left: 5),
                              child: TextField(
                                controller: searchcontroller,
                                cursorColor: Colors.grey,
                                enabled: true,
                                decoration: const InputDecoration(
                                    hintText: 'find your product ',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                    filled: false),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 23,
                          ),
                          InkWell(
                            onTap: () async {
                              controller.changecat(searchcontroller.text);
                              setState(() {
                                isloading = false;
                              });
                              await productcontroller
                                  .get_product(searchcontroller.text);
                              setState(() {
                                isloading = false;

                                listItem.clear();
                                listItem.addAll(productcontroller.productslist);

                                isloading = false;
                                print('This IS LIST OF ITEM  $listItem');
                              });
                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      const BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          blurStyle: BlurStyle.normal),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60)),
                                margin: const EdgeInsets.only(
                                    top: 15, left: 5, bottom: 10),
                                child: const Icon(Icons.search_rounded)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...listItem
                          .map(
                            (item) => InkWell(
                              onTap: (() => Get.to(ProductDetailsView(
                                    product: item,
                                  ))),
                              child: cardone(
                                title: item.title,
                                price: item.price,
                                desc: item.descreption,
                                imageurl: item.images[0]['image'],
                                state: item.state,
                                createdat: item.createdat.substring(0, 10),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomTab(context),
    );
  }

  Widget buildBottomTab(context) {
    return Obx(() {
      return Container(
        color: Colors.transparent,
        child: BottomAppBar(
          color: kSecondaryColor,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TabItem(
                text: tabs[0],
                icon: Icons.home,
                isSelected: controller.selctedposition.value == 0,
                onTap: () {
                  controller.changeposition(0);
                  controller.initialvaleurs();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                  );
                },
              ),
              TabItem(
                text: tabs[1],
                icon: Icons.category_outlined,
                isSelected: controller.selctedposition.value == 1,
                onTap: () {
                  if (controller.selctedposition.value == 0) {
                    controller.changeposition(1);
                    scaffolKey.currentState!.openDrawer();
                  } else {}
                },
              ),
              const SizedBox(
                width: 48,
              ),
              TabItem(
                text: tabs[2],
                icon: Icons.favorite_border,
                isSelected: controller.selctedposition.value == 2,
                onTap: () {
                  controller.initialvaleurs();
                  listItem.clear();
                  productcontroller.clearlist();
                  Get.to(FavoriteProducts());
                  controller.changeposition(2);
                },
              ),
              TabItem(
                text: tabs[3],
                icon: Icons.person,
                isSelected: controller.selctedposition.value == 3,
                onTap: () {
                  ProfilePage(
                    buttombar: false,
                  ).profileController.getprofile();
                  controller.initialvaleurs();
                  listItem.clear();
                  productcontroller.clearlist();
                  ProfilePage profile = ProfilePage(buttombar: true);
                  profile.profileController.getprofile();

                  Get.to(profile);

                  controller.changeposition(3);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget cardone({
    required String title,
    required String price,
    required String desc,
    required String imageurl,
    required String createdat,
    required String state,
  }) {
    return Container(
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow()],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.all(5),
        width: 400,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Column(children: [
                          TThemedata.profile(title, Colors.black),
                          const SizedBox(
                            height: 5,
                          )
                        ]),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.more_horiz,
                    size: 30,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(children: [
              Image.network(
                imageurl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // The image has finished loading
                    return child;
                  } else {
                    // The image is still loading
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
              ),
            ]),
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TThemedata.text(state, Colors.black),
                      TThemedata.desc(createdat, Colors.grey),
                      TThemedata.text('$price DA', Colors.black),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  TThemedata.desc(desc, Colors.black),
                ],
              ),
            )
          ],
        ));
  }

  Widget category(String category) {
    return InkWell(onTap: () {
      controller.changecat(category);
    }, child: Obx(() {
      return AnimatedContainer(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
            color: controller.category.value == category
                ? Colors.pink[400]
                : Colors.white,
            borderRadius: BorderRadius.circular(60)),
        margin: const EdgeInsets.only(left: 10, bottom: 10),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutExpo,
        child: Center(
            child: Text(category,
                softWrap: false,
                style: TextStyle(
                    color: controller.category.value == category
                        ? Colors.white
                        : Colors.grey,
                    fontSize: 20))),
      );
    }));
  }

  Widget TabItem(
      {required IconData icon,
      required bool isSelected,
      required text,
      required Null Function() onTap}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  void setupScrollListener(
      {required ScrollController scrollController,
      Function? onAtTop,
      Function? onAtBottom}) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        // Reach the top of the list
        if (scrollController.position.pixels == 0) {
          onAtTop?.call();
        }
        // Reach the bottom of the list
        else {
          onAtBottom?.call();
        }
      }
    });
  }
}
