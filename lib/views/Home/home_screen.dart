import 'package:badges/badges.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/home_controller.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Cart/cart_screen.dart';
import 'package:e_commerce_app/views/Home/widgets/shimmer_loading.dart';
import 'package:e_commerce_app/views/Product%20view/product_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../model/Firebase/favorite.dart';
import 'widgets/product_loading.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // final ScrollController controller = ScrollController();
  final instance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.put(HomeController());

    // print(FirebaseAuth.instance.currentUser!.uid);

    final mediaQuery = MediaQuery.of(context).size;

    return Container(
      color: Colors.grey.shade100,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildSliverAppbar(context),
            ],
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.04,
                    vertical: mediaQuery.width * 0.025,
                  ),
                  child: const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                buildCategories(
                  context,
                ),
                // buildBanner(
                //   context,
                //   homecontroller,
                // ),
                buildProducts(
                  context,
                  homecontroller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//===========================================================================================================
// This method is used to show the category wise products.

  buildProducts(
    BuildContext context,
    HomeController homeController,
  ) {
    final mediaQuery = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(builder: (controller) {
      if (controller.categoryNames.isEmpty) {
        controller.getTheCategoryNames();
        return ProductLoadingWidget(mediaQuery: MediaQuery.of(context).size);
      } else {
        return StreamBuilder(
          stream: instance
              .collection('Products')
              .where(
                'category',
                isEqualTo: controller.categoryNames[controller.tappedIndex],
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ProductLoadingWidget(
                mediaQuery: mediaQuery,
              );
            }

            if (snapshot.connectionState == ConnectionState.active) {
              return SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.03,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3 / 4.3,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final mediaQuery = MediaQuery.of(context).size;
                      return Bounce(
                        onPressed: () {
                          Get.to(
                            ProductViewScreen(
                              // index: index,
                              document: doc.id,
                            ),
                            transition: Transition.cupertinoDialog,
                          );
                        },
                        duration: Duration(milliseconds: 150),
                        child: Card(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: mediaQuery.height * 0.188,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              doc['imageUrls'][0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.height * 0.010,
                                      ),
                                      Text(
                                        doc['productName'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.height * 0.008,
                                      ),
                                      Text(
                                        '₹${doc['price']}',
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.height * 0.008,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: mediaQuery.width * 0.315,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('Favorites')
                                        .where('productName',
                                            isEqualTo: doc['productName'])
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.data == null) {
                                        return Text('');
                                      }

                                      return LikeButton(
                                        onTap: (isLiked) {
                                          if (snapshot.data!.docs.length == 0) {
                                            Favorites favorites = Favorites(
                                              productName: doc['productName'],
                                              price: doc['price'],
                                              imageUrl: doc['imageUrls'][0],
                                            );
                                            Favorites.addToFavorite(
                                              favorites,
                                              context,
                                              doc['productName'],
                                              doc.id,
                                            );
                                            return Future.value(true);
                                          }

                                          Favorites.deleteToFavorite(
                                            context,
                                            doc['productName'],
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
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return Container();
          },
        );
      }
    });
  }

// ==================================================================================
// This method is used to show the video hotsale video banner.

  buildBanner(BuildContext context, HomeController controller) {
    final mediaQuery = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(
        mediaQuery.width * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hot Sales',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Container(
            // height: mediaQuery.height * 0.447,
            // width: double.infinity,
            // color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: YoutubePlayer(
                controller: controller.youtubePlayerController!,
                onEnded: (meta) {
                  controller.youtubePlayerController!.setVolume(0);
                  print(
                      '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');

                  print(meta);
                  print(''' 
                    12
                    ''');
                },
                onReady: () {
                  controller.youtubePlayerController!.setVolume(0);
                  print('video started');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

// =================================================
// This method is used to show the build categories.

  buildCategories(
    BuildContext context,
  ) {
    final mediaQuery = MediaQuery.of(context).size;

    try {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidgetShimmer();
          }

          if (snapshot.data!.docs.isEmpty) {
            Center(
              child: Text('0 categories'),
            );
          }

          return SizedBox(
            height: mediaQuery.height * 0.12,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width * 0.027),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GetBuilder<HomeController>(builder: (controller) {
                        return GestureDetector(
                          onTap: () {
                            controller.changeCategory(index);
                          },
                          child: Container(
                            width: mediaQuery.width * 0.19,
                            height: mediaQuery.width * 0.19,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: NetworkImage(doc['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: controller.tappedIndex == index
                                    ? themeColor
                                    : Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 5,
                      ),
                      GetBuilder<HomeController>(builder: (controller) {
                        return Text(
                          doc['categoryName'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: controller.tappedIndex == index
                                ? themeColor
                                : Colors.black,
                          ),
                        );
                      })
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    } catch (e) {
      print('error thrown jfld');
    }
  }

// =======================================================================================

  SliverAppBar buildSliverAppbar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Row(
          children: [
            Text(
              'Shoppy',
              style: TextStyle(
                color: themeColor,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            const Icon(
              CupertinoIcons.cart,
              color: Colors.black,
              // size: 25,
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            print('tapped');
            Get.to(
              CartScreen(),
              transition: Transition.fade,
            );
          },
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Cart')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Icon(CupertinoIcons.cart_fill);
                }

                return Badge(
                  position: BadgePosition.topEnd(top: 1),
                  animationDuration: Duration(milliseconds: 300),
                  animationType: BadgeAnimationType.slide,
                  badgeColor: themeColor,
                  badgeContent: Text(
                    snapshot.data!.docs.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(
                    CupertinoIcons.cart_fill,
                    color: Colors.black,
                  ),
                );
              }),
        ),
        SizedBox(
          width: mediaQuery.width * 0.07,
        ),
      ],
      bottom: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: mediaQuery.height * 0.055,
          child: const TextField(
            enabled: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(CupertinoIcons.search),
              ),
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black45,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
