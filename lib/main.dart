import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:e_commerce_app/views/Login/login_screen.dart';
import 'package:e_commerce_app/views/Otp/otp_screen.dart';
import 'package:e_commerce_app/views/Splash%20screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.black,
            ),
      ),
      home: const SplashScreen(),
    );
  }
}
