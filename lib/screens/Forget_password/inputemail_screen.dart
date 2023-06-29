import 'package:e_commerce/screens/OTP_SCREEN/otp_screen.dart';
import 'package:e_commerce/screens/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../controller/auth_controller.dart';
import '../../utils/constants.dart';
import '../login_screen/components/center_widget/center_widget.dart';
import '../login_screen/components/login_content.dart';

class InputEmail extends StatelessWidget {
  InputEmail();
  TextEditingController controller = TextEditingController();
  AuthController authcontroller = AuthController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.white,
            ),
            otocontent(context),
            Positioned(
              top: 15,
              left: 20,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                splashColor: Colors.white,
                child: const Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(
      String hint, IconData iconData, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.center,
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

  Widget otocontent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenSize.height / 10),
          Container(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage('assets/images/otp.jpg'),
              )),
          SizedBox(height: screenSize.height / 100),
          Text(
            "Let's get your account back",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Enter Your Email To find Your Account',
            style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 15, shadows: []),
          ),
          SizedBox(height: screenSize.height / 20),
          inputField('', Icons.email, controller),
          SizedBox(height: screenSize.height / 5),
          loginButton('Confirm', context),
        ],
      ),
    );
  }

  Widget loginButton(String title, BuildContext context) {
    return InkWell(
      onTap: () async {
        print('This is controller token');
        await authcontroller.checkemailint(controller.text, context);
        print(authcontroller.accesstoken.value);
        Get.to(OTPSCREEN('${authcontroller.accesstoken.value}', true));
      },
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
    );
  }
}
