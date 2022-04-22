import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/radio_button.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/orders.dart';
import 'package:e_commerce_app/views/Payment/widgets/payment_success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Bottom nav/bottom_nav.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({required this.shippingAdress, Key? key})
      : super(key: key);

  final Map shippingAdress;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final controller = Get.put(RadioButtonController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
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
            buildCheckOutButton(context, controller),
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

  buildCheckOutButton(BuildContext context, RadioButtonController controller) {
    final mediaQuery = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Cart')
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
              if (controller.selectedPayment == 0) {
                Get.off(
                  PaymentSuccess(),
                  transition: Transition.fade,
                );

                for (var i = 0; i < docs.length; i++) {
                  Orders orders = Orders(
                    productName: docs[i]['productName'],
                    sizeOrVarient: docs[i]['sizeOrVarient'],
                    quantity: docs[i]['quantity'],
                    price: docs[i]['price'],
                    photoUrl: docs[i]['imageUrl'],
                    orderDetails: {
                      'ordered': true,
                      'date': DateFormat.yMMMd().format(
                        DateTime.now(),
                      ),
                    },
                    shippingAddress: shippingAdress,
                    deliverdDetails: {'delivered': false, 'date': ''},
                    shippedDetails: {'shipped': false, 'date': ''},
                    paymentMethod: 'Cash On Delivery',
                    totalPrice: docs[i]['totalPrice'],
                  );
                  Orders.placeOrder(
                    orders,
                    docId: docs[i].id,
                    quantity: docs[i]['quantity'],
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

  Padding buildPriceDescription(BuildContext context) {
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
                'Price( 3 items)',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                '15,0000',
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
              Text(
                'Amount Payable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                '150,150',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
