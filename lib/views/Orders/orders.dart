import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Orders/Details/order_details.dart';
import 'package:e_commerce_app/widgets/shimmer_lodaing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Orders')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingShimmer();
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Orders!'),
              );
            }

            final docsLength = snapshot.data!.docs.length;

            return ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                height: 20,
              ),
              itemCount: docsLength,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];

                return ListTile(
                  onTap: () => Get.to(
                    OrderDetailsScreen(
                      docId: doc.id,
                    ),
                    transition: Transition.leftToRight,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.network(
                      doc['photoUrl'],
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Ordered on ${doc['orderDetails']['date']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    doc['productName'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    CupertinoIcons.chevron_forward,
                    size: 15,
                  ),
                );
              },
            );
          }),
    );
  }
}
