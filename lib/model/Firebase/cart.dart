import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';

// class Cart {
//   final String imageUrl;
//   final String productName;
//   final String sizeOrVarient;
//   final int price;
//   final int quantity;
//   final int totalPrice;

//   Cart({
//     required this.imageUrl,
//     required this.productName,
//     required this.price,
//     required this.quantity,
//     required this.sizeOrVarient,
//     required this.totalPrice,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'imageUrl': imageUrl,
//       'productName': productName,
//       'price': price,
//       'quantity': quantity,
//       'sizeOrVarient': sizeOrVarient,
//       'totalPrice': price,
//     };
//   }

//   static addToCart(
//     Cart cart,
//     String productName,
//     BuildContext context,
//     String docId,
//   ) {
//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('Cart')
//         .doc(docId)
//         .set(cart.toMap());

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: Duration(seconds: 1),
//         content: Text(
//           '$productName added  to cart!',
//         ),
//       ),
//     );
//   }

//   static deleteFromCart(
//     String docId,
//     BuildContext context,
//     String productName,
//   ) {
//     showAnimatedDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return ClassicGeneralDialogWidget(
//           titleText: 'Delete!',
//           contentText: 'Are you sure to delete $productName from cart ?',
//           positiveText: 'YES',
//           negativeText: 'NO',
//           positiveTextStyle: const TextStyle(
//             color: Colors.green,
//           ),
//           negativeTextStyle: const TextStyle(
//             color: Colors.red,
//           ),
//           onPositiveClick: () {
//             Navigator.of(context).pop();

//             Future.delayed(
//               const Duration(seconds: 1),
//               () async {
//                 await FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection('Cart')
//                     .doc(docId)
//                     .delete();

//                 Get.showSnackbar(
//                   GetSnackBar(
//                     title: 'Message',
//                     message: '$productName deleted from cart!',
//                     duration: Duration(milliseconds: 1500),
//                   ),
//                 );
//               },
//             );
//           },
//           onNegativeClick: () {
//             Navigator.of(context).pop();
//           },
//         );
//       },
//       animationType: DialogTransitionType.slideFromLeftFade,
//       curve: Curves.fastOutSlowIn,
//       duration: Duration(seconds: 1),
//     );
//   }

//   static increaseQuantity(
//     String docId,
//     int changedQuantity,
//     int price,
//   ) {
//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('Cart')
//         .doc(docId)
//         .update(
//       {
//         'quantity': changedQuantity,
//         'totalPrice': changedQuantity * price,
//       },
//     );
//   }

//   static decreaseQuantity(
//     String docId,
//     int changedQuantity,
//     int price, {
//     required int totalPrice,
//   }) {
//     FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('Cart')
//         .doc(docId)
//         .update(
//       {
//         'quantity': changedQuantity,
//         'totalPrice': totalPrice - price,
//       },
//     );
//   }
// }

class Cart {
  final String productId;
  final int quantity;
  final int totalPrice;

  Cart({
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  static addToCart({
    required Cart cart,
    required String productName,
    required BuildContext context,
    required String docId,
  }) {
    FirebaseFirestore.instance.collection('Carts').add(
          cart.toMap(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          '$productName added  to cart!',
        ),
      ),
    );
  }

  static deleteFromCart({
    required String docId,
    required BuildContext context,
    required String productName,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Delete!',
          contentText: 'Are you sure to delete $productName from cart ?',
          positiveText: 'YES',
          negativeText: 'NO',
          positiveTextStyle: const TextStyle(
            color: Colors.green,
          ),
          negativeTextStyle: const TextStyle(
            color: Colors.red,
          ),
          onPositiveClick: () {
            Navigator.of(context).pop();

            Future.delayed(
              const Duration(seconds: 1),
              () async {
                await FirebaseFirestore.instance
                    .collection('Carts')
                    .doc(docId)
                    .delete();

                Get.showSnackbar(
                  GetSnackBar(
                    title: 'Message',
                    message: '$productName deleted from cart!',
                    duration: Duration(milliseconds: 1500),
                  ),
                );
              },
            );
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.slideFromLeftFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  static increaseQuantity(
    String docId,
    int changedQuantity,
    int price,
  ) {
    FirebaseFirestore.instance.collection('Carts').doc(docId).update(
      {
        'quantity': changedQuantity,
        'totalPrice': changedQuantity * price,
      },
    );
  }

  static decreaseQuantity(
    String docId,
    int changedQuantity,
    int price, {
    required int totalPrice,
  }) {
    int total = changedQuantity * price;

    print(total);

    FirebaseFirestore.instance.collection('Carts').doc(docId).update(
      {
        'quantity': changedQuantity,
        'totalPrice': totalPrice - price,
      },
    );
  }
}

class CartProductDetails {
  List<String> productName;
  List<String> sizeOrVarinet;
  List<String> imageUrl;

  CartProductDetails({
    required this.productName,
    required this.sizeOrVarinet,
    required this.imageUrl,
  });
}
