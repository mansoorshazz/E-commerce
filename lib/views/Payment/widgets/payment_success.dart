import 'package:confetti/confetti.dart';
import 'package:e_commerce_app/controller/payment_success_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentSuccessController());

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Lottie.asset(
              'assets/lottie/89618-gopay-succesfull-payment.json',
              animate: true,
              repeat: false,
            ),
          ),
          ConfettiWidget(
            confettiController: controller.confettiController,
            shouldLoop: true,
            blastDirectionality: BlastDirectionality.explosive,
            maxBlastForce: 100,
            minBlastForce: 20,
          )
        ],
      ),
    );
  }
}
