import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/Firebase/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/Bottom nav/bottom_nav.dart';

class GoogleSignInController extends GetxController {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    } else {
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credintial = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credintial);

      final userId = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'userName': googleUser.displayName.toString(),
        'email': googleUser.email.toString(),
      });

      Get.offAll(BottomNavBar());
    }
  }
}
