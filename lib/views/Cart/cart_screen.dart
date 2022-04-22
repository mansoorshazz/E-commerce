import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/cart.dart';
import 'package:e_commerce_app/views/checkout%20address/checkout_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: themeColor,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
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

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Lottie.network(
                    'https://assets4.lottiefiles.com/datafiles/vhvOcuUkH41HdrL/data.json'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      buildProductviews(snapshot),
                      Divider(
                        thickness: 5,
                      ),
                      buildPriceDescription(context, snapshot)
                    ],
                  ),
                ),
                buildCheckOutButton(context),
                SizedBox(
                  height: 15,
                ),
              ],
            );
          }),
    );
  }

// ========================================================================================================
// This method is used to show the build price description.

  Padding buildPriceDescription(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // final cartitems = snapshot.data;
    //         final List products = cartitems;
    //         double getPrice() {
    //           double price = 0;
    //           cartitems.forEach((x) {
    //             price += x.price * x.numofitem;
    //           });
    //           return price;
    //         }

    final cartItems = snapshot.data;
    var sum = 0;
    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      sum = cartItems!.docs[i]['totalPrice'] + sum;
    }

    var formatter = NumberFormat('#,##,000');

    String convertedSum = formatter.format(sum);
    String convertTotalSum = formatter.format(sum + 150);

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Price( ${snapshot.data!.docs.length} items)',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                '₹$convertedSum',
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
                '₹150',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
            height: 35,
          ),
          Row(
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '₹$convertTotalSum',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //====================================================================================================
  //This method is used to show the product views.

  ListView buildProductviews(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final data = snapshot.data!.docs[index];

        var formatter = NumberFormat('#,##,000');

        String convertPriceTotalSum = formatter.format(data['totalPrice']);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: Image.network(
              data['imageUrl'],
              width: 70,
              height: 70,
            ),
            title: Text(
              data['productName'],
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '₹$convertPriceTotalSum , ${data['sizeOrVarient']}',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (data['quantity'] == 1) {
                      Cart.deleteFromCart(
                          data.id, context, data['productName']);
                    } else {
                      Cart.decreaseQuantity(
                          data.id, data['quantity'] - 1, data['price'],
                          totalPrice: data['totalPrice']);
                    }
                  },
                  icon: const Icon(
                    CupertinoIcons.minus,
                    size: 20,
                  ),
                ),
                Text(
                  data['quantity'].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (data['quantity'] == 5) {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        animType: CoolAlertAnimType.slideInLeft,
                        text: "You can't purchase 5 more quantities!",
                      );
                    } else {
                      Cart.increaseQuantity(
                        data.id,
                        data['quantity'] + 1,
                        data['price'],
                      );
                    }
                  },
                  icon: const Icon(
                    CupertinoIcons.add,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black12,
        height: 10,
      ),
      itemCount: snapshot.data!.docs.length,
    );
  }

// =========================================================================================
// This method is used to show the sign in button.

  ElevatedButton buildCheckOutButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(themeColor),
      ),
      onPressed: () {
        print('checkout');
        Get.to(
          CheckOutAddress(),
          transition: Transition.leftToRight,
        );
        // Get.to(BottomNavBar(), transition: Transition.downToUp);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.height * 0.017,
          horizontal: mediaQuery.height * 0.12,
        ),
        child: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
