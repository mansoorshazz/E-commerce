import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final String userName;
  final String phoneNumber;
  final String email;
  final String password;

  Users({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'imageUrl':
          'https://john-mohamed.com/wp-content/uploads/2018/05/Profile_avatar_placeholder_large.png',
    };
  }

  static addUser(Users user) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .set(user.toMap());
  }
}
