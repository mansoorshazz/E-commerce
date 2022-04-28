import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/favorite.dart';
import 'package:e_commerce_app/views/Product%20view/product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('Carts').snapshots(),
      //   builder: (
      //     context,
      //     AsyncSnapshot<QuerySnapshot> snapshot,
      //   ) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     return ListView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           final doc = snapshot.data!.docs[index];

      //           return StreamBuilder(
      //               stream: FirebaseFirestore.instance
      //                   .collection('Products')
      //                   .doc(doc['productId'])
      //                   .snapshots(),
      //               builder: (context, AsyncSnapshot snapshot) {
      //                 return ListTile(
      //                   title: Text(snapshot.data['productName'].toString()),
      //                   trailing: IconButton(
      //                     onPressed: () async {},
      //                     icon: Icon(Icons.generating_tokens),
      //                   ),
      //                 );
      //               });
      //         });
      //   },
      // )

      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Wishlist')
              .where(
                'userId',
                isEqualTo: userUid,
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/private_files/lf30_oqpbtola.json',
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .doc(doc['productId'])
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final productMap = snapshot.data;

                      return ListTile(
                        leading: Image.network(
                          productMap['imageUrls'][0],
                          width: 70,
                          height: 70,
                          // fit: BoxFit.cover,
                        ),
                        title: Text(
                          productMap['productName'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '₹${productMap['price']}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.back();
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Delete!',
                                              contentText:
                                                  'Are you sure to delete ${doc['productName']} from wishlist ?',
                                              positiveText: 'YES',
                                              negativeText: 'NO',
                                              positiveTextStyle:
                                                  const TextStyle(
                                                color: Colors.green,
                                              ),
                                              negativeTextStyle:
                                                  const TextStyle(
                                                color: Colors.red,
                                              ),
                                              onPositiveClick: () {
                                                Navigator.of(context).pop();

                                                Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                    Favorites.deleteToFavorite(
                                                      context,
                                                      doc['productName'],
                                                      doc.id,
                                                    );
                                                  },
                                                );
                                              },
                                              onNegativeClick: () {
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          animationType: DialogTransitionType
                                              .slideFromLeftFade,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                      leading: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                      title: Text('Remove from wishlist'),
                                    ),
                                    ListTile(
                                      onTap: () {},
                                      leading: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                      ),
                                      title: Text('Add to cart'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Get.to(
                            ProductViewScreen(
                              document: doc['productId'],
                            ),
                            transition: Transition.leftToRight,
                          );
                        },
                      );
                    });
              },
            );
          }),
    );
  }
}
