import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class OtpController extends GetxController {
  var count = 60;
  late Timer timer;
  String verficationId = '';

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count > 0) {
        count--;
        update();
      } else {
        timer.cancel();
        update();
      }
    });
    update();
  }

  canelTime() {
    timer.cancel();
    update();
  }

  reset({
    required String verficationId,
    required String mobilenumber,
    required BuildContext context,
    required int resend,
  }) async {
    try {
      final auth = FirebaseAuth.instance;
      timer.cancel();
      count = 60;

      startTimer();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + mobilenumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (credential) {
          print('11111111111111111111111111111111111111111111111111111111111');
          print(credential);
        },
        verificationFailed: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message.toString()),
              duration: Duration(seconds: 5),
            ),
          );
        },
        codeSent: (number, code) {
          verficationId = number;
          update();
        },
        codeAutoRetrievalTimeout: (time) {},
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error message'),
        ),
      );
    }
    update();
  }

  // int secondsRemaining = 30;
  // bool enableResend = false;
  // Timer? timer;

  // timerControlling() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     if (secondsRemaining != 0) {
  //       secondsRemaining--;
  //     } else {
  //       enableResend = true;
  //     }
  //     update();
  //   });
  // }

  // void resendCode() {
  //   //other code here
  //   secondsRemaining = 30;
  //   enableResend = false;
  //   update();
  // }

  // timerCancel() {
  //   timer!.cancel();
  // }

  @override
  void onInit() {
    startTimer();
    // TODO: implement onInit
    super.onInit();
  }
}
