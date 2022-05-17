import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/model/Firebase/cart.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Payment/widgets/payment_success.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/Firebase/orders.dart';

class RazorPayController extends GetxController {
  late Razorpay razorpay;
  List<QueryDocumentSnapshot<Object?>>? docs;
  late Map shippingAddress;
  late int totalPrice;
  late String productId;
  late int quantity;
  late CartProductDetails cartProductDetails;
  late String token;

  Future<String> getToken() async {
    final userToken = await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
      return value;
    });
    print(userToken);
    update();

    return userToken;
  }

  handlePaymentSuccess(PaymentSuccessResponse response) {
    if (docs != null) {
      for (var i = 0; i < docs!.length; i++) {
        OrdersSample ordersSample = OrdersSample(
          productName: cartProductDetails.productName[i],
          imageUrl: cartProductDetails.imageUrl[i],
          sizeOrVarient: cartProductDetails.sizeOrVarinet[i],
          productId: docs![i]['productId'],
          quantity: docs![i]['quantity'],
          shippingAddress: shippingAddress,
          paymentMethod: 'Online Payment',
          totalPrice: docs![i]['totalPrice'],
          ordered: true,
          shipped: false,
          delivered: false,
          orderedDate: DateTime.now().millisecondsSinceEpoch,
          createdDate: DateTime.now().millisecondsSinceEpoch,
          shippedDate: 0,
          deliveredDate: 0,
          token: token,
        );

        OrdersSample.placeOrder(
          ordersSample,
          docId: docs![i].id,
          productId: docs![i]['productId'],
          quantity: docs![i]['quantity'],
        );
      }
    } else {
      OrdersSample ordersSample = OrdersSample(
        productName: cartProductDetails.productName[0],
        sizeOrVarient: cartProductDetails.sizeOrVarinet[0],
        imageUrl: cartProductDetails.imageUrl[0],
        productId: productId,
        quantity: quantity,
        shippingAddress: shippingAddress,
        paymentMethod: 'Online Payment',
        totalPrice: totalPrice,
        ordered: true,
        shipped: false,
        delivered: false,
        orderedDate: DateTime.now().millisecondsSinceEpoch,
        createdDate: DateTime.now().millisecondsSinceEpoch,
        shippedDate: 0,
        deliveredDate: 0,
        token: token,
      );

      OrdersSample.placeOrder(
        ordersSample,
        productId: productId,
        quantity: quantity,
      );
    }

    Get.offAll(const PaymentSuccess());
  }

  handlePaymentError(PaymentFailureResponse response) {
    print(response.message);

    // Get.back();
  }

  handleExternalWallet() {}

  void openCheckOut({
    List<QueryDocumentSnapshot<Object?>>? documents,
    required Map shippingaddress,
    required CartProductDetails cartProductDetails,
    int? totalPrice,
    String? productId,
    int? quantity,
  }) {
    shippingAddress = shippingaddress;
    this.cartProductDetails = cartProductDetails;
    if (documents != null) {
      docs = documents;

      var sum = 0;
      for (int i = 0; i < documents.length; i++) {
        sum = documents[i]['totalPrice'] + sum;
      }

      var payablePrice = sum + 150;

      var options = {
        "key": "rzp_test_qdGgEpmbyO0yG0",
        "amount": payablePrice * 100,
        "description": "payment for the some random product",
        "prefill": {"contact": "7558967627", "email": "mansoor@gmail.com"},
        "external": {
          "wallets": ["paytm"],
        }
      };

      razorpay.open(options);
    } else if (totalPrice != null) {
      var payablePrice = totalPrice + 150;
      this.totalPrice = totalPrice;
      this.productId = productId!;
      this.quantity = quantity!;

      var options = {
        "key": "rzp_test_qdGgEpmbyO0yG0",
        "amount": payablePrice * 100,
        "description": "payment for the some random product",
        "prefill": {"contact": "7558967627", "email": "mansoor@gmail.com"},
        "external": {
          "wallets": ["paytm"],
        }
      };

      razorpay.open(options);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    // razorpay.on(Razorpay.PAYMENT_CANCELLED, handler)
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }
}
