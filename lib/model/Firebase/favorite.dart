import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class Favorites {
  final String productId;

  Favorites({
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'productId': productId,
    };
  }

  static addToFavorite(
    Favorites favorites,
    BuildContext context,
    String productName,
  ) {
    FirebaseFirestore.instance.collection('Wishlist').add(favorites.toMap());

    Get.showSnackbar(
      GetSnackBar(
        duration: Duration(
          milliseconds: 1800,
        ),
        message: '$productName added to wishlist.',
      ),
    );
  }

  static deleteToFavorite(
      BuildContext context, String productName, String docId) async {
    await FirebaseFirestore.instance.collection('Wishlist').doc(docId).delete();

    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(
          milliseconds: 1800,
        ),
        message: '$productName deleted from wishlist.',
      ),
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('$productName deleted from favorites'),
    //   ),
    // );
  }
}
