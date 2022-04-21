import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Address {
  final String userName;
  final String city;
  final String state;
  final String pincode;
  final String phoneNumber;

  Address({
    required this.userName,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phoneNumber': phoneNumber,
    };
  }

// ===============================================================
// This method is used to add a address to firebase.

  static addAddress(Address adress, BuildContext context) {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Addresses')
          .add(adress.toMap());
      FocusScope.of(context).unfocus();
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfullty address added!'),
        ),
      );
    } catch (e) {
      print('address didnt store in database');
      print(e);
    }
  }

  // ==================================================================
  // This method is used to delete the address.

  static deletedAdrress(
    String documentId,
    BuildContext context,
  ) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Addresses')
        .doc(documentId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address successfully deleted!'),
      ),
    );
  }

  // ===========================================================================
  //This method is used to update one value of the specify field.

  static updateAdress({
    required String field,
    required String updateValue,
    required String docId,
  }) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Addresses')
        .doc(docId)
        .update({
      field: updateValue,
    });
  }
}
