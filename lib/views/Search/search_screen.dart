import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/search_controller.dart';
import 'package:e_commerce_app/views/Product%20view/product_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());

    return Scaffold(
      appBar: buildSearchAppbar(),
      body: GetBuilder<SearchController>(builder: (controller) {
        return FutureBuilder(
            future: FirebaseFirestore.instance.collection('Products').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Map> searchList = getSearchList(
                snapshot,
                controller.searchText,
              );

              if (searchList.isEmpty) {
                return Center(
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_shvej97v.json',
                  ),
                );
              }

              return ListView.builder(
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  Map searchMap = searchList[index];

                  return ListTile(
                    onTap: () {
                      Get.to(
                        ProductViewScreen(
                          document: searchMap['id'],
                        ),
                      );
                    },
                    trailing: const Icon(Icons.search),
                    leading: Image.network(
                      searchMap['imageUrl'],
                      height: 30,
                      width: 30,
                    ),
                    title: Text(
                      searchMap['productName'],
                    ),
                  );
                },
              );
            });
      }),
    );
  }

// ============================================================================================
// This method is used to show the searching app bar it means the title is a textfield.

  AppBar buildSearchAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: GetBuilder<SearchController>(
        builder: (controller) {
          return TextField(
            cursorHeight: 21,
            onChanged: (String value) {
              controller.getSearchTExt(value);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search products',
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// This method is used to convert the filter search list.

getSearchList(AsyncSnapshot<QuerySnapshot> snapshot, String searchQuery) {
  List<Map> searchedList = snapshot.data!.docs
      .where(
    (element) => element['productName']
        .toString()
        .toLowerCase()
        .contains(searchQuery.toLowerCase()),
  )
      .map(
    (e) {
      // print(e);
      return {
        'productName': e['productName'],
        'id': e.id,
        'imageUrl': e['imageUrls'][0]
        // 'imageUrl': e[0]['imageUrls']
      };
    },
  ).toList();

  print(searchedList);

  return searchedList;
}
