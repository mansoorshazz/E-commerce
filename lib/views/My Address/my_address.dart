import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/model/Firebase/address.dart';
import 'package:e_commerce_app/views/My%20Address/Add%20address/add_address.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/edit_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAdressScreen extends StatelessWidget {
  MyAdressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final addressStyle = TextStyle(
      fontSize: 17,
      color: Colors.black,
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Address',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          buildAddAddressbutton(mediaQuery),
          showAdresses(addressStyle, context),
        ],
      ),
    );
  }

// ====================================================================================================
// This method is used to show the add address button.

  GestureDetector buildAddAddressbutton(Size mediaQuery) {
    return GestureDetector(
      onTap: () {
        Get.to(
          AddAddressScreen(),
          transition: Transition.downToUp,
        );
      },
      child: ClayContainer(
        emboss: true,
        child: Row(
          children: [
            SizedBox(
              width: mediaQuery.width * 0.05,
            ),
            Icon(CupertinoIcons.add_circled, size: 25),
            SizedBox(
              width: mediaQuery.width * 0.04,
            ),
            Text(
              'Add a new address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        color: Colors.white,
        height: 70,
      ),
    );
  }

  //========================================================================
  // This method is used to show the address represent by listview builder.

  showAdresses(TextStyle addressStyle, BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Addresses')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: themeColor,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No saved addresses!',
                  style: addressStyle,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.active) {
              return Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                doc['userName'],
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () {
                                  Get.to(
                                    EditAddressScreen(
                                      docId: doc.id,
                                      userName: doc['userName'],
                                      phoneNumber: doc['phoneNumber'],
                                      pincode: doc['pincode'],
                                      state: doc['state'],
                                      city: doc['city'],
                                    ),
                                    transition: Transition.leftToRight,
                                  );
                                },
                                child: const Text(
                                  'Edit',
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  showAnimatedDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return ClassicGeneralDialogWidget(
                                        titleText: 'Delete',
                                        contentText: 'Are you sure?',
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
                                              Address.deletedAdrress(
                                                doc.id,
                                                context,
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
                                        DialogTransitionType.slideFromTop,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                          Text(
                            doc['city'],
                            style: addressStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['pincode'],
                            style: addressStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['state'],
                            style: addressStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['phoneNumber'],
                            style: addressStyle,
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 10,
                  ),
                ),
              );
            }

            return Container();
          });
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
