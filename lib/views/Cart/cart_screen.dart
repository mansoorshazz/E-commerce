import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/cart.dart';
import 'package:e_commerce_app/views/checkout%20address/checkout_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  List<String> productNames = [];
  List<String> sizeOrVarient = [];
  List<String> imageUrl = [];

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
          icon: const Icon(
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
            .collection('Carts')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // if (snapshot.connectionState ==ConnectionState.) {
          //   return Center(child: Text('l'),);
          // }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Lottie.network(
                'https://assets4.lottiefiles.com/datafiles/vhvOcuUkH41HdrL/data.json',
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    buildProductviews(snapshot),
                    const Divider(
                      thickness: 5,
                    ),
                    buildPriceDescription(
                      context,
                      snapshot,
                    )
                  ],
                ),
              ),
              buildCheckOutButton(
                context,
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        },
        // body: StreamBuilder(
        //   stream: FirebaseFirestore.instance
        //       .collection('Users')
        //       .doc(userId)
        //       .collection('Cart')
        //       .snapshots(),
        //   builder: (
        //     context,
        //     AsyncSnapshot<QuerySnapshot> snapshot,
        //   ) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.data!.docs.isEmpty) {
        //       return Center(
        //         child: Lottie.network(
        //           'https://assets4.lottiefiles.com/datafiles/vhvOcuUkH41HdrL/data.json',
        //         ),
        //       );
        //     }

        //     return Column(
        //       children: [
        //         Expanded(
        //           child: ListView(
        //             physics: const BouncingScrollPhysics(),
        //             children: [
        //               buildProductviews(snapshot),
        //               const Divider(
        //                 thickness: 5,
        //               ),
        //               buildPriceDescription(
        //                 context,
        //                 snapshot,
        //               )
        //             ],
        //           ),
        //         ),
        //         buildCheckOutButton(
        //           context,
        //           snapshot,
        //         ),
        //         const SizedBox(
        //           height: 15,
        //         ),
        //       ],
        //     );
        //   },
        // ),
      ),
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
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '₹$convertedSum',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
        final cartData = snapshot.data!.docs[index];

        var formatter = NumberFormat('#,##,000');

        String convertPriceTotalSum = formatter.format(cartData['totalPrice']);

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Products")
                .doc(cartData['productId'])
                .snapshots(),
            builder: (context, AsyncSnapshot psnapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (psnapshot.data == null) {
                return Text('');
              }

              final productData = psnapshot.data;

              String s = productData['price'];

              String result = s.split(",").last;
              String result1 = s.split(",").first;

              String addedPrice = result1 + result;

              int price = int.parse(addedPrice);

              productNames.add(productData['productName']);
              sizeOrVarient.add(productData['sizeOrVarient']);
              imageUrl.add(productData['imageUrls'][0]);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Image.network(
                    productData['imageUrls'][0],
                    // 'https://i.guim.co.uk/img/media/c699b4c005a687be3bae6784b8731686d5b111c1/116_314_4331_2598/master/4331.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=a470f4b8de2e35550d64a6d5df2c379a',
                    width: 70,
                    height: 70,
                  ),
                  title: Text(
                    productData['productName'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '₹$convertPriceTotalSum , ${productData['sizeOrVarient']}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (cartData['quantity'] == 1) {
                            Cart.deleteFromCart(
                              docId: cartData.id,
                              context: context,
                              productName: productData['productName'],
                            );
                          } else {
                            Cart.decreaseQuantity(
                              cartData.id,
                              cartData['quantity'] - 1,
                              price,
                              totalPrice: cartData['totalPrice'],
                            );
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.minus,
                          size: 20,
                        ),
                      ),
                      Text(
                        cartData['quantity'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (cartData['quantity'] == 5) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              animType: CoolAlertAnimType.slideInLeft,
                              text: "You can't purchase 5 more quantities!",
                            );
                          } else {
                            Cart.increaseQuantity(
                              cartData.id,
                              cartData['quantity'] + 1,
                              price,
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
            });
      },
      separatorBuilder: (context, index) {
        return snapshot.data!.docs.isEmpty
            ? SizedBox()
            : Divider(
                color: Colors.black12,
                height: 10,
              );
      },
      itemCount: snapshot.data!.docs.length,
    );
  }

// =========================================================================================
// This method is used to show the sign in button.

  ElevatedButton buildCheckOutButton(
    BuildContext context,
  ) {
    final mediaQuery = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(themeColor),
      ),
      onPressed: () {
        CartProductDetails cartProductDetails = CartProductDetails(
          productName: productNames,
          sizeOrVarinet: sizeOrVarient,
          imageUrl: imageUrl,
        );

        Get.to(
          CheckOutAddress(
            cartProductDetails: cartProductDetails,
          ),
          transition: Transition.leftToRight,
        );
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
