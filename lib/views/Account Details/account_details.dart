import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Account%20Details/widgets/build_textfield.dart';
import 'package:e_commerce_app/views/Account%20Details/widgets/email_textfield.dart';
import 'package:e_commerce_app/views/Account%20Details/widgets/phone_textfield.dart';
import 'package:e_commerce_app/views/Account%20Details/widgets/username_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'widgets/profile_image.dart';

class AccountDetailsScreen extends StatelessWidget {
  AccountDetailsScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final provider = FirebaseAuth.instance.currentUser!.providerData;

  final displayName = FirebaseAuth.instance.currentUser!.displayName;
  final imageUrl = FirebaseAuth.instance.currentUser!.photoURL;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        title: Text(
          'Account Details',
          style: TextStyle(color: themeColor),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                ),
              );
            }
            print(provider[0].providerId.runtimeType);

            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Stack(
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: mediaQuery.height * 0.025,
                        ),
                        BuildProfileImage(
                          mediaQuery: mediaQuery,
                          imageUrl: provider[0].providerId == 'google.com'
                              ? imageUrl
                              : data['imageUrl'],
                        ),
                        SizedBox(
                          height: mediaQuery.height * 0.045,
                        ),
                        AccountUserNameTextfield(
                          hintText: 'Username',
                          initialValue: data['userName'] ?? displayName,
                          controller: nameController,
                        ),
                        SizedBox(
                          height: mediaQuery.height * 0.035,
                        ),
                        Visibility(
                          visible: provider[0].providerId != 'google.com'
                              ? true
                              : false,
                          child: AccountPhoneTextfield(
                            hintText: 'Phone number',
                            initialValue: '+91 ${data['phoneNumber']}',
                          ),
                        ),
                        SizedBox(
                          height: mediaQuery.height * 0.035,
                        ),
                        AccountEmailTextfield(
                          hintText: 'Email',
                          initialValue: data['email'],
                        ),
                        Center(
                          child: Lottie.network(
                            'https://assets2.lottiefiles.com/packages/lf20_z3pnisgt.json',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Center();
          }),
    );
  }
}
