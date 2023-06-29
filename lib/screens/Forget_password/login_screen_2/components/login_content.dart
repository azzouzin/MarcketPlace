import 'package:e_commerce/controller/auth_controller.dart';
import 'package:e_commerce/controller/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../inputemail_screen.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  TextEditingController firstnameC = TextEditingController();
  TextEditingController lastnameC = TextEditingController();

  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();
  AuthController authcontroller = Get.put(AuthController());

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

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (title == 'Sign Up') {
            if (emailC.text.contains('@') || emailC.text.contains('.com')) {
              if (passwordC.text.contains(new RegExp(r'[0-9]')) ||
                  passwordC.text.contains(new RegExp(r'[A-Z]'))) {
                if (passwordC.text.length > 8) {
                  authcontroller.register(emailC.text, passwordC.text,
                      firstnameC.text, lastnameC.text, context);
                } else {
                  QuickAlert.show(
                    context: context,
                    text: 'Password is Too Short',
                    type: QuickAlertType.error,
                  );
                }
              } else {
                QuickAlert.show(
                  context: context,
                  text: 'Password Must Contain Numbers And Letters',
                  type: QuickAlertType.error,
                );
              }
            } else {
              QuickAlert.show(
                context: context,
                text: 'Invalid Email',
                type: QuickAlertType.error,
              );
            }
          } else {
            authcontroller.login(emailC.text, passwordC.text, context);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Get.to(Exempleimage());
              },
              child: Image.asset('assets/images/google.png')),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {
          print('forget tapped');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => InputEmail()),
              (Route route) => false);
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('First Name', Ionicons.person_outline, firstnameC),
      inputField('Last Name', Ionicons.person_outline, lastnameC),
      inputField('Email', Ionicons.mail_outline, emailC),
      inputField('Password', Ionicons.lock_closed_outline, passwordC),
      loginButton('Sign Up'),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, emailC),
      inputField('Password', Ionicons.lock_closed_outline, passwordC),
      loginButton('Log In'),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 10,
                right: MediaQuery.of(context).size.width / 3),
            child: TopText(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: createAccountContent,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: loginContent,
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: BottomText(),
            ),
          ),
        ],
      ),
    );
  }
}
