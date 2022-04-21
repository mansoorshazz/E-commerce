import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class Favorites {
  final String productName;
  final String price;
  final String imageUrl;

  Favorites({
    required this.productName,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  static addToFavorite(
    Favorites favorites,
    BuildContext context,
    String productName,
    String productId,
  ) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Favorites')
        .doc(productId)
        .set(favorites.toMap());

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
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Favorites')
        .doc(docId)
        .delete();

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
