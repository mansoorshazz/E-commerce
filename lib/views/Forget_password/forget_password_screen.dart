import 'package:e_commerce_app/views/Forget_password/widgets/textfiel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: mediaQuery.height * 0.09,
          ),
          Center(
            child: Text(
              'E - Commerce App',
              style: GoogleFonts.galdeano(
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
              'Enter Registered Email',
              style: GoogleFonts.gupter(fontSize: 25),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.09,
          ),
          buildTextfieldContainer(mediaQuery, context),
          Image.asset(
            'assets/images/download-removebg-preview.png',
          ),
        ],
      ),
    );
  }

// ============================================================================================
// This method is used to show the textfield and the button.

  Container buildTextfieldContainer(Size mediaQuery, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.05),
      height: mediaQuery.height * 0.23,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 2,
          color: Colors.black12,
        ),
      ),
      child: Column(
        children: [
          ForgetEmailField(
            controller: emailController,
            formkey: formkey,
          ),
          SizedBox(height: mediaQuery.height * 0.03),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  HexColor('#EF0030').withOpacity(0.8)),
            ),
            onPressed: () {
              if (formkey.currentState!.validate()) {
                resetPassword(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * 0.12,
                vertical: mediaQuery.height * 0.015,
              ),
              child: Text(
                'RESET PASSWORD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Password Reset Email Sent'),
          ),
        );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('${e.message}'),
          ),
        );
      Get.back();
    }
  }   
}
