import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orders {
  final String productName;
  final String sizeOrVarient;
  final int quantity;
  final int price;
  final String photoUrl;
  final Map orderDetails;
  final Map shippedDetails;
  final Map deliverdDetails;
  final Map shippingAddress;
  final String paymentMethod;
  final int totalPrice;

  Orders({
    required this.productName,
    required this.sizeOrVarient,
    required this.quantity,
    required this.price,
    required this.photoUrl,
    required this.orderDetails,
    required this.shippingAddress,
    required this.deliverdDetails,
    required this.shippedDetails,
    required this.paymentMethod,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() => {
        'productName': productName,
        'sizeOrVarient': sizeOrVarient,
        'quantity': quantity,
        'price': price,
        'photoUrl': photoUrl,
        'orderDetails': orderDetails,
        'shippingDetails': shippedDetails,
        'deliveredDetails': deliverdDetails,
        'shippingAddress': shippingAddress,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
      };

//==================================================================================
//When the order is placed this method will be called.

  static placeOrder(
    Orders orders, {
    required String docId,
    required int quantity,
  }) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Orders')
        .add(orders.toMap());

    FirebaseFirestore.instance
        // .collection('Users')
        // .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Carts')
        .doc(docId)
        .delete();

    updateQuantity(docId, quantity);
  }

// ======================================================================================
// This method is used to update the real count of products when the order confirmed.

  static updateQuantity(
    String intId,
    int quantity,
  ) async {
    final document = await FirebaseFirestore.instance
        .collection('Products')
        .doc(intId)
        .get();

    Map<String, dynamic>? datas = document.data();

    int prdoductQuantity = datas!['count'];

    print(prdoductQuantity);
    print(quantity);

    FirebaseFirestore.instance.collection('Products').doc(intId).update(
      {
        'count': prdoductQuantity - quantity,
      },
    );
  }
}

class OrdersSample {
  final int quantity;
  final Map orderDetails;
  final Map shippedDetails;
  final Map deliverdDetails;
  final Map shippingAddress;
  final String paymentMethod;
  final int totalPrice;
  final String productId;
  final String productName;
  final String sizeOrVarient;
  final String imageUrl;

  OrdersSample({
    required this.quantity,
    required this.orderDetails,
    required this.shippingAddress,
    required this.deliverdDetails,
    required this.shippedDetails,
    required this.paymentMethod,
    required this.totalPrice,
    required this.productId,
    required this.imageUrl,
    required this.productName,
    required this.sizeOrVarient,
  });

  Map<String, dynamic> toMap() => {
        'quantity': quantity,
        'orderDetails': orderDetails,
        'shippingDetails': shippedDetails,
        'deliveredDetails': deliverdDetails,
        'shippingAddress': shippingAddress,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'productId': productId,
        'productName': productName,
        'sizeOrVarient': sizeOrVarient,
        'imageUrl': imageUrl,
      };

//==================================================================================
//When the order is placed this method will be called.

  static placeOrder(
    OrdersSample orders, {
    String? docId,
    required String productId,
    required int quantity,
  }) async {
    await FirebaseFirestore.instance.collection('Orders').add(
          orders.toMap(),
        );

    if (docId != null) {
      FirebaseFirestore.instance.collection('Carts').doc(docId).delete();
    }

    updateQuantity(productId, quantity);
  }

// ======================================================================================
// This method is used to update the real count of products when the order confirmed.

  static updateQuantity(
    String docId,
    int quantity,
  ) async {
    final document = await FirebaseFirestore.instance
        .collection('Products')
        .doc(docId)
        .get();

    Map<String, dynamic>? datas = document.data();

    int prdoductQuantity = datas!['count'];

    print(prdoductQuantity);
    print(quantity);

    FirebaseFirestore.instance.collection('Products').doc(docId).update(
      {
        'count': prdoductQuantity - quantity,
      },
    );
  }
}
