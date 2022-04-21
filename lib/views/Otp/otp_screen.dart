import 'dart:async';

import 'package:e_commerce_app/controller/otp_controller.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'widgets/build_text.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({
    Key? key,
    required this.mobileNumber,
    required this.verificationId,
    required this.smsCode,
  }) : super(key: key);

  final String mobileNumber;
  final String verificationId;
  final int? smsCode;

  final TextEditingController otpController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Get.put(OtpController());
    final mediaQuery = MediaQuery.of(context).size;
    // controller.startTimer();

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: mediaQuery.height * 0.07,
            ),
            BuildText(
              text: 'Verification Code',
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: mediaQuery.height * 0.05,
            ),
            BuildText(
              text: 'OTP has been sent your mobile\n number +91 $mobileNumber.',
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            SizedBox(
              height: mediaQuery.height * 0.11,
            ),
            buildOtpTextfield(context),
            SizedBox(
              height: mediaQuery.height * 0.02,
            ),
            GetBuilder<OtpController>(
              init: OtpController(),
              builder: (otpcontrol) {
                return otpcontrol.count == 0
                    ? Center(
                        child: TextButton(
                            onPressed: () => otpcontrol.reset(
                                  context: context,
                                  verficationId: verificationId,
                                  mobilenumber: mobileNumber,
                                  resend: smsCode!,
                                ),
                            child: const Text('Resend OTP')),
                      )
                    : Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Resend OTP in",
                            style: const TextStyle(
                              // fontSize: 15,
                              // fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: ' ${otpcontrol.count}s',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // textBaseline: TextBaseline.ideographic
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              },
            ),
            SizedBox(
              height: mediaQuery.height * 0.05,
            ),
            Image.asset('assets/images/Email-removebg-preview.png'),
          ],
        ),
      ),
    );
  }

//=======================================================================================
//This method is used to show the otp textfield.

  buildOtpTextfield(BuildContext context) {
    return GetBuilder<OtpController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: PinCodeTextField(
          controller: otpController,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          cursorColor: themeColor,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor: themeColor,
            inactiveColor: Colors.black26,
            selectedColor: Colors.black,
          ),
          enableActiveFill: false,
          onCompleted: (pin) async {
            try {
              PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: pin,
              );
              // await auth.signInWithCredential(credential).then((value) {
              Get.offAll(
                const BottomNavBar(),
                transition: Transition.leftToRight,
              );
              // });
            } on FirebaseAuthException catch (e) {
              controller.canelTime();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.code.toString(),
                  ),
                  duration: const Duration(
                    seconds: 5,
                  ),
                ),
              );
              otpController.clear();
            }
          },
          onChanged: (value) {},
          beforeTextPaste: (text) {
            print("Allowing to paste $text");

            return true;
          },
          appContext: context,
        ),
      );
    });
  }
}

// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   int secondsRemaining = 30;
//   bool enableResend = false;
//   Timer? timer;

//   @override
//   initState() {
//     super.initState();
//     timer = Timer.periodic(Duration(seconds: 1), (_) {
//       if (secondsRemaining != 0) {
//         setState(() {
//           secondsRemaining--;
//         });
//       } else {
//         setState(() {
//           enableResend = true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           TextField(),
//           const SizedBox(height: 10),
//           FlatButton(
//             child: Text('Submit'),
//             color: Colors.blue,
//             onPressed: () {
//               //submission code here
//             },
//           ),
//           const SizedBox(height: 30),
//           FlatButton(
//             child: Text('Resend Code'),
//             onPressed: enableResend ? _resendCode : null,
//           ),
//           Text(
//             'after $secondsRemaining seconds',
//             style: TextStyle(color: Colors.black, fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   dispose() {
//     timer!.cancel();
//     super.dispose();
//   }
// }
