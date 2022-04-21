import 'package:e_commerce_app/controller/otp_controller.dart';
import 'package:e_commerce_app/model/Firebase/user.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:e_commerce_app/views/Login/login_screen.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/confirm_password_textfield.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/email_textfield.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/password_textfield.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/phone_textfield.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/textfiled_text.dart';
import 'package:e_commerce_app/views/Sign%20Up/widgets/username_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Otp/otp_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController usernameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // Get.put(OtpController());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.07),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: mediaQuery.height * 0.06,
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
                      const Center(
                        child: Text(
                          'Register your account',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.06,
                      ),
                      const SignUpBuildTextfieldText(text: 'Username'),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      UsernameTextfield(
                        controller: usernameController,
                        icon: Icons.person,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.025,
                      ),
                      const SignUpBuildTextfieldText(text: 'Phone'),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      PhoneNumberTextfield(
                        controller: phoneNumberController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.025,
                      ),
                      const SignUpBuildTextfieldText(text: 'Email'),
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
                      const SignUpBuildTextfieldText(text: 'Password'),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      BuildPasswordTextfield(
                        controller: passwordController,
                        icon: Icons.lock,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.025,
                      ),
                      const SignUpBuildTextfieldText(text: 'Confirm password'),
                      SizedBox(
                        height: mediaQuery.height * 0.007,
                      ),
                      ConfirmPasswordTextfield(
                        controller: confirmPasswordController,
                        checkingController: passwordController,
                        icon: Icons.lock_open_sharp,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: mediaQuery.height * 0.03,
                      ),
                      buildSignUpInButton(context),
                      SizedBox(
                        height: mediaQuery.height * 0.05,
                      ),
                      // buildAlreadyhaveanAccounttext()
                    ],
                  ),
                ),
                buildAlreadyhaveanAccounttext(),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// =============================================================
// This method is used to show the already have an account text.

  Center buildAlreadyhaveanAccounttext() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Already have an account?",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: ' Login',
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.underline,
                color: Colors.blue.shade600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.back();
                },
            )
          ],
        ),
      ),
    );
  }

// ================================================================================
  buildSignUpInButton(BuildContext context) {
    return GetBuilder<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  HexColor('#EF0030').withOpacity(0.8)),
            ),
            onPressed: () async {
              final controller = Get.find<OtpController>();

              try {
                if (formKey.currentState!.validate()) {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+91' + phoneNumberController.text,
                    timeout: Duration(seconds: 30),
                    verificationCompleted: (credential) {
                      print(
                          '11111111111111111111111111111111111111111111111111111111111');
                      print(credential);
                    },
                    verificationFailed: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${error.message}'),
                        ),
                      );
                    },
                    codeSent: (number, code) {
                      controller.startTimer();
                      Get.offAll(
                        OtpScreen(
                          mobileNumber: phoneNumberController.text,
                          verificationId: number,
                          smsCode: code,
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (time) {
                      print(
                          '5555555555555555555555555555555555555555555555555555555555555555555555');
                      print(time);
                    },
                  );

                  Users users = Users(
                    userName: usernameController.text,
                    phoneNumber: phoneNumberController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  Users.addUser(users);
                }
              } on FirebaseAuthException catch (e) {
                print(e.message);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.code,
                    ),
                  ),
                );
              } catch (e) {
                print('+==============================+++++++++++++++==');
                print(e);
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                'SIGN UP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
        });
  }
}
