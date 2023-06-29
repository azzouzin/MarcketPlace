import 'package:e_commerce/Module/Profile.dart';
import 'package:e_commerce/controller/auth_controller.dart';
import 'package:e_commerce/controller/profile_controller.dart';
import 'package:e_commerce/screens/home_screen/home_screen.dart';
import 'package:e_commerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key, required this.buttombar});

  final bool buttombar;
  var controller = HomeScreenState().controller;
  TextEditingController nameinputcontroller = TextEditingController();
  TextEditingController prenomeinputcontroller = TextEditingController();
  TextEditingController passwordinputcontroller = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpel,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecondaryColor,
        splashColor: Colors.white,
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          buttombar == true ? HomeScreenState().buildBottomTab(context) : null,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70, left: 2),
              child: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 4,
                        height: MediaQuery.of(context).size.height / 2.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: purpel_fata7),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child: InkWell(
                                      onTap: () async {
                                        await ProfileController()
                                            .update_photo_profile(Profile());
                                      },
                                      child: IImage()),
                                ),
                              ),
                            ),
                            Text(
                              profileController.profile_name.value +
                                  profileController.profile_prenom.value,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Welcome To SouqPlace ',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              ' Email : ${profileController.email.value} ',
                              style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              ' Gender : ${profileController.gender.value} ',
                              style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: purpel,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                'To Contact Us : SouqePlace@gmail.com ',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      settingsitem(
                          context, Icons.access_alarm, 'Change Password'),
                      InkWell(
                        onTap: () {
                          profileController.height.value == 0
                              ? profileController.shawEditingFieldname(context)
                              : profileController.hideEditinFieldname();
                        },
                        child: settingsitem(
                            context, Icons.access_alarm, 'Change Your Name'),
                      ),
                      InkWell(
                          onTap: () async {
                            await AuthController().logout();
                          },
                          child: settingsitem(
                              context, Icons.access_alarm, 'Logout')),
                      editingFieldsname(context),
                    ],
                  );
                }),
              ),
            ),
            Positioned(
              top: 15,
              right: MediaQuery.of(context).size.width / 2.5,
              child: Text(
                'Profile',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 22),
              ),
            ),
            Positioned(
                top: 15,
                right: 5,
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                )),
          ],
        ),
      ),
    );
  }

  Widget settingsitem(
    BuildContext context,
    IconData icon,
    String data,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: purpel_fata7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              Text(
                data,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget editingFieldspassword(context) {
    return Obx(() {
      return AnimatedContainer(
        margin: EdgeInsets.only(top: 50),
        width: profileController.widthpassword.value,
        height: profileController.heightpassword.value,
        decoration: BoxDecoration(
            color: purpel_fata7, borderRadius: BorderRadius.circular(30)),
        duration: Duration(seconds: 1),
        child: Column(
          children: [
            Text(
              'Edit Your Inforamtion',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            inputField('Name', Icons.input, passwordinputcontroller, context),
            InkWell(
              onTap: () async {
                profileController.hideEditinFieldpassword();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: purpel, borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                      child: Text(
                        'Confirm',
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget IImage() {
    if (profileController.profile_image.value ==
        'http://islamdjemmal7.pythonanywhere.com/') {
      return Image.asset(
        'assets/images/1.jpg',
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(profileController.profile_image.value,
          fit: BoxFit.cover);
    }
  }

  Widget editingFieldsname(context) {
    return Obx(() {
      print('Obx Value ${profileController.width.value}');
      print('Obx Value ${profileController.height.value}');
      print(profileController.width.value);
      return AnimatedContainer(
        margin: EdgeInsets.only(top: 30, bottom: 30),
        width: profileController.width.value,
        height: profileController.height.value,
        decoration: BoxDecoration(
            color: purpel_fata7, borderRadius: BorderRadius.circular(30)),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutExpo,
        child: Column(
          children: [
            Text(
              'Edit Your Inforamtion',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            inputField('Name', Icons.input, nameinputcontroller, context),
            inputField('prenom', Icons.input, prenomeinputcontroller, context),
            dropdawnbutton(),
            InkWell(
              onTap: () async {
                profileController.hideEditinFieldname();
                print(nameinputcontroller.text);
                print(prenomeinputcontroller.text);
                profileController.update_profile(Profile(
                  name: nameinputcontroller.text,
                  prenome: prenomeinputcontroller.text,
                ));
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: purpel, borderRadius: BorderRadius.circular(30)),
                    child: const Center(
                      child: Text(
                        'Confirm',
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget dropdawnbutton() {
    List list = ['male', 'female'];
    return Obx(() {
      return DropdownButton<String>(
        value: profileController.cgender.value,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.

          profileController.changegender(value!);
        },
        items: list.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget inputField(String hint, IconData iconData,
      TextEditingController controller, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            obscureText: hint == "Password" ? true : false,
            style: TextStyle(
              fontSize: hint == "Password" ? 20 : 15,
            ),
            enableSuggestions: hint == "Password" ? false : true,
            autocorrect: hint == "Password" ? false : true,
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }
}
