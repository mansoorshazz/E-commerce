import 'package:confetti/confetti.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PaymentSuccessController extends GetxController {
  ConfettiController confettiController = ConfettiController();

  gotoHOme() async {
    await Future.delayed(
        Duration(
          seconds: 5,
        ), () {
      Get.offAll(
        BottomNavBar(),
        transition: Transition.leftToRight,
        duration: const Duration(seconds: 2),
      );
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    confettiController.play();
    gotoHOme();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    confettiController.dispose();
  }
}
