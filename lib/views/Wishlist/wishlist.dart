import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/favorite.dart';
import 'package:e_commerce_app/views/Product%20view/product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userUid)
              .collection('Favorites')
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
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                return ListTile(
                  leading: Image.network(
                    doc['imageUrl'],
                    width: 70,
                    height: 70,
                    // fit: BoxFit.cover,
                  ),
                  title: Text(
                    doc['productName'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '₹${doc['price']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
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
                                    animationType:
                                        DialogTransitionType.slideFromLeftFade,
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
                        document: doc.id,
                      ),
                      transition: Transition.leftToRight,
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
