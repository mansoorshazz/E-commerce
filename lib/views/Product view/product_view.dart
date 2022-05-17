import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/cart.dart';
import 'package:e_commerce_app/model/Firebase/favorite.dart';
import 'package:e_commerce_app/views/checkout%20address/checkout_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

class ProductViewScreen extends StatelessWidget {
  ProductViewScreen({
    Key? key,
    // required this.index,
    required this.document,
  }) : super(key: key);

  // final int index;
  final String document;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .doc(document)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        final data = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        String s = data['price'];

        String result = s.split(",").last;
        String result1 = s.split(",").first;

        String addedPrice = result1 + result;
        int price = int.parse(addedPrice);

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              data['productName'],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
            ),
            actions: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Wishlist')
                      .where(
                        'productId',
                        isEqualTo: document,
                      )
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return Text('');
                    }

                    return LikeButton(
                      onTap: (isLiked) {
                        if (snapshot.data!.docs.length == 0) {
                          Favorites favorites = Favorites(
                            productId: document,
                          );
                          Favorites.addToFavorite(
                            favorites,
                            context,
                            data['productName'],
                          );
                          return Future.value(true);
                        }

                        Favorites.deleteToFavorite(
                          context,
                          data['productName'],
                          snapshot.data!.docs[0].id,
                        );

                        return Future.value(false);
                      },
                      likeBuilder: (isTapped) {
                        return snapshot.data!.docs.length == 0
                            ? Icon(
                                Icons.favorite_outline,
                                color: themeColor,
                              )
                            : Icon(
                                Icons.favorite,
                                color: themeColor,
                              );
                      },
                    );
                  }),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    buildCarouselImage(data),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: mediaQuery.height * 0.02,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 26,
                                child: Text(
                                  data['sizeOrVarient'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '₹${data['price']}',
                                style: GoogleFonts.roboto(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: mediaQuery.height * 0.02,
                          ),
                          const Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height * 0.01,
                          ),
                          Text(
                            data['description'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height * 0.02,
                          ),
                          // const Text(
                          //   'Select',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          SizedBox(
                            height: mediaQuery.height * 0.01,
                          ),
                          // buildButtonVarients(),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              buildButtons(
                mediaQuery,
                context,
                productName: data['productName'],
                imageUrl: data['imageUrls'][0],
                price: price,
                sizeOrVarient: data['sizeOrVarient'],
                docId: data.id,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

// ============================================================================
// This method is used to show the varient buttons.

  SizedBox buildButtonVarients() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            height: 20,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
            ),
            child: Center(child: Text('')),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          width: 10,
        ),
        itemCount: 3,
      ),
    );
  }

// ==============================================================================
// adding product to cart method 2.

  Row buildButtons(
    Size mediaQuery,
    BuildContext context, {
    required String imageUrl,
    required String productName,
    required int price,
    required String sizeOrVarient,
    required String docId,
  }) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Carts')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where(
                  'productId',
                  isEqualTo: docId,
                )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: mediaQuery.height * 0.06,
                  width: mediaQuery.width * 0.45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: themeColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }

              final dataLength = snapshot.data!.docs.length;

              if (dataLength == 0) {
                return Bounce(
                  onPressed: () {
                    Cart cart = Cart(
                      totalPrice: price,
                      productId: docId,
                      quantity: 1,
                    );
                    Cart.addToCart(
                      cart: cart,
                      productName: productName,
                      context: context,
                      docId: docId,
                    );
                  },
                  duration: Duration(milliseconds: 150),
                  child: Container(
                    height: mediaQuery.height * 0.06,
                    width: mediaQuery.width * 0.45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: themeColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 18,
                          color: themeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final cartMap = snapshot.data!.docs[0];

              return Container(
                height: mediaQuery.height * 0.06,
                width: mediaQuery.width * 0.45,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: themeColor,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: cartMap['quantity'] == 1
                          ? null
                          : () {
                              Cart.decreaseQuantity(
                                cartMap.id,
                                cartMap['quantity'] - 1,
                                price,
                                totalPrice: cartMap['totalPrice'],
                              );
                            },
                      icon: const Icon(
                        CupertinoIcons.minus,
                        size: 20,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    Text(
                      cartMap['quantity'].toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (cartMap['quantity'] == 5) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            animType: CoolAlertAnimType.slideInLeft,
                            text: "You can't purchase 5 more quantities!",
                          );
                        } else {
                          Cart.increaseQuantity(
                            cartMap.id,
                            cartMap['quantity'] + 1,
                            price,
                          );
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.add,
                        size: 22,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    )
                  ],
                ),
              );
            }),
        const Spacer(),
        Bounce(
          duration: const Duration(
            milliseconds: 150,
          ),
          onPressed: () {
            List<String> productNames = [];
            List<String> imageUrls = [];
            List<String> sizeOrVarients = [];

            productNames.add(productName);
            imageUrls.add(imageUrl);
            sizeOrVarients.add(sizeOrVarient);
            CartProductDetails cartProductDetails = CartProductDetails(
                productName: productNames,
                sizeOrVarinet: sizeOrVarients,
                imageUrl: imageUrls);

            Get.to(CheckOutAddress(
              productId: docId,
              cartProductDetails: cartProductDetails,
              price: price,
              quantity: 1,
            ));
          },
          child: Container(
            height: mediaQuery.height * 0.06,
            width: mediaQuery.width * 0.45,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

// // =========================================================================
// // This method is used to show the cart and buy button.

//   Row buildButtons(
//     Size mediaQuery,
//     BuildContext context, {
//     required String imageUrl,
//     required String productName,
//     required int price,
//     required String sizeOrVarient,
//     required String docId,
//   }) {
//     return Row(
//       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Spacer(),
//         StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('Users')
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .collection('Cart')
//                 .where('productName', isEqualTo: productName)
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container(
//                   height: mediaQuery.height * 0.06,
//                   width: mediaQuery.width * 0.45,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: themeColor,
//                     ),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Add to cart',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: themeColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               final dataLength = snapshot.data!.docs.length;

//               return Bounce(
//                 onPressed: () {
//                   if (dataLength == 0) {
//                     Cart cart = Cart(
//                       imageUrl: imageUrl,
//                       productName: productName,
//                       price: price,
//                       sizeOrVarient: sizeOrVarient,
//                       totalPrice: price,
//                       quantity: 1,
//                     );
//                     Cart.addToCart(cart, productName, context, docId);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         duration: Duration(seconds: 1),
//                         content: Text('$productName already in cart'),
//                       ),
//                     );
//                   }
//                 },
//                 duration: Duration(milliseconds: 150),
//                 child: Container(
//                   height: mediaQuery.height * 0.06,
//                   width: mediaQuery.width * 0.45,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       width: 2,
//                       color: themeColor,
//                     ),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Add to cart',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: themeColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//         Spacer(),
//         Container(
//           height: mediaQuery.height * 0.06,
//           width: mediaQuery.width * 0.45,
//           decoration: BoxDecoration(
//             color: themeColor,
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Center(
//             child: Text(
//               'Buy Now',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//         Spacer(),
//       ],
//     );
//   }

// ====================================================================================
// This method is used to show the carousal product images.

  CarouselSlider buildCarouselImage(data) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        aspectRatio: 1.0,
        enlargeCenterPage: true,
      ),
      items: List.generate(
        data['imageUrls'].length,
        (index) => Container(
          // height: mediaQuery.height * 0.01,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(data['imageUrls'][index]),
              // fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
