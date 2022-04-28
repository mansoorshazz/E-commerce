import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/radio_button.dart';
import 'package:e_commerce_app/controller/razorpay_controller.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/cart.dart';
import 'package:e_commerce_app/model/Firebase/orders.dart';
import 'package:e_commerce_app/views/Payment/widgets/payment_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Bottom nav/bottom_nav.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen(
      {required this.shippingAdress,
      this.productId,
      this.price,
      this.quantity,
     required this.cartProductDetails,
      Key? key})
      : super(key: key);

  final Map shippingAdress;
  String? productId;
  int? price;
  int? quantity;
  CartProductDetails cartProductDetails;

  @override
  Widget build(BuildContext context) {
    final razorpayController = Get.put(RazorPayController());

    final mediaQuery = MediaQuery.of(context).size;

    final controller = Get.put(RadioButtonController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            )),
        title: Text(
          'Payment',
          style: TextStyle(
            color: themeColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.height * 0.03,
                horizontal: mediaQuery.height * 0.02,
              ),
              child: GetBuilder<RadioButtonController>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Methods',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    RadioListTile<int>(
                      value: 0,
                      activeColor: themeColor,
                      groupValue: controller.selectedPayment,
                      onChanged: (int? value) {
                        controller.changePaymentMehod(value!);
                      },
                      title: const Text(
                        'Cash On Delivery',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    RadioListTile(
                      value: 1,
                      activeColor: themeColor,
                      groupValue: controller.selectedPayment,
                      onChanged: (int? value) {
                        controller.changePaymentMehod(value!);
                      },
                      title: const Text(
                        'Online Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
            const Divider(
              thickness: 3,
              height: 1,
            ),
            buildPriceDescription(context),
            const Divider(
              thickness: 3,
              height: 1,
            ),
            Image.asset(
              'assets/images/istockphoto-1066818018-612x612.jpg',
            ),
            buildCheckOutButton(context, controller, razorpayController),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

// =========================================================================================
// This method is used to show the sign in button.

  buildCheckOutButton(
    BuildContext context,
    RadioButtonController controller,
    RazorPayController razorPayController,
  ) {
    final mediaQuery = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Carts')
            .where(
              'userId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(themeColor),
            ),
            onPressed: () {
              if (productId == null && price == null && quantity == null) {
                if (controller.selectedPayment == 0) {
                  Get.off(
                    const PaymentSuccess(),
                    transition: Transition.fade,
                  );

                  for (var i = 0; i < docs.length; i++) {
                    OrdersSample ordersSample = OrdersSample(
                      productName: cartProductDetails.productName[i],
                      imageUrl: cartProductDetails.imageUrl[i],
                      sizeOrVarient: cartProductDetails.sizeOrVarinet[i],
                      productId: docs[i]['productId'],
                      quantity: docs[i]['quantity'],
                      orderDetails: {
                        'ordered': true,
                        'date': DateTime.now().millisecondsSinceEpoch
                      },
                      shippingAddress: shippingAdress,
                      deliverdDetails: {
                        'delivered': false,
                        'date': '',
                      },
                      shippedDetails: {
                        'shipped': false,
                        'date': '',
                      },
                      paymentMethod: 'Cash On Delivery',
                      totalPrice: docs[i]['totalPrice'],
                    );
                    OrdersSample.placeOrder(
                      ordersSample,
                      productId: docs[i]['productId'],
                      docId: docs[i].id,
                      quantity: docs[i]['quantity'],
                    );
                  }
                } else {
                  razorPayController.openCheckOut(
                    cartProductDetails: cartProductDetails,
                    documents: snapshot.data!.docs,
                    shippingaddress: shippingAdress,
                  );
                }
              } else {
                if (controller.selectedPayment == 0) {
                  int totalPrice = price! * quantity!;

                  Get.off(
                    PaymentSuccess(),
                    transition: Transition.fade,
                  );

                  OrdersSample ordersSample = OrdersSample(
                    productName: cartProductDetails.productName[0],
                    imageUrl: cartProductDetails.imageUrl[0],
                    sizeOrVarient: cartProductDetails.sizeOrVarinet[0],
                    productId: productId!,
                    quantity: quantity!,
                    orderDetails: {
                      'ordered': true,
                      'date': DateTime.now().millisecondsSinceEpoch
                    },
                    shippingAddress: shippingAdress,
                    deliverdDetails: {'delivered': false, 'date': ''},
                    shippedDetails: {'shipped': false, 'date': ''},
                    paymentMethod: 'Cash On Delivery',
                    totalPrice: totalPrice,
                  );
                  OrdersSample.placeOrder(
                    ordersSample,
                    productId: productId!,
                    quantity: quantity!,
                  );
                } else {
                  razorPayController.openCheckOut(
                    cartProductDetails: cartProductDetails,
                    shippingaddress: shippingAdress,
                    totalPrice: price,
                    productId: productId,
                    quantity: quantity,
                  );
                }
              }
              // }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.height * 0.017,
                horizontal: mediaQuery.height * 0.12,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
        });
  }

// ========================================================================================================
// This method is used to show the build price description.

  buildPriceDescription(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (productId != null && quantity != null && price != null) {
      var formatter = NumberFormat('#,##,000');

      String convertPrice = formatter.format(price);

      return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Details',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Product Price',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  '₹$convertPrice',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  'Delivery charge',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  'FREE',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
              height: 35,
            ),
            Row(
              children: [
                const Text(
                  'Amount Payable',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '₹$convertPrice',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Carts')
            .where(
              'userId',
              isEqualTo: userId,
            )
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final doc = snapshot.data!.docs;

          var sum = 0;
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            sum = doc[i]['totalPrice'] + sum;
          }

          var formatter = NumberFormat('#,##,000');

          String convertPriceTotalSum = formatter.format(sum);

          String convertdeliveryPrice = formatter.format(sum + 150);

          return Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Details',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Price( ${doc.length} items)',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '₹$convertPriceTotalSum',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Delivery charge',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '150',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  height: 35,
                ),
                Row(
                  children: [
                    const Text(
                      'Amount Payable',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      '₹$convertdeliveryPrice',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
