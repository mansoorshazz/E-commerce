import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/home_controller.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _a = false;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 700), () {
      setState(() {
        _a = !_a;
      });
    });
    Timer(Duration(milliseconds: 2000), () {
      final user = FirebaseAuth.instance.currentUser;

      user == null
          ? Navigator.of(context).pushReplacement(
              SlideTransitionAnimation(
                LoginScreen(),
              ),
            )
          : Navigator.of(context).pushReplacement(
              SlideTransitionAnimation(
                BottomNavBar(),
              ),
            );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _a ? _width : 0,
            height: _height,
            color: Colors.black,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Shoppy',
                  style: GoogleFonts.mukta(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                Icon(
                  CupertinoIcons.cart,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SlideTransitionAnimation extends PageRouteBuilder {
  final Widget page;

  SlideTransitionAnimation(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: Duration(seconds: 4),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
              );
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                textDirection: TextDirection.rtl,
                child: page,
              );
            });
}
