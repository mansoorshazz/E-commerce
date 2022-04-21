import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/google_controller.dart';
import 'package:e_commerce_app/controller/home_controller.dart';
import 'package:e_commerce_app/controller/login_controller.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Forget_password/forget_password_screen.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:e_commerce_app/views/Login/widgets/password_textfield.dart';
import 'package:e_commerce_app/views/Sign%20Up/sign_up_screen.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/email_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';

import 'widgets/build_textfield_text.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.put(GoogleSignInController());

    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.07),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: mediaQuery.height * 0.09,
                      ),
                      Center(
                        child: Text(
                          'E - Commerce App',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: HexColor('#EF0030'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.015,
                      ),
                      Center(
                        child: Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.09,
                      ),
                      const BuildTextfieldText(
                        text: 'Email Address',
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      EmailTextfield(
                        controller: emailController,
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.025,
                      ),
                      const BuildTextfieldText(
                        text: 'Password',
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      PasswordTextfield(
                        controller: passwordController,
                        icon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.020,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                ForgetPasswordScreen(),
                                transition: Transition.native,
                              );
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.06,
                      ),
                      buildSignInButton(context),
                      SizedBox(
                        height: mediaQuery.height * 0.04,
                      ),
                      buildDividerORText(),
                      SizedBox(
                        height: mediaQuery.height * 0.04,
                      ),
                      buildGoogleButton(mediaQuery),
                      // SizedBox(
                      //   height: mediaQuery.height * 0.10,
                      // ),
                      // Spacer(),
                      // buildDonthaveanAccounttext(),
                    ],
                  ),
                ),
                // Spacer(),
                buildDonthaveanAccounttext(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// ======================================================================================
// This method is used to show the already have an account text.

  Center buildDonthaveanAccounttext() {
    return Center(
      child: Text.rich(
        TextSpan(
            text: "Don't have an account?",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: ' Signup',
                style: const TextStyle(
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  // textBaseline: TextBaseline.ideographic
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(SignUpScreen(), transition: Transition.leftToRight);
                  },
              )
            ]),
      ),
    );
  }

// ================================================================================
// This method is used to show the sign in button.

  ElevatedButton buildSignInButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(HexColor('#EF0030').withOpacity(0.8)),
      ),
      onPressed: () async {
        try {
          if (formkey.currentState!.validate()) {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                )
                .then(
                  (value) => Get.off(
                    BottomNavBar(),
                    transition: Transition.leftToRight,
                  ),
                );
          }
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.code,
              ),
            ),
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Text(
          'SIGN IN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  //=================================================================================================
  // This widget is used to show the customize google button.

  buildGoogleButton(Size mediaQuery) {
    final controller = Get.find<GoogleSignInController>();

    return GestureDetector(
      onTap: () async {
        controller.googleLogin();
      },
      child: Container(
          width: double.infinity,
          height: mediaQuery.height * 0.063,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
            border: Border.all(
              width: 2,
              color: HexColor('#EF0030'),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: mediaQuery.width * 0.10,
              ),
              Image.asset(
                'assets/images/985_google_g_icon.jpg',
                height: 45,
                width: 45,
              ),
              SizedBox(
                width: mediaQuery.width * 0.03,
              ),
              const Text(
                'GOOGLE VERIFICATION',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )),
    );
  }

  // ==================================================================================
  // This method is used to show the divider and text.

  Row buildDividerORText() {
    return Row(children: const [
      Expanded(
          child: Divider(
        thickness: 1.5,
      )),
      SizedBox(
        width: 10,
      ),
      Text(
        "OR",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
          child: Divider(
        thickness: 1.5,
      )),
    ]);
  }
}
